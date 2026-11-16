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
Excon::Error::ProxyConnectionError.new("proxy failed", { host: "p" }, nil).request
Excon::Error::ProxyConnectionError.new("proxy failed").response
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
