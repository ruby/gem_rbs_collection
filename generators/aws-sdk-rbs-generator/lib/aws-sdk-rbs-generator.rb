# frozen_string_literal: true

require 'json'
require 'rbs'
require 'fileutils'

require 'aws-sdk-code-generator'
require 'active_support/all'
require 'mustache'

require_relative "aws-sdk-rbs-generator/patch"
require_relative "aws-sdk-rbs-generator/view"
require_relative "aws-sdk-rbs-generator/views/client_class"
require_relative "aws-sdk-rbs-generator/views/errors_module"
require_relative "aws-sdk-rbs-generator/views/resource_class"
require_relative "aws-sdk-rbs-generator/views/root_resource_class"
require_relative "aws-sdk-rbs-generator/views/types_module"
require_relative "aws-sdk-rbs-generator/views/waiters_module"
require_relative "aws-sdk-rbs-generator/shape_dictionary"
require_relative "aws-sdk-rbs-generator/shape_dictionary/shape"
require_relative "aws-sdk-rbs-generator/error_list"
require_relative "aws-sdk-rbs-generator/method_signature"
require_relative "aws-sdk-rbs-generator/resource_action"
require_relative "aws-sdk-rbs-generator/resource_association"
require_relative "aws-sdk-rbs-generator/resource_batch_action"
require_relative "aws-sdk-rbs-generator/resource_client_request"
require_relative "aws-sdk-rbs-generator/service"
require_relative "aws-sdk-rbs-generator/services"
require_relative "aws-sdk-rbs-generator/version"
require_relative "aws-sdk-rbs-generator/waiter"

module AwsSdkRbsGenerator
  class << self
    def warning_comment
      <<~WARNING_COMMENT
      # WARNING ABOUT GENERATED CODE
      #
      # This file is generated. See the generator README.md for more information:
      # https://github.com/ruby/gem_rbs_collection/blob/main/generators/aws-sdk-rbs-generator/README.md
      #
      # WARNING ABOUT GENERATED CODE
      WARNING_COMMENT
    end
  end
end
