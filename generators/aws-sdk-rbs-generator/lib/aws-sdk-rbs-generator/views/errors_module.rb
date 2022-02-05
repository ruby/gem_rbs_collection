# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class ErrorsModule < View
      attr_reader :errors

      def initialize(shape_dictionary:)
        @shape_dictionary = shape_dictionary
        @errors = ErrorList.new(shape_dictionary:).to_a
      end

      def service_name
        @shape_dictionary.service_id
      end
    end
  end
end
