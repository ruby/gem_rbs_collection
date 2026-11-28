require "ethon"
require "logger"
require "stringio"

Ethon.logger = Logger.new($stderr)
# @type var logger: Logger
logger = Ethon.logger

Ethon::Curl.init
# @type var curl_version: String
curl_version = Ethon::Curl.version
Ethon::Curl.version_info[:version]

# @type var zlib: bool
zlib = Ethon::Easy.supports_zlib?

easy = Ethon::Easy.new(url: "http://localhost:3001/", followlocation: true, timeout: 10)
easy.headers = { "User-Agent" => "ethon", "Accept" => "text/plain" }
easy.connecttimeout = 5
easy.ssl_verifypeer = false
easy.proxytype = :http
easy.httpauth = [:basic, :digest]
easy.userpwd = "user:password"
easy.verbose = true
easy.on_headers { |e| e.response_code }
easy.on_body { |chunk, _e| chunk.bytesize > 0 ? nil : :abort }
easy.on_progress { |dltotal, dlnow, _ultotal, _ulnow| dlnow <= dltotal }
easy.on_complete { |e| e.return_code }

# @type var return_code: Symbol
return_code = easy.perform
# @type var response_code: Integer
response_code = easy.response_code
# @type var body: String?
body = easy.response_body
# @type var headers: String
headers = easy.response_headers
# @type var total_time: Float
total_time = easy.total_time
# @type var effective_url: String?
effective_url = easy.effective_url
# @type var escaped: String
escaped = easy.escape("a b")

# @type var mirror: Ethon::Easy::Mirror
mirror = easy.mirror
mirror.response_code
mirror.return_code
mirror.options[:total_time]

easy.reset
easy.http_request("http://localhost:3001/", :post, params: { a: 1 }, body: { b: "2" }, headers: { "X-Test" => "1" })
easy.file = StringIO.new
easy.file = nil
easy.perform

begin
  Ethon::Easy.new(unknown_option: 1)
rescue Ethon::Errors::InvalidOption => e
  e.message
end

options = { maxconnects: 10 }
multi = Ethon::Multi.new(options)
first = Ethon::Easy.new
first.http_request("http://localhost:3001/", :get)
# @type var handles: Array[Ethon::Easy]?
handles = multi.add(first)
multi.add(Ethon::Easy.new(url: "http://localhost:3001/"))
# @type var easy_handles: Array[Ethon::Easy]
easy_handles = multi.easy_handles
multi.perform
multi.delete(first)
# @type var ongoing: bool
ongoing = multi.ongoing?

part = Ethon::Multipart::Part.new('{"a":1}', content_type: "application/json")
# @type var upload: bool
upload = part.upload?
