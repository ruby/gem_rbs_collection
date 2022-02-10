# frozen_string_literal: true

module AwsSdkRbsGenerator
  class ResourceBatchAction
    class << self
      def build_method_signature_list(resource:, service:)
        resource.fetch(:batchActions, {}).map do |name, action|
          new(service:, name:, action:).build_method_signature
        end
      end
    end

    def initialize(service:, name:, action:)
      @service = service
      @name = name
      @action = action
      @batch_action_documentation = AwsSdkCodeGenerator::ResourceBatchActionDocumentation.new(
        var_name: nil,
        method_name:,
        action:,
        api: service.api,
      )
      @skip_params = @batch_action_documentation.send(:skip_params)
      @input_ref = @batch_action_documentation.send(:input_ref)
      @input_shape = AwsSdkCodeGenerator::Api.shape(@input_ref, service.api)
    end

    def build_method_signature
      MethodSignature.new(
        method_name:,
        arguments:,
        returns:,
      )
    end

    private

    def method_name
      AwsSdkCodeGenerator::ResourceBatchAction.send(:build_method_name, @name, @action)
    end

    def arguments
      if @input_shape
        @input_shape[:members].filter_map { |member_name, member_ref|
          next if @skip_params.include?(member_name)
          required = @input_shape.fetch(:required, []).include?(member_name)
          type = @service.shape_dictionary[member_ref.fetch(:shape)].find(&:input?).rbs_input_name
          "#{required ? "" : "?"}#{member_name.underscore}: Types::#{type}"
        }.join(", ")
      end
    end

    def returns
      "void"
    end
  end
end
