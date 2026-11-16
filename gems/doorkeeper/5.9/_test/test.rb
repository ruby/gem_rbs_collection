require "doorkeeper"
require "active_record"
require "action_controller"

class User < ActiveRecord::Base
  # @dynamic authenticate
  has_secure_password

  def admin?
    false
  end
end

Doorkeeper.configure do
  orm :active_record
  base_controller "ApplicationController"
  application_class "Doorkeeper::Application"
  access_token_class "Doorkeeper::AccessToken"
  access_grant_class "Doorkeeper::AccessGrant"

  resource_owner_authenticator do |_controller|
    # @type var user: User?
    user = User.find_by(id: cookies.encrypted[:user_id])
    unless user
      cookies[:return_to] = request.fullpath
      redirect_to("/login")
    end
    user
  end
  admin_authenticator do
    # @type var admin: User?
    admin = User.find_by(id: cookies.encrypted[:user_id])
    head(:forbidden) unless admin&.admin?
  end
  resource_owner_from_credentials do |_controller|
    # @type var user: User?
    user = User.find_by(email: params[:username])
    user.authenticate(params[:password]) || nil if user
  end

  access_token_expires_in 2.hours
  authorization_code_expires_in 10.minutes
  custom_access_token_expires_in do |context|
    context ? 3600 : nil
  end
  use_refresh_token
  use_refresh_token { |_context| true }
  reuse_access_token
  token_reuse_limit 90
  force_pkce
  pkce_code_challenge_methods %w[S256]
  grant_flows %w[authorization_code client_credentials]
  access_token_methods :from_bearer_authorization, :from_access_token_param
  client_credentials :from_basic, :from_params

  enable_application_owner confirmation: true
  default_scopes :public
  optional_scopes :read, "write"
  scopes_by_grant_type client_credentials: [:read]
  enforce_configured_scopes

  api_only
  enforce_content_type
  handle_auth_errors :raise
  realm "Example"
  hash_token_secrets
  hash_token_secrets fallback: :plain
  hash_application_secrets using: "::Doorkeeper::SecretStoring::Sha256Hash"

  force_ssl_in_redirect_uri false
  force_ssl_in_redirect_uri do |uri|
    uri.host != "localhost"
  end
  forbid_redirect_uri do |uri|
    uri.scheme == "javascript"
  end
  custom_access_token_attributes [:resource]

  skip_authorization do |resource_owner, client|
    cookies[:skip] = request.remote_ip
    resource_owner ? false : client.application.confidential
  end
  allow_grant_flow_for_client do |grant_flow, client|
    grant_flow == "authorization_code" || client ? true : false
  end
  authorize_resource_owner_for_client do |client, resource_owner|
    client && resource_owner
  end
  before_successful_authorization do |controller|
    controller.response_body
  end
  after_successful_authorization do |controller, context|
    controller.status
    context&.issued_token&.token
  end
  before_successful_strategy_response do |request|
    request ? 1 : 2
  end
  after_successful_strategy_response do |request, response|
    request && response ? 1 : 2
  end
  custom_introspection_response do |token, context|
    token.revoked? ? nil : { active: true, scope: token.scopes.to_s, status: context.status }
  end
  base_controller { "ApplicationController" }
end

Doorkeeper.configure { orm :active_record }

# @type var config: Doorkeeper::Config
config = Doorkeeper.configuration
config = Doorkeeper.config
Doorkeeper.configured?

config.access_token_expires_in
config.authorization_code_expires_in
config.orm.to_s
config.default_scopes.all.first
config.optional_scopes.exists?(:read)
config.scopes.to_s.upcase
config.grant_flows.first
config.pkce_code_challenge_methods.first
config.access_token_methods.first
config.custom_access_token_attributes.first
config.native_redirect_uri.upcase
config.refresh_token_enabled?
config.enable_application_owner?
config.enforce_configured_scopes?
config.force_pkce?
config.api_only
config.enforce_content_type

