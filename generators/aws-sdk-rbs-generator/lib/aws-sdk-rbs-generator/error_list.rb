# frozen_string_literal: true

module AwsSdkRbsGenerator
  class ErrorList
    def initialize(shape_dictionary:)
      @list = []
      shape_dictionary.each do |_name, shapes|
        shape = shapes.find(&:exception?)
        if shape
          body = shape.fetch_body
          members = body[:members].map do |member_name, member_body|
            member_shape = shape_dictionary[member_body.fetch(:shape)].first or raise
            MethodSignature.new(
              method_name: member_name.underscore,
              arguments: nil,
              returns: "Types::#{member_shape.rbs_name}",
            )
          end
          @list << {
            name: shape.name,
            members:,
          }
        end
      end
    end

    def to_a
      @list
    end
  end
end
