# frozen_string_literal: true

module AwsSdkRbsGenerator
  class ShapeDictionary
    class Shape
      attr_reader :name, :kind, :dictionary, :ref
      attr_accessor :request

      def initialize(name:, kind:, dictionary:, request:, ref:)
        @name = name
        @kind = kind
        @dictionary = dictionary
        @request = request
        @ref = ref
      end

      # for Array#uniq
      def hash
        name.hash ^ kind.hash ^ request.hash ^ ref.hash
      end

      # for Array#uniq
      def eql?(other)
        return false unless other.is_a?(Shape)
        return false unless name == other.name
        return false unless kind == other.kind
        return false unless request == other.request
        return false unless ref == other.ref

        true
      end
      alias == eql?

      def fetch_body
        dictionary.service.api.fetch("shapes").fetch(name)
      end

      def as_keyword_arguments(from:)
        shape_body = fetch_body
        members = shape_body[:members]
        required = shape_body[:required]
        type_prefix = case from
          when :operations
            "Types::"
          when :types
            ""
          else
            raise from.to_s
          end
        params = members.map do |member_name, member_body|
          member_shape_name = member_body[:shape]
          member_shapes = dictionary[member_shape_name]
          case from
          when :operations
            opt_prefix = required&.include?(member_name) ? "" : "?"
            opt_suffix = ""
            member_shape = member_shapes.find(&:input?) or raise
          when :types
            opt_prefix = ""
            opt_suffix = required&.include?(member_name) ? "" : "?"
            member_shape = member_shapes.find(&:input?) or raise
          else
            raise from
          end
          "#{opt_prefix}#{member_name.underscore}: #{type_prefix}#{member_shape.rbs_underscore_name}#{opt_suffix}"
        end
        params.join(", ")
      end

      def rbs_name
        if structure? && !input?
          name
        else
          rbs_underscore_name
        end
      end

      def rbs_print_name
        case kind
        when :input
          rbs_input_name
        when :output
          rbs_output_name
        when :exception
          rbs_exception_name
        else
          raise
        end
      end

      # TODO: split for input and output
      def to_rbs_returns
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
          shape = dictionary[shape_body.fetch("member").fetch("shape")].find { |s| s.kind == kind } or raise
          "::Array[#{shape.rbs_name}]"
        when "map"
          key_shape = dictionary[shape_body.fetch("key").fetch("shape")].find { |s| s.kind == kind } or raise
          value_shape = dictionary[shape_body.fetch("value").fetch("shape")].find { |s| s.kind == kind } or raise
          "::Hash[#{key_shape.rbs_name}, #{value_shape.rbs_name}]"
        when "structure"
          rbs_name
        when "boolean"
          "bool"
        when "blob"
          if streaming?
            "::IO"
          else
            "::String"
          end
        else
          raise "unimplemented shape type #{type} on #{name}"
        end
      end

      # It supports like following types(e.g. aw-sdk-s3)
      #   type cors_rules_input = ::Array[cors_rule]
      #   type cors_rule = { id: id?, ... }
      #
      #   type cors_rules_output = ::Array[CORSRule]
      #   class CORSRule
      #   end
      def need_name_with_kind?
        shape_body = fetch_body
        case shape_body.fetch("type")
        when "list"
          member_shapes = dictionary[shape_body.fetch("member").fetch("shape")]
          1 < member_shapes.length && !!member_shapes.find(&:structure?)
        when "map"
          key_shapes = dictionary[shape_body.fetch("key").fetch("shape")]
          value_shapes = dictionary[shape_body.fetch("value").fetch("shape")]
          (1 < key_shapes.length && !!key_shapes.find(&:structure?)) || (1 < value_shapes.length && !!value_shapes.find(&:structure?))
        else
          false
        end
      end

      def class?
        return false unless output?
        return false unless fetch_body.fetch("type") == "structure"

        true
      end

      def alias?
        !class?
      end

      def rbs_underscore_name
        if need_name_with_kind?
          rbs_underscore_name_with_kind
        else
          rbs_underscore_name_without_kind
        end
      end

      def rbs_underscore_name_with_kind
        "#{rbs_underscore_name_without_kind}_#{kind}"
      end

      def rbs_underscore_name_without_kind
        "#{escape(name.underscore)}#{streaming? ? "_streaming" : ""}"
      end

      def rbs_input_name
        rbs_underscore_name
      end

      def rbs_output_name
        body = fetch_body
        case body.fetch("type")
        when "structure"
          name
        else
          rbs_underscore_name
        end
      end

      def rbs_exception_name
        name
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
          to_rbs_returns
        end
        "type #{rbs_input_name} = #{rbs}"
      end

      def rbs_as_alias
        case kind
        when :input
          rbs_as_input
        when :output
          rbs_as_alias_output
        end
      end

      def output_structure_members
        fetch_body.fetch(:members, []).map do |member_name, member_body|
          shape = dictionary[member_body["shape"]].find(&:output?)
          raise "#{member_body["shape"]} shape by output not found" unless shape
          MethodSignature.new(
            method_name: escape(member_name.underscore),
            arguments: nil,
            returns: shape.rbs_name,
          )
        end
      end

      def output_structure_members_empty?
        output_structure_members.empty?
      end

      def rbs_as_alias_output
        "type #{rbs_underscore_name} = #{to_rbs_returns}".tap { dictionary.printed[rbs_underscore_name] = _1 }
      end

      def escape(str)
        RBS::Parser::KEYWORDS.key?(str) ? "#{str}_" : str
      end

      def streaming?
        !!ref[:streaming]
      end

      def structure?
        fetch_body.fetch("type") == "structure"
      end

      def input? = kind == :input
      def output? = kind == :output
      def exception? = kind == :exception
    end
  end
end