# @type var token_model: singleton(Doorkeeper::AccessToken)
token_model = config.access_token_model
# @type var grant_model: singleton(Doorkeeper::AccessGrant)
grant_model = config.access_grant_model
# @type var application_model: singleton(Doorkeeper::Application)
application_model = config.application_model
application_model.find_by(uid: "abc")
token_model.by_token("abc")
grant_model.by_token("abc")

# @type var application: Doorkeeper::Application
application = Doorkeeper::Application.new
application.name = "Example"
application.uid = "uid"
application.secret = "secret"
application.redirect_uri = ["https://example.com/callback"]
application.redirect_uri = "https://example.com/callback"
application.confidential = true
application.owner = User.new
application.owner_id = 1
application.owner_type = "User"
application.scopes = "public read"
application.scopes = [:public, "read"]
application.scopes = Doorkeeper::OAuth::Scopes.from_string("public")
application.save!
application.id.succ
application.name.upcase
application.uid.upcase
application.secret&.upcase
application.redirect_uri.upcase
application.confidential.itself
application.confidential?
application.owner
application.owner_id&.succ
application.owner_type&.upcase
application.created_at.year
application.updated_at.year
application.scopes.exists?("read")
application.scopes_string&.upcase
application.includes_scope?(:read, "write")
application.renew_secret
application.plaintext_secret&.upcase
application.secret_matches?("secret")
application.authorized_for_resource_owner?(User.new)
application.access_tokens.where(revoked_at: nil).count.succ
application.access_grants.count.succ
application.authorized_tokens.count.succ

Doorkeeper::Application.by_uid("uid")&.name
Doorkeeper::Application.by_uid_and_secret("uid", "secret")&.name
Doorkeeper::Application.authorized_for(User.new).first&.name
Doorkeeper::Application.revoke_tokens_and_grants_for(application.id, User.new)
Doorkeeper::Application.ordered_by(:created_at, :desc).first&.name
Doorkeeper::Application.where(owner_id: 1).ordered_by(:name).first&.name
# @type var created_application: Doorkeeper::Application
created_application = Doorkeeper::Application.create!(name: "App", redirect_uri: "https://example.com")
created_application.name
Doorkeeper::Application.order(:created_at, :id).find_or_create_by!(name: "App").name

# @type var token: Doorkeeper::AccessToken
token = Doorkeeper::AccessToken.create_for(application: application, resource_owner: User.new, scopes: "read", expires_in: 3600)
token = Doorkeeper::AccessToken.find_or_create_for(application: application, resource_owner: 1, scopes: Doorkeeper::OAuth::Scopes.from_array([:read]), use_refresh_token: true)
token = Doorkeeper::AccessToken.create!(application_id: application.id, resource_owner_id: 1)
token.token = "abc"
token.refresh_token = "def"
token.application_id = application.id
token.application = application
token.resource_owner_id = 1
token.expires_in = 3600
token.revoked_at = Time.now
token.scopes = "read write"
token.scopes = [:read]
token.use_refresh_token = true
token.save!
token.id.succ
token.token.upcase
token.refresh_token&.upcase
token.previous_refresh_token&.upcase
token.resource_owner_id&.succ
token.application_id&.succ
token.application&.name
token.expires_in&.succ
token.revoked_at&.year
token.created_at.year
token.scopes.exists?("read")
token.scopes_string&.upcase
token.includes_scope?(:read)
token.accessible?
token.acceptable?([:read, "write"])
token.acceptable?(config.default_scopes)
token.expired?
token.revoked?
token.revoke
token.revoke(Time)
token.expires_at&.year
token.expires_in_seconds&.succ
token.token_type.upcase
token.plaintext_token&.upcase
token.plaintext_refresh_token&.upcase

