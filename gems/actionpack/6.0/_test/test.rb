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
  options("carrots", to: "food#carrots").has_named_route?(:carrots)
  post "uploads",controller: :uploads, action: :create, defaults: { format: "json" }, format: false
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
