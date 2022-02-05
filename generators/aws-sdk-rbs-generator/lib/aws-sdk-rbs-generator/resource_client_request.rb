# frozen_string_literal: true

module AwsSdkRbsGenerator
  class ResourceClientRequest
    attr_reader :method_name
    attr_reader :arguments
    attr_reader :returns

    def initialize(method_name:, service:, request:, returns:, skip: [])
      @method_name = method_name
      @returns = returns

      operation = service.api[:operations][request[:operation]]
      shape_ref = operation[:input]
      input_shape = AwsSdkCodeGenerator::Api.shape(shape_ref, service.api)
      skip = Set.new(skip + AwsSdkCodeGenerator::ResourceSkipParams.compute(input_shape, request))
      @arguments = if input_shape
        input_shape[:members].filter_map { |member_name, member_ref|
          next if skip.include?(member_name)
          required = input_shape.fetch(:required, []).include?(member_name)
          types_name = service.shape_dictionary[member_ref[:shape]].find(&:input?).rbs_input_name
          "#{required ? "" : "?"}#{member_name.underscore}: Types::#{types_name}"
        }.join(", ")
      end
    end

    def build_method_signature
      MethodSignature.new(
        method_name:,
        arguments:,
        returns:,
      )
    end
  end
end