Doorkeeper::AccessToken.by_token("abc")&.token
Doorkeeper::AccessToken.by_refresh_token("def")&.refresh_token
Doorkeeper::AccessToken.by_previous_refresh_token("old")&.token
Doorkeeper::AccessToken.by_resource_owner(User.new).where(revoked_at: nil).count.succ
Doorkeeper::AccessToken.active_for(User.new).where(application_id: 1).any?
Doorkeeper::AccessToken.active_for(User.new).by_resource_owner(1).not_expired.ordered_by(:created_at).first&.token
Doorkeeper::AccessToken.not_expired.count.succ
Doorkeeper::AccessToken.ordered_by(:created_at, :desc).first&.token
Doorkeeper::AccessToken.revoke_all_for(application.id, User.new)
Doorkeeper::AccessToken.revoke_all_for(application.id, 1, Time)
Doorkeeper::AccessToken.authorized_tokens_for(application.id, User.new).count.succ
Doorkeeper::AccessToken.last_authorized_token_for(application.id, User.new)&.token
Doorkeeper::AccessToken.refresh_token_revoked_on_use?
Doorkeeper::AccessToken.where(resource_owner_id: 1, revoked_at: nil).update_all(revoked_at: Time.current)
application.access_tokens.active_for(User.new).by_resource_owner(1).not_expired.ordered_by(:created_at).first&.token

# @type var grant: Doorkeeper::AccessGrant
grant = Doorkeeper::AccessGrant.create!(application_id: application.id, resource_owner_id: 1, expires_in: 600, redirect_uri: "https://example.com")
grant.id.succ
grant.token.upcase
grant.resource_owner_id&.succ
grant.application_id&.succ
grant.application&.name
grant.expires_in.succ
grant.redirect_uri.upcase
grant.revoked_at&.year
grant.created_at.year
grant.code_challenge&.upcase
grant.code_challenge_method&.upcase
grant.scopes.exists?("read")
grant.scopes = "read"
grant.scopes = [:read]
grant.scopes_string&.upcase
grant.includes_scope?(:read)
grant.uses_pkce?
grant.accessible?
grant.expired?
grant.revoked?
grant.revoke
grant.revoke(Time)
grant.expires_at&.year
grant.plaintext_token&.upcase

Doorkeeper::AccessGrant.by_token("abc")&.token
Doorkeeper::AccessGrant.by_resource_owner(User.new).where(revoked_at: nil).count.succ
Doorkeeper::AccessGrant.ordered_by(:created_at).first&.token
Doorkeeper::AccessGrant.revoke_all_for(application.id, User.new)
Doorkeeper::AccessGrant.revoke_all_for(application.id, 1, Time)
application.access_grants.by_resource_owner(User.new).ordered_by(:created_at).first&.token

# @type var scopes: Doorkeeper::OAuth::Scopes
scopes = Doorkeeper::OAuth::Scopes.from_string("read write")
scopes = Doorkeeper::OAuth::Scopes.from_string(nil)
scopes = Doorkeeper::OAuth::Scopes.from_array([:read, "write"])
scopes.add(:profile, "email")
scopes.each { |scope| scope.upcase }
scopes.map { |scope| scope.upcase }
scopes.empty?
scopes.exists?(:read)
scopes.all.first&.upcase
scopes.scopes?([:read, "write"])
scopes.to_s.upcase
scopes = scopes + [:read]
scopes = scopes + scopes
scopes = scopes & scopes
scopes = scopes & ["read"]
scopes = scopes.allowed(scopes)
scopes = scopes.allowed([:read])

Doorkeeper::OAuth::AUTHORIZATION_CODE.upcase
Doorkeeper::OAuth::IMPLICIT.upcase
Doorkeeper::OAuth::PASSWORD.upcase
Doorkeeper::OAuth::CLIENT_CREDENTIALS.upcase
Doorkeeper::OAuth::REFRESH_TOKEN.upcase

# @type var client: Doorkeeper::OAuth::Client
client = Doorkeeper::OAuth::Client.new(application)
client = Doorkeeper::OAuth::Client.find("uid") || client
client.application.name
client.id.succ
client.name.upcase
client.uid.upcase
client.redirect_uri.upcase
client.scopes.to_s
client.confidential

Doorkeeper::OAuth::Helpers::ScopeChecker.valid?(scope_str: "read", server_scopes: config.scopes)
Doorkeeper::OAuth::Helpers::ScopeChecker.valid?(scope_str: "read", server_scopes: config.scopes, app_scopes: application.scopes, grant_type: Doorkeeper::OAuth::AUTHORIZATION_CODE)

