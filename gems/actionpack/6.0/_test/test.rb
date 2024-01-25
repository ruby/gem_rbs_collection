class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action -> (controller) { self.controller_instance_method; controller.controller_instance_method }
  before_action :authenticate

  around_action -> (controller, block) { block.call; controller.controller_instance_method }

  module After
    def self.after(_) end
  end

  after_action After

  def controller_instance_method
  end

  def authenticate
    authenticate_or_request_with_http_token('realm') do |token, options|
      puts options[:nonce]
      ActiveSupport::SecurityUtils.secure_compare(token, 'secret')
    end
  end
end
