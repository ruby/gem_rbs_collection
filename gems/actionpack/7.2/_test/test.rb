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

# render_to_body returns what the including class renders, so it can be truthy
class BodyRenderer
  include AbstractController::Rendering

  def show
    render_to_body(template: "show") ? "rendered" : "empty"
  end
end

# Routing DSL forms from the Rails routing guide
class AdminConstraint
  def matches?(request)
    request.path.start_with?("/admin")
  end
end

ActionDispatch::Routing::RouteSet.new.draw do
  root "pages#home"
  root(to: "pages#home", as: :home).has_named_route?(:home)

  get "profile", to: "users#show", as: :profile
  get "photos/search" => "photos#search"
  get "health", to: ->(_env) { [200, { "content-type" => "text/plain" }, ["OK"]] }
  get "old", to: redirect("/new")
  post "uploads", controller: :uploads, action: :create, defaults: { format: "json" }, format: false
  match("photos", "pictures", to: "photos#show", via: [:get, :post]).has_named_route?(:photos)
  match "exports/:id", to: "exports#show", via: :all, constraints: { id: /\d+/ }, anchor: true

  resources :photos, only: [:index, :show], param: :slug, path: "pictures", as: :images do
    member { get :preview }.has_named_route?(:preview_image)
    collection { get :search }.has_named_route?(:search_images)
    new { get :draft }.has_named_route?(:draft_new_image)
    get :recent, on: :collection
    nested { resources :comments, except: :destroy }.has_named_route?(:image_comments)
  end.has_named_route?(:images)
  resource :geocoder, controller: "geocoders", module: "maps"
  resources :articles, concerns: [:commentable], path_names: { new: "make" }, shallow: true
  shallow { resources(:posts) { resources :drafts } }.has_named_route?(:posts)

  namespace(:admin, path: "control", as: :ctl) { resources :articles }.has_named_route?(:ctl_articles)
  scope(module: "admin", path: "manage", as: :manage) { resources :users }.has_named_route?(:manage_users)
  scope("(:locale)", locale: /en|nl/) { resources :books }
  scope(only: :index) { resources :tags }

  controller(:pages) { get "about", action: :about }.has_named_route?(:about)
  defaults(format: :json) { get "status", to: "status#show" }.has_named_route?(:status)

  constraints(subdomain: "api") { resources :keys }
  constraints(id: /\d+/) { get "items/:id", to: "items#show" }
  constraints(->(request) { request.xhr? }) { get "async", to: "async#show" }
  constraints(AdminConstraint.new) { get "admin", to: "admin#index" }
  get "secure", to: "secure#show", constraints: ->(request) { request.ssl? }

  concern(:commentable) { |options| resources :comments, **options }
  concerns(:commentable, only: :index).first&.to_proc

  mount Rack::Head.new(->(_env) { [200, { "content-type" => "text/plain" }, ["OK"]] }), at: "/head", as: :head
  with_default_scope(module: "v1") { get "ping", to: "ping#show" }.has_named_route?(:ping)
end
