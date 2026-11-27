require "excon"
require "logger"

# These methods send requests, so they are defined but never called
def request_with_helpers
  get_response = Excon.get("https://example.com/items", headers: { "Accept" => "application/json" }, query: { "page" => 1 })
  status_code = get_response.status + 1
  body_text = get_response.body.upcase
  Excon.post("https://example.com/hook", body: '{"a":1}', headers: { "Content-Type" => "application/json" })
  Excon.put("https://example.com/items/1", body: "x", expects: [200, 204], idempotent: true, retry_limit: 3)
  Excon.delete("https://example.com/items/1")
  Excon.head("https://example.com/items/1")
  Excon.patch("https://example.com/items/1", body: "y")
  Excon.options("https://example.com/items")
  Excon.connect("https://example.com")
  Excon.trace("https://example.com/")
end

def inspect_response(resp)
  resp.headers["Content-Type"]&.downcase
  resp.headers["content-type"] = "text/plain"
  resp.reason_phrase&.length
  resp.remote_ip&.length
  resp.status_line&.length
  resp.host&.length
  resp.scheme&.length
  resp.path&.length
  resp.port&.succ
  resp.local_port&.succ
  resp.local_address&.length
  resp.http_method.to_s.length
  resp.query.to_s.length
  resp.get_header("Location")&.length
  resp.data[:status]
  resp[:status]
  resp.body = "new body"
  resp.status = 404
  resp.reason_phrase = "Not Found"
  resp.remote_ip = "127.0.0.1"
  resp.status_line = "HTTP/1.1 404 Not Found"
  resp.headers = Excon::Headers.new
  resp.data = { status: 200 }
  resp
end

def read_response
  resp = Excon.get("https://example.com/", read_timeout: 5, connect_timeout: 5, write_timeout: 5)
  inspect_response(resp)
end

Excon::Response.new(status: 200, body: "ok", headers: { "A" => "b" }).status.succ

# Connection
conn = Excon.new("https://example.com", persistent: true, ssl_ca_file: Excon::DEFAULT_CA_FILE, middlewares: Array(Excon.defaults[:middlewares]) + [Excon::Middleware::Decompress])
conn.logger
conn.logger = Logger.new($stderr)
Excon::Connection.new(host: "example.com", hostname: "example.com", scheme: "https", port: 443).reset
conn.data[:host]
conn.reset

def use_connection(conn)
  conn.request(method: :get, path: "/a", expects: [200], idempotent: true, retry_limit: 2)
  conn.get(path: "/b", query: { "q" => "x" })
  conn.post(path: "/c", body: "z")
  conn.put(path: "/d", body: "z")
  conn.delete(path: "/e")
  conn.head(path: "/f")
  conn.patch(path: "/g")
  conn.options(path: "/h")
  conn.connect(path: "/i")
  conn.trace(path: "/j")
  pipelined = conn.requests([{ method: :get, path: "/1" }, { method: :get, path: "/2" }])
  pipelined.first.status.succ
  conn.batch_requests([{ method: :get, path: "/1" }], 10).size
end

def stream_response
  streamed = +""
  # @type var on_chunk: ^(String, Integer?, Integer?) -> Integer
  on_chunk = lambda { |chunk, remaining, total|
    streamed << chunk
    remaining.to_i + total.to_i
  }
  Excon.get("https://example.com/big", response_block: on_chunk)
end

# Defaults
Excon.defaults[:read_timeout] = 10
Excon.defaults[:ssl_verify_callback] ||= lambda { |preverified, _context| preverified }
def request_with_options
  # @type var middlewares: Array[singleton(Excon::Middleware::Base)]
  middlewares = Array(Excon.defaults[:middlewares]).dup
  middlewares << Excon::Middleware::Decompress
  middlewares << Excon::Middleware::RedirectFollower
  middlewares << Excon::Middleware::EscapePath
  Excon.get("https://example.com/", middlewares: middlewares, instrumentor: Excon::StandardInstrumentor)
  Excon.get("https://example.com/", instrumentor: Excon::LoggingInstrumentor, logger: Logger.new($stderr))
end

Excon.defaults = Excon.defaults.merge(retry_limit: 2)
ca_file = Excon::DEFAULT_CA_FILE
ca_file.length
Excon::VERSION.length

# Stubs
Excon.defaults[:mock] = true
stub = Excon.stub({ method: :get, path: "/stubbed" }, { status: 200, body: "stubbed" })
request_params, stubbed_response = stub
request_params[:path]
stubbed_response
Excon.stub({ method: :post }) { |params| { status: 201, body: String(params[:body]) } }
Excon.stubs.size
removed = Excon.unstub(method: :get, path: "/stubbed")
removed&.size
Excon.defaults[:mock] = false

