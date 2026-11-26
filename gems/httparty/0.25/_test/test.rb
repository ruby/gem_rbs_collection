require "httparty"
require "stringio"

class Client
  include HTTParty

  base_uri "example.com"
  foul true
  logger nil, :debug, :curl
  raise_on [404, 500..599, "3.."]
  http_proxy "proxy.example.com", 8080, "user", "pass"
  default_params api_key: "secret"
  debug_output StringIO.new
  cookies session: "abc"
  follow_redirects true
  no_follow false
  maintain_method_across_redirects true
  resend_on_redirect false
  skip_decompression
  ciphers ["AES128-SHA"]
  ssl_version :TLSv1_2
  ssl_ca_file "/etc/ssl/certs/ca-certificates.crt"
  ssl_ca_path "/etc/ssl/certs"
  uri_adapter URI
  query_string_normalizer HTTParty::Request::NON_RAILS_QUERY_STRING_NORMALIZER
  disable_rails_query_string_format
  connection_adapter HTTParty::ConnectionAdapter, { verify: false }
end

# @type var base: String?
base = Client.base_uri
# @type var set_base: String
set_base = Client.base_uri("api.example.com")
# @type var headers: Hash[untyped, untyped]
headers = Client.headers("Accept" => "application/json")
# @type var params: Hash[untyped, untyped]
params = Client.default_params
# @type var cookie_hash: HTTParty::CookieHash
cookie_hash = Client.cookies(token: "x")
# @type var format: (Symbol | String)?
format = Client.format
# @type var options: Hash[untyped, untyped]
options = Client.default_options
# @type var request: HTTParty::Request
request = Client.build_request(Net::HTTP::Get, "/users", query: { page: 1 })

# @type var response: HTTParty::Response
response = HTTParty.get("http://example.com/users", query: { page: 1 })
response = HTTParty.lock("http://example.com/users")
response = HTTParty.mkcol("http://example.com/users")
response = HTTParty.unlock("http://example.com/users")
response = Client.get("/users") { |fragment| fragment.code }
request = HTTParty.build_request(Net::HTTP::Post, "http://example.com/users", body: { name: "a" })

# @type var code: Integer
code = response.code
# @type var body: String?
body = response.body
# @type var http_headers: HTTParty::Response::Headers
http_headers = response.headers
# @type var success: bool
success = response.success?
success = response.ok?
success = response.not_found?
success = response.multiple_choice?
# @type var net_response: Net::HTTPResponse
net_response = response.response
# @type var parsed: untyped
parsed = response.parsed_response

# @type var last_response: Net::HTTPResponse?
last_response = request.last_response
# @type var request_format: (Symbol | String)?
request_format = request.format
# @type var performed: HTTParty::Response
performed = request.perform

begin
  HTTParty.get("http://example.com/missing")
rescue HTTParty::RedirectionTooDeep => e
  # @type var too_deep_response: Net::HTTPResponse?
  too_deep_response = e.response
rescue HTTParty::ResponseError => e
  # @type var error_response: Net::HTTPResponse?
  error_response = e.response
end

# @type var parsed_body: untyped
parsed_body = HTTParty::Parser.call('{"a":1}', :json)
# @type var mime_format: Symbol?
mime_format = HTTParty::Parser.format_from_mimetype("application/json")
# @type var query: String
query = HTTParty::HashConversions.to_params(a: 1, b: [1, 2])
# @type var decompressed: String?
decompressed = HTTParty::Decompressor.new("body", "identity").decompress
# @type var connection: Net::HTTP
connection = HTTParty::ConnectionAdapter.call(URI("https://example.com"), {})
