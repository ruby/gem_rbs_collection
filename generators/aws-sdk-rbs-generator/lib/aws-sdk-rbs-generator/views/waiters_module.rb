# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class WaitersModule < View
      attr_reader :waiters

      def initialize(shape_dictionary:, waiters:)
        @shape_dictionary = shape_dictionary
        @waiters = Waiter.build_list(waiters:, shape_dictionary:)
      end

      def service_name
        @shape_dictionary.service_id
      end
    end
  end
end
