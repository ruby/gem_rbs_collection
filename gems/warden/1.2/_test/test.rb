require "warden"
require "rack"

# Hooks (README: Warden::Manager callbacks)
Warden::Manager.after_set_user except: :fetch do |user, auth, opts|
  auth.session["last_seen_at"] = Time.now.to_i
  # @type var account: Account
  account = user
  account.id
  # @type var scope: Symbol
  scope = opts[:scope]
  auth.logout(scope) if scope == :banned
end

Warden::Manager.after_authentication do |user, auth, opts|
  # @type var proxy: Warden::Proxy
  proxy = auth
  proxy.set_user(user, scope: :audit, store: false)
end

Warden::Manager.after_set_user({ only: [:set_user, :authentication] }, :unshift) do |_user, auth, _opts|
  auth.errors.clear!
end

Warden::Manager.after_fetch do |user, auth, _opts|
  auth.logout unless auth.authenticated?(:user)
end

Warden::Manager.after_failed_fetch do |_user, auth, opts|
  # @type var scope: Symbol
  scope = opts[:scope]
  auth.lock! if scope == :user
end

Warden::Manager.before_failure do |env, opts|
  # @type var path: String
  path = env["PATH_INFO"]
  env["warden.attempted"] = path if opts[:action]
end

Warden::Manager.before_logout do |user, auth, opts|
  auth.session(opts[:scope])["logged_out"] = true if user
end

Warden::Manager.on_request do |proxy|
  proxy.env["warden.seen"] = proxy.authenticated?
end

# Session serialization
Warden::Manager.serialize_into_session do |user|
  # @type var account: Account
  account = user
  account.id
end

Warden::Manager.serialize_from_session do |key|
  # @type var id: Integer
  id = key
  id
end

Warden::Manager.serialize_into_session(:admin) { |admin| admin }
Warden::Manager.serialize_from_session(:admin) { |key| key }

# Strategies
class PasswordStrategy < Warden::Strategies::Base
  def valid?
    params["login"] && params["password"] ? true : false
  end

  def store?
    false
  end

  def authenticate!
    # @type var login: String?
    login = params["login"]
    if login == "admin"
      success!({ "login" => login }, "Signed in")
    elsif login == "redirect"
      location = redirect!("/sign_in", { "from" => "strategy" }, { permanent: true })
      location.upcase
    elsif login == "custom"
      custom!([401, { "Content-Type" => "text/plain" }, ["Unauthorized"]])
    elsif login.nil?
      fail("Missing login")
    else
      errors.add(:login, "is invalid")
      fail!(:invalid)
    end
  end
end

Warden::Strategies.add(:password, PasswordStrategy)

Warden::Strategies.add(:shared_password, PasswordStrategy) do
  attr_reader :shared_hint
end

Warden::Strategies.update(:shared_password) do
  attr_reader :shared_hint_again
end

# @type var strategy_class: singleton(Warden::Strategies::Base)?
strategy_class = Warden::Strategies[:password]
strategy_class.nil?
Warden::Strategies.clear!

class InspectingStrategy < Warden::Strategies::Base
  def authenticate!
    # @type var user: untyped
    user = self.user
    # @type var message: String | Symbol | nil
    message = self.message
    # @type var result: Symbol?
    result = self.result
    self.user = user
    self.message = message
    self.result = result
    self.custom_response = custom_response

    # @type var rack_env: Hash[String, untyped]
    rack_env = env
    # @type var scope_name: Symbol?
    scope_name = scope
    # @type var status_code: Integer?
    status_code = status
    rack_env["warden.scope"] = scope_name
    rack_env["warden.status"] = status_code

    # @type var req: Rack::Request
    req = request
    req.path_info.upcase
    # @type var rack_session: Hash[String, untyped]
    rack_session = session
    rack_session["seen"] = true
    # @type var raw: Hash[String, untyped]
    raw = raw_session
    raw.clear
    reset_session! if halted?

    # @type var response_headers: Hash[String, String]
    response_headers = headers({ "X-Strategy" => "inspecting" })
    response_headers.keys
    clear!
    halt!
    pass
    successful? && store? && performed_check
  end

  private

  def performed_check
    valid?
  end
end

# Middleware (README: Rack setup)
class HelloApp
  def call(_env)
    [200, { "content-type" => "text/plain" }, ["Hello"]]
  end
end

app = HelloApp.new

manager = Warden::Manager.new(app, default_strategies: [:password]) do |config|
  config.default_strategies :password, :shared_password
  config.default_strategies :password, scope: :admin
  config.failure_app = ->(env) { [401, { "Content-Type" => "text/plain" }, ["Unauthorized"]] }
  config.default_scope = :user
  config.intercept_401 = false
  config.silence_missing_strategies!
  config.scope_defaults :admin, store: false, action: "admin/unauthenticated"
  config.scope_defaults(:admin).fetch(:store)

  # @type var names: Array[Symbol]
  names = config.default_strategies(scope: :user)
  names.unshift :password

  config.serialize_into_session { |user| user }
  config.serialize_from_session(:admin) { |key| key }
  config.strategies.clear!

  config.default_scope.to_s
  config.intercept_401 ? 1 : 2
end

manager.config.default_scope
manager.config = Warden::Config.new({ default_scope: :user })
manager.call({ "PATH_INFO" => "/" })

# Warden::Proxy (request.env["warden"])
# @type var env: Hash[String, untyped]
env = { "rack.session" => {} }
manager.call(env)

# @type var proxy: Warden::Proxy
proxy = env["warden"]

proxy.authenticate(:password)
proxy.authenticate(:password, scope: :admin)
catch(:warden) { proxy.authenticate!(:password, :shared_password, scope: :admin) }
proxy.authenticate?(:password)
proxy.authenticate?(scope: :user) { puts "signed in" }

proxy.authenticated?
proxy.authenticated?(:admin) { puts "admin" }
proxy.unauthenticated?
proxy.unauthenticated?(:admin) { puts "guest" }

proxy.user
proxy.user(:admin)
proxy.user(scope: :admin, run_callbacks: false)
proxy.set_user({ "id" => 1 }, scope: :user, store: false, event: :authentication)
proxy.set_user({ "id" => 1 })

begin
  # @type var session_data: Hash[String, untyped]
  session_data = proxy.session(:user)
  session_data["need_two_step_verification"] = false
  proxy.session["flag"] = 1
rescue Warden::NotAuthenticated => e
  e.message
end

proxy.logout
proxy.logout(:user, :admin)

proxy.clear_strategies_cache!
proxy.clear_strategies_cache!(:password, scope: :admin)
proxy.lock!
proxy.custom_failure!
proxy.custom_failure? ? 1 : 2

# @type var proxy_env: Hash[String, untyped]
proxy_env = proxy.env
proxy_env.keys
proxy.manager.config.default_scope
proxy.config.default_scope
proxy.default_strategies(scope: :admin).first
proxy.message&.to_s
proxy.params.keys
proxy.request.path_info
proxy.reset_session!
# @type var raw_session: Hash[String, untyped]
raw_session = proxy.raw_session
raw_session.keys

# @type var errors: Warden::Proxy::Errors
errors = proxy.errors
errors.add(:login, "is invalid")
errors.add("base", "failed")
errors.on(:login)&.first&.upcase
errors.full_messages.first.upcase
errors.each { |messages| messages.first.upcase }
errors.map { |messages| messages.size }.sum
errors.empty? ? 1 : 2
errors.clear!

Warden::UserNotSet.new.message
Warden::VERSION.upcase
