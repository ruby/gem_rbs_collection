# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "websocket"

WebSocket.max_frame_size = 1024 * 1024
WebSocket.max_frame_size.succ
WebSocket.should_raise = false

server = WebSocket::Handshake::Server.new(secure: false, protocols: ["chat"])
server << "GET /demo HTTP/1.1\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nHost: example.com\r\n" \
          "Sec-WebSocket-Version: 13\r\nSec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n\r\n"
if server.finished? && server.valid?
  server.to_s.bytesize
  server.version&.succ
  server.host.upcase
  server.port.succ
  server.headers["host"]
  server.leftovers.empty?
end
server.error&.to_s

client = WebSocket::Handshake::Client.new(url: "ws://example.com/demo", headers: { "Cookie" => "a=b" })
client.to_s.bytesize
client.path.upcase
client.version.succ
finished = client << "HTTP/1.1 101 Switching Protocols\r\n\r\n"
finished.inspect
client.uri.upcase
client.state == :error

outgoing = WebSocket::Frame::Outgoing::Server.new(version: client.version, data: "Hello", type: :text)
outgoing.to_s&.bytesize
outgoing.supported?

incoming = WebSocket::Frame::Incoming::Client.new(version: client.version)
incoming << "\x81\x05Hello"
frame = incoming.next
if frame
  frame.data.upcase
  frame.type
  frame.decoded?
end

begin
  WebSocket.should_raise = true
  WebSocket::Frame::Incoming::Server.new(version: 99)
rescue WebSocket::Error::Frame::UnknownVersion => e
  e.message.to_proc
end

# The constructors also take the options as one positional Hash.
options = { url: "ws://example.com/chat", version: 13 }
WebSocket::Handshake::Client.new(options).to_s.upcase
WebSocket::Handshake::Server.new({ secure: true }).finished?
WebSocket::Frame::Incoming::Server.new({ version: 13 }).decoded?
WebSocket::Frame::Outgoing::Client.new({ version: 13, data: "x", type: :text }).supported?
