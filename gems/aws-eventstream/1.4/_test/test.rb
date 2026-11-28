require "aws-eventstream"
require "stringio"
require "tempfile"

headers = {
  "event" => Aws::EventStream::HeaderValue.new(type: "string", value: "hello"),
  "count" => Aws::EventStream::HeaderValue.new(type: "integer", value: 42),
  "flag" => Aws::EventStream::HeaderValue.new(type: "bool_true", value: true),
  "at" => Aws::EventStream::HeaderValue.new(type: "timestamp", value: 1_700_000_000_000)
}
message = Aws::EventStream::Message.new(headers: headers, payload: StringIO.new("payload"))
Aws::EventStream::Message.new(payload: StringIO.new("payload"))
options = { headers: headers }
Aws::EventStream::Message.new(options)

# @type var header_value: Aws::EventStream::HeaderValue?
header_value = message.headers["event"]
header_value&.type&.upcase
header_value&.value

encoder = Aws::EventStream::Encoder.new
# @type var encoded: String
encoded = encoder.encode(message)
# @type var encoded_headers: String
encoded_headers = encoder.encode_headers(message)
encoded_headers.bytesize
encoder.encode_message(message).bytesize
encoder.encode(message, StringIO.new)
Tempfile.create("event") { |file| encoder.encode(message, file) }

decoder = Aws::EventStream::Decoder.new
Aws::EventStream::Decoder.new(format: false)
# @type var decoded: Aws::EventStream::Message?
decoded, eof = decoder.decode_chunk(encoded)
payload = decoded&.payload
payload.read unless payload.nil? || payload.is_a?(String)
eof
decoder.decode_chunk
# @type var names: Array[String]
names = decoder.decode(StringIO.new(encoded)) { |m| m ? m.headers.keys : [] }
names.size
# @type var enum: Enumerator[[Aws::EventStream::Message?, bool], untyped]
enum = decoder.decode(StringIO.new(encoded))
enum.next

# @type var types: Array[String]
types = Aws::EventStream::Types.types
types.size
Aws::EventStream::Types.pattern["integer"]

begin
  decoder.decode_chunk("x" * 16)
rescue Aws::EventStream::Errors::PreludeChecksumError => e
  e.message
end
Aws::EventStream::Errors::EventHeaderValueWidthError.new("uuid").message
Aws::EventStream::Errors::ReadBytesExceedLengthError.new(10, 5).message
