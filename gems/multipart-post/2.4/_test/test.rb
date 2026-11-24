# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "net/http/post/multipart"
require "multipart/post/version"
require "stringio"
require "uri"

version = Multipart::Post::VERSION

io = Multipart::Post::UploadIO.new(StringIO.new("1234567890"), "text/plain", "file.txt")
Multipart::Post::UploadIO.new(__FILE__, "text/plain")
Multipart::Post::UploadIO.new(File.open(__FILE__), "text/plain", nil, { "Content-Transfer-Encoding" => "8bit" })
content_type = io.content_type
original_filename = io.original_filename
local_path = io.local_path
io.io
opts = io.opts

boundary = Multipart::Post::Multipartable.secure_boundary

req = Net::HTTP::Post::Multipart.new("/upload", "file" => io, "text" => "bar")
req = Net::HTTP::Post::Multipart.new(
  URI.parse("http://example.com/upload"),
  { text: "bar", list: ["a", "b"], file: io },
  { "Authorization" => "token", parts: { text: { "Content-Type" => "text/plain" } } },
  boundary
)
boundary = req.boundary
req["Authorization"] = "token"
body = req.body_stream

put = Net::HTTP::Put::Multipart.new("/upload", { "file" => io })
boundary = put.boundary

composite = Multipart::Post::CompositeReadIO.new(StringIO.new("one"), [StringIO.new("two")])
whole = composite.read
whole = composite.read(nil, String.new)
chunk = composite.read(3)
pos = composite.rewind
closed = composite.closed?
composite.close

part = Multipart::Post::Parts::Part.new(boundary, "name", "value")
part = Multipart::Post::Parts::Part.new(boundary, :file, io, nil)
file = Multipart::Post::Parts::Part.file?(io)
length = part.length
part_io = part.to_io
Multipart::Post::Parts::ParamPart.new(boundary, "name", "value", { "Content-ID" => "id" })
Multipart::Post::Parts::FilePart.new(boundary, "file", io)
Multipart::Post::Parts::EpiloguePart.new(boundary)
