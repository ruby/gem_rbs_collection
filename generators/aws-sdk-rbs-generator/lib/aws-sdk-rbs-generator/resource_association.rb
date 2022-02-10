# frozen_string_literal: true

module AwsSdkRbsGenerator
  class ResourceAssociation
    class << self
      def build_method_signature_list(resource:, service:)
        associations = []
        associations += has_associations(resource:)
        associations += has_many_associations(resource:, service:)
        associations.sort_by(&:method_name)
      end

      private

      def has_associations(resource:)
        resource.fetch(:has, {}).map do |name, assoc|
          method_name = name.underscore
          arguments = AwsSdkCodeGenerator::ResourceHasAssociation.send(:compute_params, assoc).map { |param|
            "#{param[:type]} #{param[:name].underscore}"
          }.join(', ')
          returns = AwsSdkCodeGenerator::ResourceHasAssociation.send(:return_type, assoc).sub(/, nil$/, "?")
          MethodSignature.new(
            method_name:,
            arguments:,
            returns:,
          )
        end
      end

      def has_many_associations(resource:, service:)
        resource.fetch(:hasMany, {}).map do |name, assoc|
          ResourceClientRequest.new(
            method_name: name.underscore,
            service:,
            request: assoc[:request],
            returns: "#{assoc[:resource][:type]}::Collection",
            skip: AwsSdkCodeGenerator::ResourceHasManyAssociation.send(:paging_options, { assoc:, paginators: service.paginators }),
          ).build_method_signature
        end
      end
    end
  end
end
