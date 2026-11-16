require "omniauth"

class NoopApp
  def call(env)
    [200, { "content-type" => "text/plain" }, ["ok"]]
  end
end

class ExampleStrategy
  include OmniAuth::Strategy
  extend OmniAuth::Strategy::ClassMethods

  args [:client_id, :client_secret]
  option :name, "example"
  option :scope, "email"

  uid { request.params["id"] }

  info do
    { name: "Example User", email: request.params["email"] }
  end

  extra { { "raw" => request.params } }

  credentials { { "token" => session["token"] } }

  def request_phase
    return redirect("/login") unless on_request_path?

    redirect("#{full_host}#{script_name}#{callback_path}?next=#{query_string}")
  end

  def callback_phase
    return fail!(:invalid_credentials, StandardError.new("bad")) unless on_callback_path?

    # @type var hash: OmniAuth::AuthHash
    hash = auth_hash
    env["omniauth.auth"] = hash
    call_app!
  end
end

class ChildStrategy < ExampleStrategy
  option :name, "child"
  args :client_id

  uid { "child" }
end

strategy = ExampleStrategy.new(NoopApp.new, "id", "secret")
strategy_with_options = ExampleStrategy.new(NoopApp.new, { scope: "profile" }) { |options| options[:name] = "other" }

# @type var strategy_options: OmniAuth::Strategy::Options
strategy_options = strategy.options
strategy_options.name.to_s.upcase
strategy_options[:scope]
# @type var strategy_name: String | Symbol
strategy_name = strategy.name
# @type var arg_names: Array[Symbol]
arg_names = ExampleStrategy.args
# @type var default_options: OmniAuth::Strategy::Options
default_options = ExampleStrategy.default_options
ExampleStrategy.configure(scope: "email")
ExampleStrategy.configure { |options| options[:name] = "configured" }
# @type var uid_block: Proc?
uid_block = ExampleStrategy.uid

# Methods that need the Rack env of a request, which exists only while the app handles one.
def handle_request(strategy, env)
  # @type var response: OmniAuth::rack_response
  response = strategy.call(env)
  response = strategy.call!(env)
  response = strategy.request_phase
  response = strategy.callback_phase
  response = strategy.redirect("/login")
  response = strategy.fail!(:invalid_credentials)
  response = strategy.call_app!
  strategy.setup_phase
  strategy.log(:info, "message")
  strategy.env.keys
  strategy.session.keys
  strategy.request.params
  strategy.app&.call(env)

  # @type var auth_hash: OmniAuth::AuthHash
  auth_hash = strategy.auth_hash
  strategy.uid
  strategy.info.keys
  strategy.credentials.keys
  strategy.extra.keys
  strategy.skip_info?

  # @type var urls: Array[String]
  urls = [
    strategy.full_host, strategy.callback_url, strategy.callback_path, strategy.request_path,
    strategy.setup_path, strategy.current_path, strategy.query_string, strategy.script_name, strategy.path_prefix
  ]
  strategy.custom_path(:request_path)&.upcase
  strategy.on_auth_path?
  strategy.on_request_path?
  strategy.on_callback_path?
  strategy.on_path?("/auth/example")
  strategy.options_request?
  strategy.response
end

# AuthHash
auth = OmniAuth::AuthHash.new(
  provider: "example",
  uid: "1234",
  info: { name: "Example User", email: "user@example.com", nickname: "example" },
  credentials: { token: "token" },
  extra: { raw_info: { id: 1 } }
)
# @type var auth_valid: bool
auth_valid = auth.valid?
# @type var auth_provider: String?
auth_provider = auth.provider
# @type var auth_uid: String?
auth_uid = auth.uid
# @type var auth_info: OmniAuth::AuthHash::InfoHash?
auth_info = auth.info
# @type var auth_credentials: Hashie::Mash?
auth_credentials = auth.credentials
# @type var auth_extra: Hashie::Mash?
auth_extra = auth.extra
auth.provider?
auth.uid?
auth.info?
auth.info = { name: "Another" }
auth.credentials = { token: "other" }
auth.extra = { raw_info: { id: 1 } }

info_hash = OmniAuth::AuthHash::InfoHash.new(first_name: "Example", last_name: "User", email: "user@example.com", nickname: "example")
# @type var info_name: String?
info_name = info_hash.name
# @type var info_first_name: String?
info_first_name = info_hash.first_name
# @type var info_last_name: String?
info_last_name = info_hash.last_name
# @type var info_nickname: String?
info_nickname = info_hash.nickname
# @type var info_email: String?
info_email = info_hash.email
info_hash.name?
info_hash.email?
info_hash.valid?
# @type var info_plain: Hash[String, untyped]
info_plain = info_hash.to_hash

