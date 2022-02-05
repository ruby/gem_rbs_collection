# frozen_string_literal: true

module AwsSdkRbsGenerator
  class Waiter < Struct.new(:name, :class_name, :params, :returns)
    class << self
      def build_list(waiters:, shape_dictionary:)
        operations = shape_dictionary.service.api.fetch(:operations)
        waiters = waiters.empty? ? {} : waiters[:waiters]
        waiters.map do |waiter_name, waiter|
          operation = waiter.fetch(:operation)
          operation_ref = operations[operation]
          input_shape = operation_ref.dig(:input, :shape)
          output_shape = operation_ref.dig(:output, :shape)&.then { "Types::#{_1}" } || "Aws::EmptyStructure"
          new.tap do |w|
            w.name = ":#{waiter_name.underscore}"
            w.class_name = waiter_name
            w.params = "Types::#{input_shape.underscore}"
            w.returns = output_shape
          end
        end.sort_by(&:name)
      end
    end
  end
end
