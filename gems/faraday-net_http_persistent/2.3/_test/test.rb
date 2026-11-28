require "faraday"
require "faraday/net_http_persistent"

adapter = Faraday::Adapter::NetHttpPersistent.new
Faraday::Adapter::NetHttpPersistent.new(nil, { name: "my-app", pool_size: 5 }) do |_http|
  nil
end
adapter.close

# @type var exceptions: Array[singleton(StandardError)]
exceptions = Faraday::Adapter::NetHttpPersistent::NET_HTTP_EXCEPTIONS

# @type var version: String
version = Faraday::NetHttpPersistent::VERSION

conn = Faraday.new("http://example.com") do |c|
  c.adapter :net_http_persistent, pool_size: 5
end
# @type var response: Faraday::Response
response = conn.get("/")

# @type method perform: (Faraday::Env env) -> Faraday::Response
def perform(env)
  # @type var result: Faraday::Response
  result = Faraday::Adapter::NetHttpPersistent.new.call(env)
  result
end
