require "faraday"
require "faraday/multipart"
require "stringio"

# @type var version: String
version = Faraday::Multipart::VERSION
# @type var multipart_post_version: Gem::Version
multipart_post_version = Faraday::Multipart.multipart_post_version

# @type var file: Faraday::Multipart::FilePart
file = Faraday::Multipart::FilePart.new(__FILE__, "text/x-ruby")
Faraday::Multipart::FilePart.new(StringIO.new("io-content"), "application/pdf", "doc.pdf")
Faraday::Multipart::FilePart.new(__FILE__, "text/x-ruby", nil, { "Content-Disposition" => "form-data; foo=1" })
# @type var content_type: String
content_type = file.content_type

# @type var param: Faraday::Multipart::ParamPart
param = Faraday::Multipart::ParamPart.new('{"a":1}', "application/json")
param = Faraday::Multipart::ParamPart.new('{"a":1}', "application/json", "foo-123")
# @type var headers: Hash[String, String?]
headers = param.headers
# @type var value: String
value = param.value
content_type = param.content_type
# @type var content_id: String?
content_id = param.content_id
# @type var part: Multipart::Post::Parts::ParamPart
part = param.to_part("boundary", "json")
part = param.to_part("boundary", :json)

stubs = Faraday::Adapter::Test::Stubs.new
connection = Faraday.new do |builder|
  builder.request :multipart, content_type: "multipart/mixed", flat_encode: true
  builder.adapter :test, stubs
end
connection.post("/upload", { a: 1, file: file, json: param, list: [file, "x"] })

# @type var middleware: Faraday::Multipart::Middleware
middleware = Faraday::Multipart::Middleware.new
middleware = Faraday::Multipart::Middleware.new(nil, content_type: "multipart/related")
middleware = Faraday::Multipart::Middleware.new(->(env) { env }, { flat_encode: true })
# @type var content_type_header: String
content_type_header = Faraday::Multipart::Middleware::CONTENT_TYPE

# @type var io: Faraday::Multipart::CompositeReadIO
io = Faraday::Multipart::CompositeReadIO.new(part, Multipart::Post::Parts::EpiloguePart.new("boundary"))
io = Faraday::Multipart::CompositeReadIO.new([part])
# @type var length: Integer
length = io.length
# @type var all: String
all = io.read
all = io.read(nil, +"")
io.rewind
# @type var chunk: String?
chunk = io.read(3)
chunk = io.read(3, +"")
io.close

# The Faraday v1 aliases are deprecated; check that they name the same classes.
# @type var legacy_file: Faraday::FilePart
legacy_file = file
# @type var legacy_upload_io: Faraday::UploadIO
legacy_upload_io = file
# @type var legacy_param: Faraday::ParamPart
legacy_param = param
# @type var legacy_part: Faraday::Parts::ParamPart
legacy_part = part
# @type var legacy_io: Faraday::CompositeReadIO
legacy_io = io
