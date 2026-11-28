require "typhoeus"

Typhoeus.configure do |config|
  config.verbose = false
  config.timeout = 5
  config.connecttimeout = 1.5
  config.memoize = true
  config.block_connection = true
  config.user_agent = "test"
  config.exclude_features = [:before]
  config.max_idle_easies = nil
end
Typhoeus::Config.max_idle_multis = 2
Typhoeus::Config.proxy = nil
# @type var timeout: Integer | Float | nil
timeout = Typhoeus::Config.timeout

# @type var expectation: Typhoeus::Expectation
expectation = Typhoeus.stub("http://example.com/", method: :get)
expectation.and_return(Typhoeus::Response.new(code: 200, body: "ok", headers: { "Content-Type" => "text/plain" }))
Typhoeus.stub(/example\.org/).and_return([Typhoeus::Response.new(code: 404), Typhoeus::Response.new(code: 500)])
Typhoeus.stub(URI("http://example.net/")) { |request| Typhoeus::Response.new(code: 201, body: request.url) }
# @type var count: Integer
count = expectation.response_counter
# @type var expectations: Array[Typhoeus::Expectation]
expectations = Typhoeus::Expectation.all

# @type var response: Typhoeus::Response?
response = Typhoeus.get("http://example.com/", params: { q: "x" }, headers: { Accept: "text/html" })
Typhoeus.post("http://example.com/", body: { a: 1 })
Typhoeus.put("http://example.com/", body: "data")
Typhoeus.delete("http://example.com/")
Typhoeus.head("http://example.com/")
Typhoeus.patch("http://example.com/", body: "data")
Typhoeus.options("http://example.com/")

if response
  # @type var code: Integer
  code = response.code
  # @type var body: String?
  body = response.body
  # @type var success: bool
  success = response.success?
  response.failure?
  response.timed_out?
  response.modified?
  response.cached?
  # @type var return_code: Symbol?
  return_code = response.return_code
  response.return_message
  response.status_message
  response.http_version
  # @type var total_time: Float?
  total_time = response.total_time
  response.effective_url
  response.redirections.each { |redirect| redirect.code }
  # @type var headers: Typhoeus::Response::Header?
  headers = response.headers
  if headers
    # @type var content_type: String | Array[String] | nil
    content_type = headers["content-type"]
    headers.key?(:content_type)
    headers.fetch("Content-Type", "none")
    headers.to_h.each_key(&:downcase)
  end
  response.request&.base_url
end

# @type var request: Typhoeus::Request
request = Typhoeus::Request.new("http://example.com/", method: :post, body: { a: 1 }, followlocation: true)
request.on_complete { |res| res.code }
request.on_success { |res| res.body }
request.on_failure { |res| res.return_code }
request.on_headers { |res| res.headers }
request.on_progress { |dltotal, dlnow, _ultotal, _ulnow| dlnow * 100 / [dltotal, 1].max }
request.on_body { |chunk, _res| chunk.to_s.bytesize }
request.before { |req| req.options[:timeout] = 1 }
Typhoeus.on_complete { |res| res.code }
Typhoeus.before { |req| req.url }
# @type var url: String
url = request.url
# @type var key: String
key = request.cache_key
request.cache_ttl
request.streaming?
request.memoizable?
request.blocked?
request.cacheable?
# @type var run_response: Typhoeus::Response?
run_response = request.run
request.response&.code

# @type var hydra: Typhoeus::Hydra
hydra = Typhoeus::Hydra.new(max_concurrency: 10)
Typhoeus::Hydra.new({ max_concurrency: "5" })
hydra.queue(Typhoeus::Request.new("http://example.com/"))
hydra.queue_front(Typhoeus::Request.new("http://example.org/"))
# @type var queued: Array[Typhoeus::Request]
queued = hydra.queued_requests
hydra.run
hydra.release
# @type var concurrency: Integer
concurrency = Typhoeus::Hydra.hydra.max_concurrency

# @type var result: String
result = Typhoeus.with_connection { "done" }

class MemoryCache
  def initialize
    @store = {}
  end

  def get(request)
    @store[request.cache_key]
  end

  def set(request, response)
    @store[request.cache_key] = response
  end
end

Typhoeus::Config.cache = MemoryCache.new
Typhoeus::Config.cache = false
Typhoeus::Request.new("http://example.com/", cache: MemoryCache.new, cache_ttl: 60).cacheable?
Typhoeus::Expectation.clear

begin
  Typhoeus.get("http://example.com/")
rescue Typhoeus::Errors::NoStub => e
  e.message
end
