# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "faraday_middleware"

class MemoryCache
  def initialize
    @store = {} #: Hash[String, Faraday::Response]
  end

  def read(key)
    @store[key]
  end

  def write(key, response, options = nil)
    @store[key] = response
  end
end

Faraday.new(url: "https://example.com") do |conn|
  conn.request :oauth2, "TOKEN", token_type: "bearer"
  conn.request :method_override, rewrite: [:put, :delete]
  conn.response :mashify
  conn.response :xml, content_type: /\bxml$/
  conn.use FaradayMiddleware::FollowRedirects, limit: 5
  conn.use FaradayMiddleware::Caching, MemoryCache.new, ignore_params: %w[t]
  conn.use FaradayMiddleware::Gzip
  conn.adapter :net_http
end

app = ->(env) { env }

FaradayMiddleware::ParseJson.new(app, content_type: /json/, preserve_raw: true)
FaradayMiddleware::ParseJson.new(app, { content_type: "application/json" })
FaradayMiddleware::ParseJson::MimeTypeFix.new(app)
FaradayMiddleware::ParseXml.new(app, parser_options: { symbolize_keys: true })
FaradayMiddleware::ParseYaml.new
FaradayMiddleware::ParseMarshal.new(app)
FaradayMiddleware::Chunked.new(app)
FaradayMiddleware::ParseDates.new(app, match: /\A\d{4}/)
FaradayMiddleware::Mashify.new(app, mash_class: Hash)
FaradayMiddleware::Rashify.new(app)
FaradayMiddleware::EncodeJson.new(app)
FaradayMiddleware::MethodOverride.new(app)
FaradayMiddleware::MethodOverride.new(app, rewrite: %w[PUT])
FaradayMiddleware::OAuth.new(app, consumer_key: "key", consumer_secret: "secret")
oauth2 = FaradayMiddleware::OAuth2.new(app, "abc123", param_name: "my_token", token_type: "param")
oauth2.param_name.upcase
oauth2.token_type.upcase
FaradayMiddleware::OAuth2.new(app, param_name: "my_token")
FaradayMiddleware::FollowRedirects.new(app, standards_compliant: true, callback: ->(old_env, new_env) { new_env.url })
FaradayMiddleware::Instrumentation.new(app, name: "request.api")
FaradayMiddleware::RackCompatible.new(app, Object)
caching = FaradayMiddleware::Caching.new(app, status_codes: [200]) { MemoryCache.new }
caching.cache.read("key")

class UpcaseParser < FaradayMiddleware::ResponseMiddleware
  define_parser do |body, _parser_options|
    String(body).upcase
  end
end

FaradayMiddleware::ResponseMiddleware.define_parser(->(body, _options) { body })
FaradayMiddleware::ResponseMiddleware.parser&.call("body", nil)

FaradayMiddleware::Gzip.supported_encodings.join(",")
FaradayMiddleware::Gzip.optional_dependency("brotli")
FaradayMiddleware::Gzip.optional_dependency { true }

Faraday::Response::ParseJson.new(app)
Faraday::Request::OAuth2.new(app, "token")
