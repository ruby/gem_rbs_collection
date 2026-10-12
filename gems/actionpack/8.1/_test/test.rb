class FooController < ActionController::Base
  allow_browser versions: :modern
end

class BarController < ActionController::Base
  allow_browser versions: { safari: 17.5, chrome: 127, ie: false }, block: -> { head :not_acceptable }
end

ActionController::Base.new.render_to_string(template: 'foo', locals: { bar: 'baz' })

class FooService
  include ActionDispatch::Routing::RouteSet.new.url_helpers
end

# Methods that only forward the block can be called without one
ActionDispatch::Routing::RouteSet.new.draw do
  match "/hello", to: "hello#index", via: :get
  mount Rack::Head, at: "/rack"
  options "/hello", to: "hello#options"
  concern :commentable, ->(_mapper, _options) { nil }
end

stack = ActionDispatch::MiddlewareStack.new
stack.use Rack::Head
stack.insert_after Rack::Head, Rack::ETag
stack.swap Rack::ETag, Rack::ConditionalGet
stack.unshift Rack::Lock

params = ActionController::Parameters.new(name: "foo").permit!
params.to_h
params.merge!(age: 1)

Mime.fetch(:html)
ActionDispatch::Callbacks.before(:prepare)
