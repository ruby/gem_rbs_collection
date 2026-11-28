require "faraday"
require "faraday/excon"

adapter = Faraday::Adapter::Excon.new(nil, { persistent: true })

# @type var connection: Excon::Connection
connection = adapter.build_connection({ url: URI("https://example.com/path?q=1"), request: {}, ssl: Faraday::SSLOptions.new })

# @type var version: String
version = Faraday::Excon::VERSION

Faraday.new("http://example.com") { |c| c.adapter :excon }

# Faraday::Env has no constructor in the faraday RBS, so the adapter's
# env-taking methods are called from a helper (see test.rbs).
class ExconAdapterUser
  def initialize(adapter)
    @adapter = adapter
  end

  def run(env)
    # @type var body: String?
    body = @adapter.read_body(env)
    # @type var response: Faraday::Response
    response = @adapter.call(env)
    response
  end
end