# Configuration
OmniAuth.config.full_host = "https://example.com"
OmniAuth.config.full_host = ->(env) { "http" == env["rack.url_scheme"] ? "http://localhost:3000" : "https://example.com" }
OmniAuth.config.full_host = proc { "https://example.com" }
OmniAuth.config.full_host = nil
OmniAuth.config.path_prefix = "/users/auth"
OmniAuth.config.allowed_request_methods = [:post]
OmniAuth.config.silence_get_warning = true
OmniAuth.config.test_mode = true
OmniAuth.config.logger = Logger.new($stdout)
OmniAuth.config.failure_raise_out_environments = ["development"]
OmniAuth.config.form_css = "body { color: black; }"
OmniAuth.config.camelizations = { "example" => "Example" }
OmniAuth.config.add_camelization("example", "ExampleAuth")
OmniAuth.config.mock_auth[:example] = OmniAuth::AuthHash.new(provider: "example", uid: "1")
OmniAuth.config.add_mock(:example, { uid: "2" })
OmniAuth.config.on_failure = OmniAuth::FailureEndpoint
OmniAuth.config.on_failure = proc { |env| OmniAuth::FailureEndpoint.call(env) }
OmniAuth.config.before_request_phase = proc { |env| env }
OmniAuth.config.after_request_phase = nil
OmniAuth.config.before_callback_phase = proc { |env| env }
OmniAuth.config.before_options_phase = nil
default_request_validation = OmniAuth.config.request_validation_phase
OmniAuth.config.request_validation_phase = proc do |env|
  default_request_validation&.call(env)
end
OmniAuth.config.on_failure { |env| OmniAuth::FailureEndpoint.call(env) }
OmniAuth.config.before_callback_phase { |env| env }
# @type var config_path_prefix: String
config_path_prefix = OmniAuth.config.path_prefix
# @type var request_methods: Array[Symbol]
request_methods = OmniAuth.config.allowed_request_methods
# @type var mock: OmniAuth::AuthHash | Symbol
mock = OmniAuth.mock_auth_for(:example)
OmniAuth.configure do |config|
  config.path_prefix = "/auth"
end
# @type var logger: Logger
logger = OmniAuth.logger
# @type var strategy_classes: Array[Class]
strategy_classes = OmniAuth.strategies

# Builder
builder = OmniAuth::Builder.new(NoopApp.new)
builder.provider :developer, fields: [:name, :email]
builder.provider ExampleStrategy, "id", "secret", scope: "email"
builder.on_failure { |env| OmniAuth::FailureEndpoint.call(env) }
builder.before_request_phase { |env| env }
builder.after_request_phase { |env| env }
builder.before_callback_phase { |env| env }
builder.before_options_phase { |env| env }
builder.options({ name: "custom" })
builder.configure { |config| config.path_prefix = "/auth" }

# Form
form = OmniAuth::Form.new(title: "Sign in", url: "/auth/callback", method: "post")
form.text_field("Name", "name").password_field("Password", "password")
form.fieldset("Details") { |inner| inner.input_field("hidden", "token") }
form.label_field("Email", "email").header("Title", "Info").footer
form.button("Sign in").upcase
form.html("<p>hello</p>").upcase
form.to_html.upcase
form.to_response
OmniAuth::Form.build(title: "Sign in") { |built| built.text_field("Name", "name") }
form.options[:title]
OmniAuth::Form::DEFAULT_CSS.upcase

# Utils
OmniAuth::Utils.camelize(:example_auth).upcase
OmniAuth::Utils.camelize("example", false).upcase
OmniAuth::Utils.deep_merge({ a: 1 }, { b: 2 })
OmniAuth::Utils.form_css.upcase

# Failure endpoint and errors
def handle_failure(env)
  endpoint = OmniAuth::FailureEndpoint.new(env)
  # @type var failure_response: OmniAuth::rack_response
  failure_response = endpoint.call
  failure_response = endpoint.redirect_to_failure
  failure_response = OmniAuth::FailureEndpoint.call(env)
  endpoint.raise_out!
  endpoint.env.keys
end

begin
  raise OmniAuth::NoSessionError, "no session"
rescue OmniAuth::NoSessionError, OmniAuth::AuthenticityError => e
  e.message.upcase
rescue OmniAuth::Error => e
  e.message.upcase
end

OmniAuth::Strategies::Developer.new(NoopApp.new)