def handle_errors
  begin
    Excon.get("https://example.com/missing", expects: [200])
  rescue Excon::Error::NotFound => e
    e.response&.status
    e.request&.fetch(:path)
    e.message.length
  rescue Excon::Error::HTTPStatus => e
    e.response&.body&.length
  rescue Excon::Error::Timeout, Excon::Error::Socket => e
    e.message.length
  rescue Excon::Error => e
    e.message.length
  end

  begin
    Excon.get("https://example.com/")
  rescue Excon::Errors::Timeout, Excon::Errors::SocketError, Excon::Errors::CertificateError => e
    e.message.length
  rescue Excon::Errors::ExpectationFailed, Excon::Errors::ServerError, Excon::Errors::ClientError => e
    e.response&.status
  end
end

socket_error = Excon::Error::Socket.new(IOError.new("closed"))
socket_error.socket_error.message.length
Excon::Error::Certificate.new(RuntimeError.new("bad cert"))
# @type var proxy_request: String?
proxy_request = Excon::Error::ProxyConnectionError.new("proxy failed", "CONNECT example.com:443 HTTP/1.1\r\n\r\n", { response: { status: 403 } }).request
proxy_request&.length
# @type var proxy_response: Hash[Symbol, untyped]?
proxy_response = Excon::Error::ProxyConnectionError.new("proxy failed").response
proxy_response&.fetch(:response)
Excon::Errors::ExpectationFailed.new("response size too big").message
Excon::Error::InternalServerError.new("boom", { path: "/" }, Excon::Response.new(status: 500)).response&.status
Excon::Error.status_errors.fetch(404)[1].length
Excon::Error.status_error({ expects: [200] }, Excon::Response.new(status: 404)).response&.status
Excon::Errors.status_error({ expects: [200] }, Excon::Response.new(status: 404)).request
Excon::Errors::Error.new("legacy").message
[
  Excon::Error::Informational, Excon::Error::Success, Excon::Error::Redirection, Excon::Error::Client, Excon::Error::Server,
  Excon::Error::StubNotFound, Excon::Error::InvalidStub, Excon::Error::Warning, Excon::Error::InvalidHeaderKey,
  Excon::Error::InvalidHeaderValue, Excon::Error::InvalidParameter, Excon::Error::ResponseParse, Excon::Error::ProxyParse,
  Excon::Error::TooManyRedirects, Excon::Error::TooManyRequests, Excon::Error::BadGateway, Excon::Error::ServiceUnavailable,
  Excon::Error::GatewayTimeout, Excon::Error::Unauthorized, Excon::Error::Forbidden, Excon::Error::UnprocessableEntity
].size

[
  Excon::Middleware::Expects, Excon::Middleware::Idempotent, Excon::Middleware::Instrumentor,
  Excon::Middleware::Mock, Excon::Middleware::ResponseParser
].size

# Added in 1.11 / 1.12 and methods typed for 1.12

# @type var conn2: Excon::Connection
conn2 = Excon.new("http://example.com:8080/base", mock: true)
# @type var mocked: Excon::Response
mocked = conn2.get(path: "/stubbed")
# @type var mocked_body: String
mocked_body = mocked.body
# @type var mocked_status: Integer
mocked_status = mocked.status
# @type var mocked_headers: Excon::Headers
mocked_headers = mocked.headers
# @type var reason: String?
reason = mocked.reason_phrase
# @type var remote_ip: String?
remote_ip = mocked.remote_ip
# @type var header_value: String?
header_value = mocked.get_header(:"content-type")
mocked.params[:status]
mocked.pp
# @type var data: Hash[Symbol, untyped]
data = conn2.data
# @type var pipelined: Array[Excon::Response]
pipelined = conn2.requests([{ method: :get, path: "/1" }])
# @type var batched: Array[Excon::Response]
batched = conn2.batch_requests([{ method: :get, path: "/1" }])
conn2.get(path: "/streamed") { |chunk, remaining, total| chunk.bytesize + remaining.to_i + total.to_i }
Excon.get("http://example.com/") { |chunk, _remaining, _total| chunk.length }
# @type var inspected: String
inspected = conn2.inspect
# @type var valid_keys: Array[Symbol]
valid_keys = conn2.valid_request_keys(Excon.defaults[:middlewares])
# @type var datum: Hash[Symbol, untyped]
datum = conn2.response_call({ response: { body: "", headers: { "Content-Type" => "text/plain" }, status: 200 } })
conn2.error_call({})

# deprecated accessors
conn2.params = conn2.connection
conn2.connection = conn2.params
conn2.proxy = "http://proxy.example.com:3128"
conn2.proxy&.to_s
# @type var retries: Integer
retries = conn2.retry_limit
conn2.retry_limit = 2

