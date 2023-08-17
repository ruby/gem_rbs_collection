# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class ErrorsModule < View
      attr_reader :errors
      attr_reader :dynamic_error_list

      def initialize(shape_dictionary:)
        @shape_dictionary = shape_dictionary
        @errors = ErrorList.new(shape_dictionary:).to_a
        @dynamic_error_list = DynamicErrorList.new(service_name: shape_dictionary.service.name)
      end

      def service_name
        @shape_dictionary.service_id
      end

      def dynamic_errors?
        !@dynamic_error_list.empty?
      end

      def dynamic_errors
        @dynamic_error_list.to_a
      end

      def dynamic_errors_source
        @dynamic_error_list.source
      end
    end
  end
end
