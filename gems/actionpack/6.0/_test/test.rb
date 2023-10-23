class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action -> (controller) { self.controller_instance_method; controller.controller_instance_method }

  around_action -> (controller, block) { block.call; controller.controller_instance_method }

  module After
    def self.after(_) end
  end

  after_action After

  def controller_instance_method
  end
end
