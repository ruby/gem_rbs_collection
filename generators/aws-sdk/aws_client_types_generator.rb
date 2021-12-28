#! /usr/bin/env ruby

# see also aws-sdk-ruby/Rakefile
$REPO_ROOT = "#{File.dirname(__FILE__)}/_src"
$GEMS_DIR = "#{$REPO_ROOT}/gems"
$CORE_LIB = "#{$REPO_ROOT}/gems/aws-sdk-core/lib"

$:.unshift("#{$REPO_ROOT}/build_tools")
$:.unshift("#{$REPO_ROOT}/build_tools/aws-sdk-code-generator/lib")
Dir["#{$GEMS_DIR}/*"].each do |dir|
  $:.unshift("#{dir}/lib")
end

require 'build_tools'
require 'aws-sdk-core'
require 'aws-sdk-code-generator'
require 'json'
require 'rbs'

# Minimal Hack
class AwsSdkCodeGenerator::Views::ClientClass
  def render
    self
  end
end

using Module.new {
  refine String do
    def underscore
      AwsSdkCodeGenerator::Underscore.underscore(self)
    end
  end
}

class AwsClientTypesGenerator
  def initialize(path)
    @api = File.open(path) do |file|
      JSON.parse(file.read)
    end
  end

  def escape(key)
    RBS::Parser::KEYWORDS.key?(key) ? "#{key}_" : key
  end

  def types(name)
    if RBS::Parser::KEYWORDS.key?(name)
      name
    else
      "Types::#{name}"
    end
  end

  def type(name, types_prefix: false)
    if structure?(name)
      name
    else
      escape(name.underscore)
    end.then { types_prefix ? types(_1) : _1 }
  end

  def structure?(name)
    @api.dig("shapes", name, "type") == "structure"
  end

  def service_id
    @api.dig("metadata", "serviceId").tr(' ', '')
  end

  def identifier
    service_id.downcase
  end

  def client_options
    require "aws-sdk-#{identifier}"
    client_class = Aws.const_get(service_id)::Client
    public_options = client_class.plugins.map(&:options).flatten.select(&:documented?)
    # see also aws-sdk-ruby/build_tools/aws-sdk-code-generator/lib/aws-sdk-code-generator/client_constructor.rb
    ordered_public_options = public_options.sort_by.with_index do |opt, i|
      [opt.required ? 'a' : 'b', opt.name, i]
    end
    buffer = ordered_public_options.map do |opt|
      type = case opt.name
        when :retry_mode
          '("legacy" | "standard" | "adaptive")'
        when :retry_jitter
          "(:none | :equal | :full | ^(Integer) -> Integer)"
        when :endpoint, :credentials, :log_formatter, :client_side_monitoring_publisher, :logger
          # TODO: Just not supported yet
          "untyped"
        else
          case opt.doc_type
          when "Boolean"
            "bool"
          when nil
            raise opt.inspect
          else
            opt.doc_type.to_s
          end
        end
      [opt.name, "?#{opt.name}: #{type}#{opt.required ? "" : "?"}", opt.doc_type]
    end
    # Find duplicated key
    grouped = buffer.group_by { |name, rbs| name }
    grouped.transform_values(&:count).find_all { |name, v| 1 < v }.each do |name,|
      warn("Duprecate client option: `#{grouped[name].map { |g| g.values_at(0, 2) }}`", uplevel: 0)
    end
    buffer.uniq { |b| b[0] }.map { |b| b[1] }
  end

  def write(io)
    io.puts <<~COMMENT
    # WARNING ABOUT GENERATED CODE
    #
    # This file is generated. See the generator README.md for more information:
    # https://github.com/ruby/gem_rbs_collection/blob/main/generators/aws-sdk/README.md
    #
    # WARNING ABOUT GENERATED CODE
    COMMENT
    io.puts
    io.puts "module Aws"
    io.puts "  class EmptyStructure"
    io.puts "  end"
    io.puts "  module #{@api["metadata"]["serviceId"].tr(' ', '')}"
    io.puts "    class Client"
    io.puts "      def self.new: (#{client_options.join(", ")}) -> instance"
    @api["operations"].each do |key, body|
      input = body.dig("input", "shape")&.then { |i| shape_to_kwargs(i, allow_opt: true, types_prefix: true) }
      output = body.dig("output", "shape")&.then { |o| types(o) } || "Aws::EmptyStructure"
      name = body["name"].underscore
      io.puts "      def #{name}: (#{input}) -> #{output}"
    end
    io.puts "    end"
    io.puts "    module Types"
    @api["shapes"].each do |key, body|
      if body["type"] == "structure"
        next if body["exception"]
        io.puts "      class #{key}"
        body["members"]&.each do |member_name, member_body|
          io.puts "        attr_accessor #{escape(member_name.underscore)}: #{shape_to_rbs_type(member_body["shape"], types_prefix: false)}"
        end
        io.puts "      end"
      else
        io.puts "      type #{escape(key.underscore)} = #{shape_to_rbs_type(key, types_prefix: false)}"
      end
    end
    io.puts "    end"
    io.puts "    module Errors"
    @api["shapes"].each do |key, body|
      if body["type"] == "structure" && body["exception"]
        io.puts "      class #{key} < RuntimeError"
        body["members"]&.each do |member_name, member_body|
          io.puts "        attr_accessor #{escape(member_name.underscore)}: #{shape_to_rbs_type(member_body["shape"], types_prefix: true)}"
        end
        io.puts "      end"
      end
    end
    io.puts "    end"
    io.puts "  end"
    io.puts "end"
  end

  def shape_to_rbs_type(shape_name, types_prefix: false)
    shape_body = @api["shapes"][shape_name]
    case type = shape_body["type"]
    when "string"
      if shape_body["enum"]
        "(#{shape_body["enum"].map { "\"#{_1}\"" }.join(" | ")})"
      else
        "::String"
      end
    when "integer", "long"
      "::Integer"
    when "double"
      "::Float"
    when "timestamp"
      case shape_body["timestampFormat"]
      when "iso8601", "rfc822", nil
        "::Time"
      else
        raise [shape_name, shape_body].inspect
      end
    when "list"
      "::Array[#{type(shape_body["member"]["shape"], types_prefix: types_prefix)}]"
    when "map"
      key_type = type(shape_body["key"]["shape"], types_prefix: types_prefix)
      value_type = type(shape_body["value"]["shape"], types_prefix: types_prefix)
      "::Hash[#{key_type}, #{value_type}]"
    when "structure"
      shape_name
    when "boolean"
      "bool"
    when "blob"
      "::IO"
    else
      raise "unimplemented shape type #{type} on #{shape_name}"
    end
  end

  def shape_to_kwargs(shape_name, allow_opt: false, types_prefix: false)
    shape_body = @api["shapes"].fetch(shape_name)
    members = shape_body["members"]
    raise if members.empty?
    required = shape_body["required"]
    params = members.map do |member_name, member_body|
      member_shape_name = member_body["shape"]
      member_type = type(member_shape_name, types_prefix: types_prefix)
      prefix = (required && required.include?(member_name)) ? "" : "?"
      prefix = allow_opt ? prefix : ""
      "#{prefix}#{member_name.underscore}: #{member_type}"
    end
    params.join(", ")
  end
end

AwsClientTypesGenerator.new(ARGV[0]).write($stdout)