# @type var token_response: Doorkeeper::OAuth::TokenResponse
token_response = Doorkeeper::OAuth::TokenResponse.new(token)
token_response.token.token.upcase
token_response.issued_token.token.upcase
token_response.body.fetch("access_token")
token_response.status.to_s
token_response.headers.fetch("Cache-Control").upcase

# @type var invalid_response: Doorkeeper::OAuth::InvalidTokenResponse
invalid_response = Doorkeeper::OAuth::InvalidTokenResponse.from_access_token(token)
invalid_response = Doorkeeper::OAuth::InvalidTokenResponse.from_access_token(nil, { reason: :unknown })
invalid_response.reason.to_s
# @type var forbidden_response: Doorkeeper::OAuth::ForbiddenTokenResponse
forbidden_response = Doorkeeper::OAuth::ForbiddenTokenResponse.from_scopes([:read])
forbidden_response = Doorkeeper::OAuth::ForbiddenTokenResponse.from_scopes(scopes, { state: :forbidden })
# @type var error_response: Doorkeeper::OAuth::ErrorResponse
error_response = forbidden_response
# @type var base_response: Doorkeeper::OAuth::BaseResponse
base_response = error_response
error_response.name.to_s
error_response.description.upcase
error_response.state&.upcase
error_response.body.fetch(:error)
error_response.status.to_s
error_response.headers.fetch("WWW-Authenticate")
error_response.redirectable?

# @type var hook_context: Doorkeeper::OAuth::Hooks::Context
hook_context = Doorkeeper::OAuth::Hooks::Context.new
hook_context.auth
hook_context.pre_auth&.client&.uid
hook_context.issued_token&.token

class OauthRequestInspector
  def pre_auth(server, user)
    # @type var pre_auth: Doorkeeper::OAuth::PreAuthorization
    pre_auth = Doorkeeper::OAuth::PreAuthorization.new(server)
    pre_auth = Doorkeeper::OAuth::PreAuthorization.new(server, { client_id: "uid", response_type: "code" })
    pre_auth = Doorkeeper::OAuth::PreAuthorization.new(server, { client_id: "uid" }, user)
    pre_auth.client.uid.upcase
    pre_auth.code_challenge&.upcase
    pre_auth.code_challenge_method&.upcase
    pre_auth.redirect_uri&.upcase
    pre_auth.resource_owner
    pre_auth.response_type&.upcase
    pre_auth.response_mode&.upcase
    pre_auth.state&.upcase
    pre_auth.custom_access_token_attributes.keys
    pre_auth.authorizable?
    pre_auth.client_valid?
    pre_auth.valid?
    pre_auth.error
    pre_auth.scopes.to_s
    pre_auth.scope&.upcase
    pre_auth.error_response.description
    pre_auth.form_post_response?
  end

  def code_request(code_request)
    code_request.grant.token.upcase
    code_request.client.uid.upcase
    code_request.access_token&.token
  end

  def refresh_request(refresh_request)
    refresh_request.refresh_token.token.upcase
    refresh_request.client&.uid
    refresh_request.access_token&.token
  end
end

class ApplicationController < ActionController::Base
  before_action -> { doorkeeper_authorize! :read, "write" }
  before_action { doorkeeper_authorize! }

  def show
    valid = valid_doorkeeper_token?
    return doorkeeper_render_error unless valid

    current_token = doorkeeper_token
    return head :unauthorized if current_token.nil? || doorkeeper_invalid_token_response?

    render json: { owner: current_token.resource_owner_id, scopes: current_token.scopes.to_s }
  end

  def doorkeeper_unauthorized_render_options(error: nil)
    { json: { error: error&.description } }
  end

  def doorkeeper_forbidden_render_options(error: nil)
    { json: { error: error&.name } }
  end
end

class ApiController < ActionController::API
  before_action -> { doorkeeper_authorize! :read }

  def doorkeeper_token
    super
  end

  def doorkeeper_invalid_token_response?
    super || doorkeeper_token&.resource_owner_id.nil?
  end
end

