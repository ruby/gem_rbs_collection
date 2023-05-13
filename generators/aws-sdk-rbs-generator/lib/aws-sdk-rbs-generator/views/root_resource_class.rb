# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class RootResourceClass < View
      attr_reader :actions
      attr_reader :associations

      def initialize(service:)
        @service = service
        resource = @service.resources.fetch(:service, {})
        @actions = ResourceAction.build_method_signature_list(resource:, service:)
        @associations = ResourceAssociation.build_method_signature_list(resource:, service:)
      end

      def service_name
        @service.name
      end

      def client_option
        @service.client_class.client_option
      end
    end
  end
end
