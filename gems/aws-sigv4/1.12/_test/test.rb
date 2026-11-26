# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "aws-sigv4"
require "aws-sigv4/request"
require "stringio"

# Stands in for Aws::EventStream::Encoder (aws-eventstream has no RBS).
class EventEncoder
  def encode_headers(_message)
    ""
  end
end

signer = Aws::Sigv4::Signer.new(
  service: "s3",
  region: "us-east-1",
  access_key_id: "akid",
  secret_access_key: "secret",
  session_token: "token",
  unsigned_headers: ["User-Agent"],
  uri_escape_path: false,
  apply_checksum_header: true,
  signing_algorithm: :sigv4,
  normalize_path: true
)

options = { service: "s3", region: "us-east-1", access_key_id: "akid", secret_access_key: "secret" }
Aws::Sigv4::Signer.new(options)

provider_signer = Aws::Sigv4::Signer.new(
  service: "s3",
  region: "us-east-1",
  credentials_provider: signer.credentials_provider
)
provider_signer.credentials_provider.credentials.access_key_id&.upcase

signer.service.upcase
signer.region.upcase
signer.unsigned_headers.include?("authorization")
signer.apply_checksum_header
Aws::Sigv4::Signer.use_crt?

signature = signer.sign_request(
  http_method: "PUT",
  url: "https://example.com/key",
  headers: { "Content-Type" => "text/plain" },
  body: StringIO.new("body")
)
signature.headers["authorization"]&.upcase
signature.canonical_request.upcase
signature.string_to_sign.upcase
signature.content_sha256.upcase
signature.signature.upcase
signature.extra

request = { http_method: "GET", url: "https://example.com" }
signer.sign_request(request)

url = signer.presign_url(
  http_method: "GET",
  url: URI("https://example.com/key"),
  expires_in: 60,
  body_digest: "UNSIGNED-PAYLOAD",
  time: Time.now
)
url.query&.upcase

headers, prior_signature = signer.sign_event("abc", "payload", EventEncoder.new)
headers[":date"]
prior_signature.upcase

Aws::Sigv4::Errors::MissingCredentialsError.new.message
Aws::Sigv4::Errors::MissingRegionError.new.message
Aws::Sigv4::VERSION.upcase

req = Aws::Sigv4::Request.new(http_method: "GET", endpoint: "https://example.com")
req.http_method&.upcase
req.endpoint&.host
req.headers = { "a" => "b" }
req.headers["a"]
req.body = "body"
req.body
