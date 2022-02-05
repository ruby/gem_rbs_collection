# frozen_string_literal: true

module AwsSdkRbsGenerator
  class MethodSignature
    attr_reader :method_name
    attr_reader :arguments
    attr_reader :returns

    def initialize(method_name:, arguments:, returns:)
      @method_name = method_name
      @arguments = arguments
      @returns = returns
    end
  end
end
