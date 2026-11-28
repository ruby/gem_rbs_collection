require "websocket/driver"

class TestClientSocket
  def initialize(url)
    @url = url
  end

  def url
    @url
  end

  def write(data)
    data.bytesize
  end
end

class TestRackSocket < TestClientSocket
  def initialize(env)
    super("ws://example.com/chat")
    @env = env
  end

  def env
    @env
  end
end

socket = TestClientSocket.new("ws://user:pass@example.com/chat?room=1")

# @type var client: WebSocket::Driver::Client
client = WebSocket::Driver.client(socket)
client = WebSocket::Driver.client(socket, protocols: ["chat", "superchat"], max_length: 1024)
client = WebSocket::Driver.client(socket, { protocols: "chat, superchat" })

# @type var listener: ^(untyped) -> void
listener = client.on(:open) { |event| p event }
listener = client.on("message") { |event| p event }
handler = ->(event) { p event }
# @type var lambda_listener: ^(untyped) -> untyped
lambda_listener = client.on(:close, handler)
client.add_listener(:error) { |error| p error }
client.remove_listener(:close, handler)
client.remove_listener(:open, &listener)
client.emit(:message, WebSocket::Driver::MessageEvent.new("hello"))
# @type var count: Integer
count = client.listener_count(:message)
# @type var listeners: Array[WebSocket::Driver::EventEmitter::_Listener]
listeners = client.listeners(:message)
client.remove_all_listeners(:message)
client.remove_all_listeners

# @type var sent: bool
sent = client.set_header("X-Custom", "value")
sent = client.add_extension(Object.new)
sent = client.start
client.parse("HTTP/1.1 101 Switching Protocols\r\n\r\n")
# @type var queued: boolish
queued = client.text("hello")
queued = client.binary([1, 2, 3])
queued = client.binary("\x01\x02".b)
queued = client.ping("ping") { puts "pong" }
queued = client.ping
queued = client.pong("pong")
sent = client.close
sent = client.close("bye", 1000)
# @type var version: String
version = client.version
# @type var protocol: String?
protocol = client.protocol
# @type var state: (:connecting | :open | :closing | :closed)?
state = client.state
# @type var ready_state: Integer
ready_state = client.ready_state
# @type var status: Integer?
status = client.status
# @type var headers: WebSocket::Driver::Headers
headers = client.headers
# @type var key: String
key = WebSocket::Driver::Client.generate_key
key = WebSocket::Driver::Hybi.generate_accept(key)

# @type var proxy: WebSocket::Driver::Proxy
proxy = client.proxy("http://user:pass@proxy.example.com")
proxy.on(:connect) { |_event| client.start }
sent = proxy.set_header("User-Agent", "test")
sent = proxy.start
proxy.parse("HTTP/1.1 200 OK\r\n\r\n")
status = proxy.status
headers = proxy.headers

# @type var server: WebSocket::Driver::Server
server = WebSocket::Driver.server(socket)
server = WebSocket::Driver.server(socket, require_masking: false)
server.on(:connect) do |_event|
  env = server.env
  server.start if env && WebSocket::Driver.websocket?(env)
end
server.parse("GET /chat HTTP/1.1\r\nHost: example.com\r\n\r\n")
# @type var env: Hash[String, untyped]?
env = server.env
# @type var url: String?
url = server.url
server.write("data")
queued = server.text("hello")
queued = server.binary("data")
queued = server.ping("data") { nil }
sent = server.close("bye")
protocol = server.protocol
# @type var server_version: String?
server_version = server.version

rack_env = {
  "REQUEST_METHOD" => "GET",
  "HTTP_CONNECTION" => "Upgrade",
  "HTTP_UPGRADE" => "websocket",
  "HTTP_SEC_WEBSOCKET_KEY" => "dGhlIHNhbXBsZSBub25jZQ==",
  "HTTP_SEC_WEBSOCKET_VERSION" => "13"
}
# @type var upgrade: bool
upgrade = WebSocket::Driver.websocket?(rack_env)
# @type var driver: WebSocket::Driver::Hybi | WebSocket::Driver::Draft76 | WebSocket::Driver::Draft75
driver = WebSocket::Driver.rack(TestRackSocket.new(rack_env), allow_drafts: true)
driver.start
version = driver.version
queued = driver.ping("ping") { nil }

# @type var hybi: WebSocket::Driver::Hybi
hybi = WebSocket::Driver::Hybi.new(TestRackSocket.new(rack_env), require_masking: true)
hybi.parse("\x81\x05hello".b)

# @type var draft75: WebSocket::Driver::Draft75
draft75 = WebSocket::Driver::Draft75.new(TestRackSocket.new(rack_env))
sent = draft75.ping
sent = draft75.binary("data")
draft75.parse("\x00hello\xFF".b)
# @type var draft76: WebSocket::Driver::Draft76
draft76 = WebSocket::Driver::Draft76.new(TestRackSocket.new(rack_env), {})
version = draft76.version

# @type var encoded: String
encoded = WebSocket::Driver.encode("hello", Encoding::UTF_8)
encoded = WebSocket::Driver.encode([104, 105])
# @type var options: Hash[Symbol, Integer]
options = WebSocket::Driver.validate_options({ max_length: 10 }, [:max_length])
# @type var masked: String
masked = WebSocket::Mask.mask("data".b, "\x01\x02\x03\x04".b)
masked = WebSocket::Mask.mask("data", nil)

header_list = WebSocket::Driver::Headers.new({ "Content-Type" => "text/plain" })
header_list["Content-Length"] = 10
# @type var value: String?
value = header_list["content-type"]
value = header_list[:content_type]
# @type var raw: Hash[String, String]
raw = header_list.to_h
# @type var lines: String
lines = header_list.to_s
lines = header_list.inspect
header_list.clear

close_event = WebSocket::Driver::CloseEvent.new(1000, "bye")
# @type var code: Integer?
code = close_event.code
# @type var reason: String?
reason = close_event.reason
# @type var data: String | Array[Integer]
data = WebSocket::Driver::MessageEvent.new([1, 2]).data
# @type var ping_data: String
ping_data = WebSocket::Driver::PingEvent.new("ping").data
ping_data = WebSocket::Driver::PongEvent.new("pong").data
WebSocket::Driver::OpenEvent.new
WebSocket::Driver::ConnectEvent.new
# @type var max: Integer
max = WebSocket::Driver::MAX_LENGTH
# @type var close_code: Integer?
close_code = WebSocket::Driver::Hybi::ERRORS[:normal_closure]
