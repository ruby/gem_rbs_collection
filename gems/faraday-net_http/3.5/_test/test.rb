require "faraday"
require "faraday/net_http"

adapter = Faraday::Adapter::NetHttp.new
Faraday::Adapter::NetHttp.new(nil, {}) { |http| http.open_timeout = 5 }

# @type var http: Net::HTTP
http = adapter.build_connection({ url: URI("https://example.com"), request: {}, ssl: Faraday::SSLOptions.new })
http = adapter.net_http_connection({ url: URI("http://example.com"), request: {} })

# @type var exceptions: Array[singleton(StandardError)]
exceptions = Faraday::Adapter::NetHttp::NET_HTTP_EXCEPTIONS

# @type var version: String
version = Faraday::NetHttp::VERSION

conn = Faraday.new("http://example.com") { |c| c.adapter :net_http }
conn.get("/")
