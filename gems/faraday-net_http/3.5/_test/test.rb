# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "faraday"
require "faraday/net_http"

adapter = Faraday::Adapter::NetHttp.new
Faraday::Adapter::NetHttp.new(nil, {}) { |http| http.open_timeout = 5 }

http = adapter.build_connection({ url: URI("https://example.com"), request: {}, ssl: Faraday::SSLOptions.new })
http.use_ssl?
adapter.net_http_connection({ url: URI("http://example.com"), request: {} }).port

Faraday::Adapter::NetHttp::NET_HTTP_EXCEPTIONS.include?(IOError)
Faraday::NetHttp::VERSION.split(".")

conn = Faraday.new("http://example.com") { |c| c.adapter :net_http }
conn.get("/")
