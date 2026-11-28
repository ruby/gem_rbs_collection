require "googleauth"

class MyCredentials < Google::Auth::Credentials
  # Set the default scope for these credentials
  self.scope = "http://example.com/my_scope"
end

Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: StringIO.new(''), scope: []
)

# @type var scope: Array[String]?
scope = MyCredentials.scope
# @type var env_vars: Array[String]
env_vars = MyCredentials.env_vars
# @type var paths: Array[String]
paths = MyCredentials.paths
# @type var token_uri: String
token_uri = MyCredentials.token_credential_uri
# @type var audience: String
audience = MyCredentials.audience
# @type var target_audience: String?
target_audience = MyCredentials.target_audience

# @type var creds: MyCredentials
creds = MyCredentials.new({ "type" => "authorized_user" }, project_id: "my-project")
# @type var project_id: String?
project_id = creds.project_id
# @type var copy: MyCredentials
copy = creds.duplicate(scope: "https://www.googleapis.com/auth/cloud-platform")
# @type var universe_domain: String?
universe_domain = creds.universe_domain
# @type var logger: Logger?
logger = creds.logger
# @type var default_creds: MyCredentials
default_creds = MyCredentials.default

# @type var app_default: Google::Auth::default_credentials | Google::Auth::GCECredentials
app_default = Google::Auth.get_application_default(["https://www.googleapis.com/auth/cloud-platform"])

# @type var sa: Google::Auth::ServiceAccountCredentials
sa = Google::Auth::ServiceAccountCredentials.make_creds(json_key_io: File.open("key.json"))
# @type var sa_copy: Google::Auth::ServiceAccountCredentials
sa_copy = sa.duplicate(scope: "https://www.googleapis.com/auth/cloud-platform")
# @type var self_signed: bool
self_signed = sa.enable_self_signed_jwt?
# @type var header: String | Hash[untyped, untyped]
header = sa.apply!({})
# @type var applied: Hash[Symbol, String]
applied = sa.apply({ foo: "bar" })
# @type var sa_universe: String?
sa_universe = sa.universe_domain
sa.on_refresh { |refreshed| refreshed.universe_domain }
# @type var unescaped: String
unescaped = Google::Auth::ServiceAccountCredentials.unescape('"a\\nb"')

# @type var jwt: Google::Auth::ServiceAccountJwtHeaderCredentials
jwt = Google::Auth::ServiceAccountJwtHeaderCredentials.make_creds(json_key_io: File.open("key.json"))
# @type var jwt_token: String
jwt_token = jwt.new_jwt_token("https://example.com")

# @type var key_fields: [String, String, String?, String?, String?]
key_fields = Google::Auth::ServiceAccountCredentials.read_json_key(File.open("key.json"))
# @type var key_fields_from_string: [String, String, String?, String?, String?]
key_fields_from_string = Google::Auth::ServiceAccountCredentials.read_json_key(StringIO.new("{}"))
# @type var env_key: String?
env_key = Google::Auth::ServiceAccountCredentials.unescape(ENV["GOOGLE_PRIVATE_KEY"])
# @type var json_key: Hash[String, untyped]?
json_key, = Google::Auth::DefaultCredentials.determine_creds_class(StringIO.new("{}"))

# @type var user: Google::Auth::UserRefreshCredentials
user = Google::Auth::UserRefreshCredentials.make_creds(json_key_io: StringIO.new("{}"))
# @type var granted: bool
granted = user.includes_scope?("email")

# @type var defaults: Google::Auth::default_credentials
defaults = Google::Auth::DefaultCredentials.make_creds(json_key_io: StringIO.new("{}"))

# @type var gce: Google::Auth::GCECredentials
gce = Google::Auth::GCECredentials.new
# @type var on_gce: bool
on_gce = Google::Auth::GCECredentials.on_gce?

# @type var api_key: Google::Auth::APIKeyCredentials
api_key = Google::Auth::APIKeyCredentials.make_creds(api_key: "key")
# @type var api_key_from_env: Google::Auth::APIKeyCredentials?
api_key_from_env = Google::Auth::APIKeyCredentials.from_env
# @type var api_headers: Hash[String, String]
api_headers = api_key.apply!({ "accept" => "application/json" })

# @type var bearer: Google::Auth::BearerTokenCredentials
bearer = Google::Auth::BearerTokenCredentials.new(token: "token", expires_at: Time.now + 3600)
# @type var expires_at: Time?
expires_at = bearer.expires_at
# @type var expiring: bool
expiring = bearer.expires_within?(60)

# @type var impersonated: Google::Auth::ImpersonatedServiceAccountCredentials
impersonated = Google::Auth::ImpersonatedServiceAccountCredentials.new(
  source_credentials: sa,
  impersonation_url: "https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/sa@example.com:generateAccessToken",
  scope: ["https://www.googleapis.com/auth/cloud-platform"]
)
# @type var impersonated_token: String?
impersonated_token = impersonated.access_token

# @type var external: Google::Auth::ExternalAccount::AwsCredentials | Google::Auth::ExternalAccount::IdentityPoolCredentials | Google::Auth::ExternalAccount::PluggableAuthCredentials
external = Google::Auth::ExternalAccount::Credentials.make_creds(json_key_io: StringIO.new("{}"))
# @type var workforce: bool
workforce = external.is_workforce_pool?
# @type var external_project: String?
external_project = external.project_number

# @type var normalized: Array[String]
normalized = Google::Auth::ScopeUtil.normalize("email profile")

# @type var client_id: Google::Auth::ClientId
client_id = Google::Auth::ClientId.new("id", "secret")

# @type var payload: Hash[String, untyped]
payload = Google::Auth::IDTokens.verify_oidc("token", aud: "client-id")
# @type var key_source: Google::Auth::IDTokens::StaticKeySource
key_source = Google::Auth::IDTokens::StaticKeySource.from_jwk_set("{}")
verifier = Google::Auth::IDTokens::Verifier.new(key_source: key_source, iss: Google::Auth::IDTokens::OIDC_ISSUERS)
# @type var verified: Hash[String, untyped]
verified = verifier.verify("token", aud: ["a", "b"])

begin
  Google::Auth.get_application_default
rescue Google::Auth::InitializationError, Google::Auth::AuthorizationError => e
  # @type var principal: String | Symbol | nil
  principal = e.is_a?(Google::Auth::AuthorizationError) ? e.principal : nil
end