# Stubs
Excon.stub({}, lambda { |request_params| { body: request_params[:body], status: 200 } })
# @type var counted: Excon::stub
counted = Excon.stub({ method: :get, path: "/users" }, { body: "[]", status: 200 })
# @type var found: Excon::stub?
found = Excon.stub_for({ method: :get, path: "/users" })
# @type var call_count: Integer
call_count = Excon.stub_call_count(counted)
Excon.record_stub_call(counted)
# @type var verified: true
verified = Excon.verify_stubs(counted)
Excon.verify_stubs
Excon.set_raise_on_warnings!(false)
Excon.display_warning("deprecated")
Excon.mock = true
Excon.mock
Excon.ssl_verify_peer = true
Excon.ssl_verify_peer
Excon.ssl_ca_path = nil
Excon.ssl_ca_path

# Headers
headers = Excon::Headers.new
headers["Content-Type"] = "text/plain"
headers.store(:accept, "*/*")
# @type var content_type: String?
content_type = headers.fetch("content-type")
# @type var fetched: String | Integer
fetched = headers.fetch(:missing, 0)
# @type var from_block: String | Symbol
from_block = headers.fetch("missing") { |key| key.to_sym }
# @type var has_type: bool
has_type = headers.key?(:CONTENT_TYPE) || headers.has_key?("content-type") || headers.member?("Content-Type")
# @type var values: Array[String?]
values = headers.values_at("content-type", :accept)
# @type var pair: [String, String]?
pair = headers.assoc("content-type")
# @type var merged: Excon::Headers
merged = headers.merge("X-Extra" => "1")
headers.merge!("X-Other" => "2").rehash
# @type var deleted: String?
deleted = headers.delete(:accept)
headers.delete("missing") { |key| key.to_s }

# Errors
Excon::Error::Socket.new("no socket").socket_error.message
Excon::Error::SOCKS5Error.new("SOCKS5 proxy authentication failed").socket_error
Excon::Error::StubNotCalled.new("1 of 1 stubs not called").message
# @type var invalid: Array[singleton(Excon::Error::InvalidParameter)]
invalid = [
  Excon::Error::InvalidHost, Excon::Error::InvalidMethod, Excon::Error::InvalidPath,
  Excon::Error::InvalidQuery, Excon::Error::InvalidHeaderKey, Excon::Errors::InvalidHeaderValue
]
# @type var socket_errors: Array[singleton(Excon::Error::Socket)]
socket_errors = [Excon::Errors::ProxyConnectionError, Excon::Errors::SOCKS5Error, Excon::Errors::CertificateError]
# @type var http_error: Excon::Error::HTTPStatus
http_error = Excon::Error::HTTPStatus.new("Expected(200) <=> Actual(404 Not Found)", { expects: [200] }, Excon::Response.new(status: 404))
# @type var http_error_response: Excon::Response?
http_error_response = http_error.response

# Middlewares
class TimingMiddleware < Excon::Middleware::Base
  def self.valid_parameter_keys
    [:timing]
  end

  def request_call(datum)
    datum[:started_at] = Time.now
    @stack.request_call(datum)
  end

  def response_call(datum)
    # @type var response: Hash[Symbol, untyped]
    response = datum[:response]
    response[:elapsed] = Time.now - datum[:started_at]
    @stack.response_call(datum)
  end
end
# @type var default_middlewares: Array[singleton(Excon::Middleware::Base)]
default_middlewares = Excon.defaults[:middlewares]
Excon.new("http://example.com", middlewares: default_middlewares + [TimingMiddleware])
# @type var mock_keys: Array[Symbol]
mock_keys = Excon::Middleware::Mock.valid_parameter_keys
# @type var location: String?
location = Excon::Middleware::RedirectFollower.new(conn2).get_header({ response: { headers: { "Location" => "/next" } } }, "Location")
# @type var parsed: Hash[Symbol, untyped]
parsed = Excon::Middleware::Expects.new(conn2).response_call({ response: { status: 200 } })

# Instrumentors
# @type var instrumented: Integer
instrumented = Excon::StandardInstrumentor.instrument("excon.request", { scheme: "http" }) { 42 }
# @type var not_instrumented: nil
not_instrumented = Excon::LoggingInstrumentor.instrument("excon.response", { body: "ok" })

# Utils and the rest
# @type var escaped: String
escaped = Excon::Utils.escape_uri("/a b")
# @type var query: String
query = Excon::Utils.query_string({ query: { "q" => "x" } })
# @type var redacted: Hash[Symbol, untyped]
redacted = Excon::Utils.redact({ password: "secret" })
Excon::Utils.split_header_value("gzip, chunked").last
Excon::PrettyPrinter.pp($stdout, { status: 200 })
Excon::ResolverFactory.create_resolver
Excon::HTTP_VERBS.size + Excon::DEFAULT_RETRY_LIMIT
