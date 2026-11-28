require "signet"
require "signet/oauth_2/client"
require "signet/oauth_1/client"
require "signet/oauth_1/server"

begin
  raise Signet::AuthorizationError, "denied"
rescue Signet::AuthorizationError => e
  # @type var failed_response: Faraday::Response?
  failed_response = e.response
end

class MyClient < Signet::OAuth2::Client
end

client = Signet::OAuth2::Client.new({
  :authorization_uri => 'https://example.com/authorization',
  :token_credential_uri => 'https://example.com/token',
  :client_id => 'my_client_id',
  :client_secret => 'my_client_secret',
  :scope => 'example',
  :redirect_uri => 'https://example.com/oauth'
})

options = { client_id: "id" } # : Hash[Symbol, untyped]
Signet::OAuth2::Client.new(options)
Signet::OAuth2::Client.new("client_id" => "id", "scope" => ["a", "b"])
MyClient.new(issuer: "app@example.com", signing_key: "secret", audience: "https://example.com/token")

# @type var updated: Signet::OAuth2::Client
updated = client.update!(access_token: "token", expires_in: 3600)
client.update_token!(refresh_token: "refresh", issued_at: Time.now, expires_at: 1_700_000_000)

# @type var authorization_uri: Addressable::URI?
authorization_uri = client.authorization_uri(prompt: "consent")
client.authorization_uri = { scheme: "https", host: "example.com", path: "/auth" }
# @type var token_uri: Addressable::URI?
token_uri = client.token_credential_uri
# @type var client_id: String?
client_id = client.client_id
# @type var scope: Array[String]?
scope = client.scope
client.scope = ["email", "profile"]
# @type var redirect_uri: Addressable::URI?
redirect_uri = client.redirect_uri
# @type var access_token: String?
access_token = client.access_token
# @type var refresh_token: String?
refresh_token = client.refresh_token
# @type var id_token: String?
id_token = client.id_token
# @type var expires_in: Integer?
expires_in = client.expires_in
# @type var expires_at: Time?
expires_at = client.expires_at
# @type var issued_at: Time?
issued_at = client.issued_at
# @type var expired: bool
expired = client.expired?
# @type var expires_soon: bool
expires_soon = client.expires_within?(60)
# @type var grant_type: (String | Addressable::URI)?
grant_type = client.grant_type
client.grant_type = "client_credentials"
# @type var person: String?
person = client.person
# @type var signing_key: (String | OpenSSL::PKey::PKey)?
signing_key = client.signing_key
# @type var algorithm: String
algorithm = client.signing_algorithm
# @type var expiry: Integer?
expiry = client.expiry
# @type var granted_scopes: Array[String]?
granted_scopes = client.granted_scopes
# @type var json: String
json = client.to_json
# @type var jwt: String
jwt = client.to_jwt

connection = Faraday.new
# @type var token_response: Hash[String, untyped]?
token_response = client.fetch_access_token!(connection: connection)
# @type var refreshed: Hash[String, untyped]?
refreshed = client.refresh!
# @type var request: Faraday::Request
request = client.generate_authenticated_request(uri: "https://example.com/api", connection: connection)
# @type var response: Faraday::Response
response = client.fetch_protected_resource(uri: "https://example.com/api", connection: connection)
# @type var payload: Hash[String, untyped]
payload = client.decoded_id_token
client.clear_credentials!

# @type var auth_params: Array[[String, String?]]
auth_params = Signet::OAuth2.parse_authorization_header("Bearer abc")
# @type var challenge: Array[[String, String]]
challenge = Signet::OAuth2.parse_www_authenticate_header('OAuth realm="example"')
# @type var bearer: String
bearer = Signet::OAuth2.generate_bearer_authorization_header("token", [["realm", "example"]])
# @type var basic: String
basic = Signet::OAuth2.generate_basic_authorization_header("id", "secret")
# @type var uri_string: String
uri_string = Signet::OAuth2.generate_authorization_uri("https://example.com/auth", "client_id" => "id")
Signet::OAuth2.parse_credentials('{"access_token":"abc"}', "application/json")

# @type var credential: Signet::OAuth1::Credential
credential = Signet::OAuth1::Credential.new("key", "secret")
Signet::OAuth1::Credential.new(key: "key", secret: "secret")
# @type var credential_hash: Hash[String, String]
credential_hash = credential.to_h

oauth1 = Signet::OAuth1::Client.new(
  temporary_credential_uri: "https://example.com/request_token",
  authorization_uri: "https://example.com/authorize",
  token_credential_uri: "https://example.com/access_token",
  client_credential_key: "key",
  client_credential_secret: "secret"
)
# @type var temporary_credential: Signet::OAuth1::Credential
temporary_credential = oauth1.fetch_temporary_credential!
# @type var oauth1_authorization_uri: Addressable::URI?
oauth1_authorization_uri = oauth1.authorization_uri
# @type var token_credential: Signet::OAuth1::Credential
token_credential = oauth1.fetch_token_credential!(verifier: "12345")
# @type var consumer_key: String?
consumer_key = oauth1.consumer_key
# @type var callback: String
callback = oauth1.callback
# @type var oauth1_request: Faraday::Request
oauth1_request = oauth1.generate_authenticated_request(uri: "https://example.com/api")

# @type var header: String
header = Signet::OAuth1.generate_authorization_header([["oauth_consumer_key", "key"]], "example")
# @type var signature: String
signature = Signet::OAuth1.sign_parameters(:post, "https://example.com", { "oauth_signature_method" => "HMAC-SHA1" }, "secret")
# @type var encoded: String
encoded = Signet::OAuth1.encode("a b")

server = Signet::OAuth1::Server.new(
  client_credential: ->(key) { Signet::OAuth1::Credential.new(key, "secret") },
  nonce_timestamp: ->(_nonce, _timestamp) { true }
)
# @type var callback_or_false: String | false
callback_or_false = server.authenticate_temporary_credential_request(
  method: "POST", uri: "https://example.com/request_token", headers: [["Authorization", header]]
)
# @type var resource: { client_credential: Signet::OAuth1::Credential, token_credential: Signet::OAuth1::Credential?, realm: String? }?
resource = server.authenticate_resource_request(method: "GET", uri: "https://example.com/api", headers: [], two_legged: true)
