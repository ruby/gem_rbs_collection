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

# Attributes defined with attr_internal
class BazController < ActionController::Base
  def show
    request.path
    response.successful?
    action_name.to_sym
  end
end

# Return values of common controller APIs
class QuxController < ActionController::Base
  def show
    permitted = params.permit(:name, :age)
    permitted.to_h.symbolize_keys
    permitted.slice(:name).merge(age: 1).permitted?
    params.except(:token).to_unsafe_h.keys
    params.transform_values(&:to_s).to_query

    request.url.start_with?("https")
    request.host.length
    request.port.succ
    request.remote_ip.split(".")
    request.headers["User-Agent"]
    request.parameters.fetch(:id, nil)
    request.xhr? && request.local?
    request.request_id&.length
    request.subdomains.first

    cookies[:theme]&.upcase
    cookies.signed[:user_id]
    flash.now[:notice] = "Saved"
    flash.keep.discard(:alert)

    self.status = :created
    self.content_type = :json
    self.content_type = Mime[:html]
    self.content_type = "text/plain"
    self.content_type = nil
    response.status.to_s
    response.body.bytesize
    controller_name.camelize
  end
end

# ClassMethods of the concerns Base and API include
ActionController::Base.use_renderers(:json)
ActionController::API.use_renderers(:json)
ActionController::Base.allowed_redirect_hosts = ["example.com"]
ActionController::API.allowed_redirect_hosts = ["example.com"]
ActionController::Base.define_callbacks(:notify)
ActionController::API.prepend_view_path("app/views")

# ClassMethods of the concerns the generated classes include
class FooControllerTest < ActionController::TestCase
  tests FooController
end

class FooIntegrationTest < ActionDispatch::IntegrationTest
  register_encoder :xml
  with_routing { |routes| routes }
end

ActionDispatch::Request.parameter_parsers = {}
ActionDispatch::Callbacks.define_callbacks(:notify)

# HTTP authentication returns the block value, or the rendered body when it requests credentials
class AuthController < ActionController::Base
  http_basic_authenticate_with name: "dhh", password: "secret", except: :index

  def show
    authenticate_with_http_token { |token, options| token.length + options.size }&.succ
    authenticate_or_request_with_http_token("Admin") { |token, _options| token.upcase }.downcase
    request_http_token_authentication("Admin", "Denied").length

    authenticate_with_http_basic { |name, password| "#{name}:#{password}" }&.length
    authenticate_or_request_with_http_basic("Admin") { |name, _password| name.to_s }.length
    request_http_basic_authentication.length
    http_basic_authenticate_or_request_with(name: "dhh", password: "secret", realm: "Admin")

    authenticate_with_http_digest("Admin") { |username| username == "dhh" ? "secret" : nil }
    authenticate_or_request_with_http_digest { |username| username ? "secret" : nil }
    request_http_digest_authentication("Admin", "Denied").length
  end
end

# Caching config methods, and overrides of method_added and show_detailed_exceptions?
class OverridesController < ActionController::Base
  cache_store

  def self.method_added(name)
    super
    name.to_proc
  end

  def show_detailed_exceptions?
    request.local?
  end
end
ActionController::API.cache_store
