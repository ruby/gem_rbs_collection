# frozen_string_literal: true

module AwsSdkRbsGenerator
  class ResourceAction
    class << self
      def build_method_signature_list(resource:, service:)
        (resource[:actions] || []).map do |action_name, action|
          new(action_name:, action:, service:).build_method_signature
        end
      end
    end

    def initialize(action_name:, action:, service:)
      request = action[:request]
      operation = service.api[:operations][request[:operation]]
      returns = if action[:resource]
        resource = action[:resource]
        AwsSdkCodeGenerator::Api.plural?(resource) ? "#{resource[:type]}::Collection" : resource[:type]
      elsif operation[:output]
        "Types::#{operation[:output][:shape]}"
      else
        "EmptyStructure"
      end

      @client_request = ResourceClientRequest.new(
        method_name: action_name.underscore,
        service:,
        request:,
        returns:,
      )
    end

    def build_method_signature
      @client_request.build_method_signature
    end
  end
end
