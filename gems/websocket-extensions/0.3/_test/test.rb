require "websocket/extensions"

class TestMessage
  def initialize(data)
    @data = data
  end

  def data = @data

  def rsv1 = false
  def rsv2 = false
  def rsv3 = false
  def opcode = 1
end

class TestFrame
  def initialize(opcode, rsv1)
    @opcode = opcode
    @rsv1 = rsv1
  end

  def opcode = @opcode
  def rsv1 = @rsv1

  def rsv2 = false
  def rsv3 = false
end

class ReverseSession
  def generate_offer
    { "utf8" => true }
  end

  def activate(params)
    true
  end

  def generate_response
    { "utf8" => true }
  end

  def process_incoming_message(message)
    message
  end

  def process_outgoing_message(message)
    message
  end

  def close
    nil
  end
end

class ReverseExtension
  def name = "reverse"
  def type = "permessage"
  def rsv1 = true
  def rsv2 = false
  def rsv3 = false

  def create_client_session(options)
    ReverseSession.new
  end

  def create_server_session(offers, options)
    ReverseSession.new
  end
end

WebSocket::Extensions.validate_options({ max_length: 10 }, [:max_length])
WebSocket::Extensions.validate_options(nil, [:max_length])

client = WebSocket::Extensions.new(max_length: 0x3fff)
client.add(ReverseExtension.new)

# @type var offer: String?
offer = client.generate_offer
client.activate("reverse; utf8")
client.activate(nil)

# @type var frame_ok: bool
frame_ok = client.valid_frame_rsv(TestFrame.new(1, true))
client.valid_frame_rsv?(TestFrame.new(8, false))

# @type var incoming: WebSocket::Extensions::_Message
incoming = client.process_incoming_message(TestMessage.new("hello"))
# @type var outgoing: WebSocket::Extensions::_Message
outgoing = client.process_outgoing_message(TestMessage.new("hello"))
incoming.data
outgoing.data
client.close

server = WebSocket::Extensions.new
server.add(ReverseExtension.new)
# @type var response: String?
response = server.generate_response("reverse; utf8, deflate")
server.generate_response(nil)

begin
  WebSocket::Extensions.new({ max_length: 10, other: 1 })
rescue WebSocket::Extensions::ExtensionError => e
  e.message
  e.type
end
WebSocket::Extensions::ExtensionError.new("deflate: too large", 1009).type

# @type var offers: WebSocket::Extensions::Offers
offers = WebSocket::Extensions::Parser.parse_header("a; b=1; c=\"x\", a; d")
offers.each_offer do |name, params|
  name.upcase
  params["b"]
end
# @type var by_name: Array[WebSocket::Extensions::params]
by_name = offers.by_name("a")
offers.to_a.each { |offer| offer[:name] }
offers.push("e", { "f" => true, "g" => [1, "h"] })
WebSocket::Extensions::Parser.parse_header(nil)

# @type var header: String
header = WebSocket::Extensions::Parser.serialize_params("a", { "b" => true, "c" => 1, "d" => [true, "hi"] })

begin
  WebSocket::Extensions::Parser.parse_header("a,")
rescue WebSocket::Extensions::Parser::ParseError
end
