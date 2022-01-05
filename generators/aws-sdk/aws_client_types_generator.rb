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

require 'aws-sdk-core'
require 'aws-sdk-code-generator'
require 'json'
require 'rbs'

using Module.new {
  refine String do
    def underscore
      AwsSdkCodeGenerator::Underscore.underscore(self)
    end

    def escape
      RBS::Parser::KEYWORDS.key?(self) ? "#{self}_" : self
    end
  end
}

class AwsClientTypesGenerator
  class Shape
    INDENT = " " * 6

    attr_reader :name, :kind, :generator, :streaming
    attr_accessor :request
    def initialize(name:, kind:, generator:, request:, streaming:)
      @name = name
      @kind = kind
      @generator = generator
      @request = request
      @streaming = streaming
    end

    def assert_input!
      unless kind == :input
        raise "#{name} should be input shape"
      end
    end

    def fetch_body
      generator.api.fetch("shapes").fetch(name)
    end

    def as_keyword_arguments(from:)
      shape_body = fetch_body
      members = shape_body["members"]
      required = shape_body["required"]
      type_prefix = case from
        when :operations
          "Types::"
        when :types
          ""
        else
          raise from
        end
      params = members.map do |member_name, member_body|
        member_shape_name = member_body["shape"]
        member_shape = generator.fetch_shapes(member_shape_name).first
        if from == :types
          opt_prefix = ""
          opt_suffix = required&.include?(member_name) ? "" : "?"
        else
          opt_prefix = required&.include?(member_name) ? "" : "?"
          opt_suffix = ""
        end
        "#{opt_prefix}#{member_name.underscore}: #{type_prefix}#{member_shape.underscore_name}#{opt_suffix}"
      end
      params.join(", ")
    end

    def rbs_name
      if structure? && !input?
        name
      else
        underscore_name
      end
    end

    def to_rbs
      shape_body = fetch_body
      case type = shape_body["type"]
      when "string"
        if shape_body["enum"]
          "(#{shape_body["enum"].map { "\"#{_1}\"" }.join(" | ")})"
        else
          "::String"
        end
      when "integer", "long"
        "::Integer"
      when "float", "double"
        "::Float"
      when "timestamp"
        case shape_body["timestampFormat"]
        when "iso8601", "rfc822", nil
          "::Time"
        else
          raise [name, shape_body].inspect
        end
      when "list"
        shape = generator.fetch_shapes(shape_body.fetch("member").fetch("shape")).find { |s| s.kind == kind }
        "::Array[#{shape.rbs_name}]"
      when "map"
        key_shape = generator.fetch_shapes(shape_body.fetch("key").fetch("shape")).find { |s| s.kind == kind }
        value_shape = generator.fetch_shapes(shape_body.fetch("value").fetch("shape")).find { |s| s.kind == kind }
        "::Hash[#{key_shape.rbs_name}, #{value_shape.rbs_name}]"
      when "structure"
        rbs_name
      when "boolean"
        "bool"
      when "blob"
        if streaming
          "::IO"
        else
          "::String"
        end
      else
        raise "unimplemented shape type #{type} on #{name}"
      end
    end

    def underscore_name
      name.underscore.escape
    end

    def structure?
      fetch_body.fetch("type") == "structure"
    end

    def rbs_as_input
      rbs = if structure?
        args = as_keyword_arguments(from: :types)
        if args.empty?
          # rbs does not supported empty record
          "::Hash[untyped, untyped]"
        else
          "{ #{args} }"
        end
      else
        to_rbs
      end
      return if generator.printed[underscore_name]
      generator.printed[underscore_name] = true
      "#{INDENT}type #{underscore_name} = #{rbs}"
    end

    def rbs_as_output
      body = fetch_body
      case body.fetch("type")
      when "structure"
        return if generator.printed[name]
        generator.printed[name] = true
        result = +"#{INDENT}class #{name}\n"
        body["members"]&.each do |member_name, member_body|
          shape = generator.fetch_shapes(member_body["shape"]).find(&:output?)
          raise "#{member_body["shape"]} shape by output not found" unless shape
          rbs = if shape.structure?
            shape.name
          else
            shape.underscore_name
          end
          result << "#{INDENT}  attr_accessor #{member_name.underscore.escape}: #{rbs}\n"
        end
        result << "#{INDENT}end\n"
        result
      else
        return if generator.printed[underscore_name]
        generator.printed[underscore_name] = true
        "#{INDENT}type #{underscore_name} = #{to_rbs}"
      end
    end

    def rbs_as_exception
      return if generator.printed[name]
      generator.printed[name] = true
      body = fetch_body
      result = +"#{INDENT}class #{name} < ::RuntimeError\n"
      body["members"]&.each do |member_name, member_body|
        shape = generator.fetch_shapes(member_body["shape"]).find(&:exception?)
        raise "#{member_body["shape"]} shape by exception not found" unless shape
        result << "#{INDENT}  attr_accessor #{member_name.underscore.escape}: #{shape.to_rbs}\n"
      end
      result << "#{INDENT}end\n"
      result
    end

    def input? = kind == :input
    def output? = kind == :output
    def exception? = kind == :exception
  end

  attr_reader :shape_table, :api, :printed

  def initialize(path)
    @shape_table = {}
    @printed = {}
    @api = File.open(path) do |file|
      JSON.parse(file.read)
    end
    @api.fetch("operations").each do |_key, body|
      body.dig("input", "shape")&.tap do |name|
        walk_as(kind: :input, name: name).tap do |root_shape|
          root_shape.request = true
        end
      end
      body.dig("output", "shape")&.then do |name|
        walk_as(kind: :output, name: name)
      end
    end
    @api.fetch("shapes").each do |key, body|
      if body.fetch("type") == "structure" && body["exception"]
        walk_as(kind: :exception, name: key)
      end
    end
  end

  def inspect
    "#<AwsClientTypesGenerator:#{object_id}>"
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
            opt.doc_type
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

  def shape_body(shape_name)
    @api["shapes"].fetch(shape_name)
  end

  def walk_as(kind:, name:, streaming: false)
    root_shape = add_shape(name: name, kind: kind, streaming: streaming)
    body = shape_body(name)
    case body.fetch("type")
    when "structure"
      body.fetch("members").each do |_member_name, member_body|
        walk_as(kind: kind, name: member_body.fetch("shape"), streaming: member_body["streaming"])
      end
    when "list"
      walk_as(kind: kind, name: body.fetch("member").fetch("shape"))
    when "map"
      walk_as(kind: kind, name: body.fetch("key").fetch("shape"))
      walk_as(kind: kind, name: body.fetch("value").fetch("shape"))
    end
    root_shape
  end

  def add_shape(name:, kind:, streaming:)
    new_shape = Shape.new(
      name: name,
      kind: kind,
      generator: self,
      request: nil,
      streaming: streaming,
    )
    if @shape_table[name]
      if !@shape_table[name].any? { _1.kind == kind }
        @shape_table[name] << new_shape
      end
    else
      @shape_table[name] = [new_shape]
    end
    new_shape
  end

  def fetch_shapes(shape_name)
    @shape_table.fetch(shape_name)
  end

  def input_shapes
    @shape_table.flat_map do |_shape_name, shapes|
      shapes.select(&:input?)
    end
  end

  def output_shapes
    @shape_table.flat_map do |_shape_name, shapes|
      shapes.select(&:output?)
    end
  end

  def exception_shapes
    @shape_table.flat_map do |_shape_name, shapes|
      shapes.select(&:exception?)
    end
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
    io.puts "  module #{@api["metadata"]["serviceId"].tr(' ', '')}"
    io.puts "    class Client"
    io.puts "      def self.new: (#{client_options.join(", ")}) -> instance"
    @api["operations"].each do |key, body|
      name = body.fetch("name").underscore
      input_shape = body.dig("input", "shape")&.then { fetch_shapes(_1).find(&:input?).as_keyword_arguments(from: :operations) }
      output_shape = body.dig("output", "shape")&.then { "Types::#{_1}" } || "Aws::EmptyStructure"
      io.puts "      def #{name}: (#{input_shape}) -> #{output_shape}"
    end
    io.puts "    end"
    io.puts "    module Types"
    @api.fetch("shapes").each do |key, _body|
      fetch_shapes(key).each do |shape|
        case shape.kind
        when :input
          if !shape.request
            shape.rbs_as_input&.then { io.puts(_1) }
          end
        when :output
          shape.rbs_as_output&.then { io.puts(_1) }
        end
      end
    end
    io.puts "    end"
    io.puts "    module Errors"
    @api.fetch("shapes").each do |key, _body|
      fetch_shapes(key).each do |shape|
        if shape.exception?
          shape.rbs_as_exception&.then { io.puts(_1) }
        end
      end
    end
    io.puts "    end"
    io.puts "  end"
    io.puts "end"
  end
end

AwsClientTypesGenerator.new(ARGV[0]).write($stdout)
