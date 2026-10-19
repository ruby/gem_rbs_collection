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

# Routing DSL methods return the mapper or their block value
ActionDispatch::Routing::RouteSet.new.draw do
  resources(:photos) do
    collection { get :search }.has_named_route?(:search_photos)
    member { "preview" }.upcase
    new { 1 }.succ
    shallow { [1] }.first
    nested { resources :comments }.has_named_route?(:photo_comments)
    namespace(:admin) { resource :stats }.has_named_route?(:admin_stats)
  end.has_named_route?(:photos)

  scope(module: "admin") { get "dashboard", to: "dashboard#show" }.has_named_route?(:dashboard)
  namespace(:api) { resources :posts }.has_named_route?(:api_posts)
  constraints(subdomain: "api") { put "sync", to: "sync#update" }.has_named_route?(:sync)
  controller(:pages) { 1 }.succ
  defaults(format: :json) { "json" }.upcase
  with_default_scope(module: "v1") { get "ping", to: "ping#show" }.has_named_route?(:ping)

  concern(:taggable) { |options| options.size }
  concerns(:taggable).size

  get("status", to: "status#show").post("status", to: "status#create").has_named_route?(:status)
  options("status", to: "status#options").has_named_route?(:status)
  match("/hello", to: "hello#index", via: :get).has_named_route?(:hello)
  root("home#index").has_named_route?(:root)
end