request = ActionDispatch::Request.new({})
Doorkeeper::OAuth::Token.authenticate(request, :from_bearer_authorization)&.token
Doorkeeper::OAuth::Token.authenticate(request, *config.access_token_methods)&.token
Doorkeeper::OAuth::Token.authenticate(Doorkeeper::Grape::AuthorizationDecorator.new(request), :from_bearer_authorization)
Doorkeeper::OAuth::Token.from_request(request, :from_access_token_param)&.upcase
Doorkeeper::OAuth::Token.from_access_token_param(request)&.upcase
Doorkeeper::OAuth::Token.from_bearer_param(request)&.upcase
Doorkeeper::OAuth::Token.from_bearer_authorization(request)&.upcase
Doorkeeper::OAuth::Token.from_basic_authorization(request)&.upcase

decorator = Doorkeeper::Grape::AuthorizationDecorator.new(request)
decorator.parameters
decorator.authorization&.upcase

class OauthErrorReraiser
  def reraise(oauth_error)
    oauth_error.raise_exception!
  rescue Doorkeeper::Errors::InvalidToken => e
    e.response.description
  rescue Doorkeeper::Errors::DoorkeeperError => e
    e.message.upcase
  end
end

OauthErrorReraiser.new.reraise(forbidden_response)

[
  Doorkeeper::Errors::InvalidRequest,
  Doorkeeper::Errors::InvalidToken,
  Doorkeeper::Errors::InvalidClient,
  Doorkeeper::Errors::InvalidScope,
  Doorkeeper::Errors::InvalidRedirectUri,
  Doorkeeper::Errors::InvalidGrant,
  Doorkeeper::Errors::UnauthorizedClient,
  Doorkeeper::Errors::UnsupportedResponseType,
  Doorkeeper::Errors::AccessDenied,
  Doorkeeper::Errors::ServerError,
  Doorkeeper::Errors::TokenExpired,
  Doorkeeper::Errors::TokenRevoked,
  Doorkeeper::Errors::TokenUnknown,
  Doorkeeper::Errors::TokenForbidden,
].map(&:name_for_response)

class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  def index
    super
  end

  def show
    super
  end

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
  end
end

class Oauth::AuthorizationsController < Doorkeeper::AuthorizationsController
  def new
    super
  end

  def create
    super
  end

  def destroy
    super
  end

  private

  def authenticate_resource_owner!
    return redirect_to("/login") unless current_resource_owner

    super
  end

  def current_resource_owner
    @current_resource_owner ||= super
  end

  def pre_auth_param_fields
    super + [:admin_scope]
  end

  def pre_auth_params
    pre_auth_params = super
    pre_auth_params.merge(extra: pre_auth.scopes.to_s)
  end

  def can_authorize_response?
    pre_auth.client.application.confidential && super
  end

  def authorize_response
    super
  end

  def redirect_or_render(auth)
    pre_auth.code_challenge.nil? ? super : redirect_to("/")
  end

  def before_successful_authorization(context = nil)
    super
  end

  def after_successful_authorization(context)
    context.issued_token&.token
    super
  end
end

class Oauth::AuthorizedApplicationsController < Doorkeeper::AuthorizedApplicationsController
  def index
    super
  end

  def destroy
    super
  end
end

class Oauth::TokensController < Doorkeeper::TokensController
  def create
    super
  end

  def revoke
    token&.accessible? && authorized? ? super : head(:forbidden)
  end

  def introspect
    super
  end

  private

  def authorize_response
    super
  end

  def before_successful_authorization(context = nil)
    super
  end

  def after_successful_authorization(context)
    context.issued_token&.token
    super
  end
end

class Oauth::TokenInfoController < Doorkeeper::TokenInfoController
  def show
    super
  end
end

Doorkeeper::ApplicationController.layout "application"
Doorkeeper::ApplicationMetalController.new

Rails.application.routes.draw do
  use_doorkeeper
  use_doorkeeper scope: "oauth2" do
    controllers authorizations: "oauth2_authorizations", applications: "oauth2_applications"
    skip_controllers :applications, :authorized_applications
    as authorizations: "authorization"
  end
  use_doorkeeper do |mapper|
    mapper.controllers tokens: "oauth/tokens"
    mapper.skip_controllers :token_info
    mapper.as tokens: "token"
  end
end
