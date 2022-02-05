# frozen_string_literal: true

module AwsSdkRbsGenerator
  class View < Mustache
    TEMPLATE_DIR = File.expand_path('../../../templates', __FILE__)

    class << self
      def template_path
        TEMPLATE_DIR
      end

      def template_file
        parts = (name or raise).split('::')
        parts.shift # remove AwsSdkRbsGenerator
        parts.shift # remove Views
        path = parts.map(&:underscore).join('/')
        "#{TEMPLATE_DIR}/#{path}.mustache"
      end
    end

    def warning_comment
      AwsSdkRbsGenerator.warning_comment
    end

    # no need html escape
    def escape(value)
      value
    end
  end
end
