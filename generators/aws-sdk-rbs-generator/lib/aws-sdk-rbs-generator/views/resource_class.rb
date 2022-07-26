# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class ResourceClass < View
      attr_reader :service_name
      attr_reader :name
      attr_reader :initialize_arguments
      attr_reader :identifiers
      attr_reader :data_attributes
      attr_reader :shape
      attr_reader :exists_waiters
      attr_reader :waiters
      attr_reader :actions
      attr_reader :associations
      attr_reader :batch_actions

      def initialize(service:, shape_dictionary:, resource_name:, resource:)
        @service = service
        @shape_dictionary = shape_dictionary
        @name = resource_name
        @resource = resource
        @service_name = @service.name
        args = @resource.fetch(:identifiers, []).map { |i| "#{i[:name].underscore}: String" }
        args << "?client: Client, **untyped"
        @initialize_arguments = args.join(", ")
        @identifiers = @resource.fetch(:identifiers, []).map do |identifier|
          MethodSignature.new(
            method_name: identifier.fetch(:name).underscore,
            arguments: nil,
            returns: "String",
          )
        end
        @data_attributes = if @resource[:shape]
          data_attribute_names = AwsSdkCodeGenerator::ResourceAttribute.send(:data_attribute_names, @resource, @service.api)
          data_attribute_names.map do |member_name, member_ref|
            MethodSignature.new(
              method_name: member_name.underscore,
              arguments: nil,
              returns: "Types::#{@shape_dictionary[member_ref[:shape]].find(&:output?).rbs_output_name}"
            )
          end
        else
          []
        end
        @shape = @resource[:shape]
        @exists_waiters = @resource.fetch(:waiters, []).any? { |name, _| name == "Exists" }
        @waiters = @resource.fetch(:waiters, []).map do |waiter_name, waiter_body|
          MethodSignature.new(
            method_name: "wait_until_#{waiter_name.underscore}",
            arguments: "?Aws::Waiters::waiter_options",
            returns: "self",
          )
        end
        @actions = ResourceAction.build_method_signature_list(resource: @resource, service: @service)
        @associations = ResourceAssociation.build_method_signature_list(resource: @resource, service: @service)
        @batch_actions = ResourceBatchAction.build_method_signature_list(resource: @resource, service: @service)
      end

      def load?
        @resource[:load]
      end

      def load_or_shape?
        load? or !!shape
      end
    end
  end
end
