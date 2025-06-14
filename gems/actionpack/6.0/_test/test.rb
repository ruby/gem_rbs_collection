class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action -> (controller) { self.controller_instance_method; controller.controller_instance_method }
  before_action :authenticate

  around_action -> (controller, block) { block.call; controller.controller_instance_method }

  helper :login
  # FIXME
  # helper { def hello() "Hello, world!" end }

  fragment_cache_key "v1"
  fragment_cache_key do
    Time.current.year > 2023 ? "v1" : "v2"
  end

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

  def fetch
    params = ActionController::Parameters.new(person: { name: 'Francesco' })
    # fetch with block
    params.fetch(:person) { { name: 'Default Name' } }
    # fetch without block
    params.fetch(:person)
  end
end

rs = ActionDispatch::Routing::RouteSet.new
rs.draw do
  resource :foo
  resources :bar, only: %i[index]
  namespace :baz do
    get :qux
    post :quux
  end
end

ActionController::Base.new.render_to_string(template: 'sample', locals: { foo: 'bar' })
