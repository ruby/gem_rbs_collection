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

# Controller accessors, and the ClassMethods of the concerns Base includes
class AccessorsController < ActionController::Base
  permissions_policy(only: :index) { |policy| policy }
  log_at :debug, if: -> { true }
  set_callback(:process_action, :before, :show)
  cache_store

  def self.method_added(name)
    super
    name.to_proc
  end

  def show
    params.permit(:name)
    self.params = { name: "foo" }
    cookies.signed
    flash.now[:notice] = "Saved"
    flash.keep
    request.path_parameters
    response.status
  end

  def show_detailed_exceptions?
    request.local?
  end
end
