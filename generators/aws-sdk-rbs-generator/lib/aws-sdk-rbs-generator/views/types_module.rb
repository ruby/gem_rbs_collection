# frozen_string_literal: true

module AwsSdkRbsGenerator
  module Views
    class TypesModule < View
      attr_reader :shape_map

      def initialize(shape_dictionary:)
        @shape_dictionary = shape_dictionary
        @shape_map = shape_dictionary.filter_map { |name, shapes|
          unless shapes
            puts "  #{name}"
            next
          end
          # request structure used in operations keyword argument directly
          # next if shapes.first.request

          # exception should be in errors_module
          next if shapes.first.exception?

          # remove duplication
          shapes.group_by { |shape|
            shape.rbs_print_name
          }.map { |print_name, shapes| shapes.first }
        }.flatten
      end

      def service_name
        @shape_dictionary.service.name
      end
    end
  end
end
