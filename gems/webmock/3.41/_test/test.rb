require "uri"
require "webmock"
require "webmock/rspec/matchers"

WebMock::VERSION + WebMock.version

WebMock.enable!
WebMock.enable! except: 'hello'
WebMock.enable! except: ['hello', 'world']

WebMock.disable!
WebMock.disable! except: 'hello'
WebMock.disable! except: ['hello', 'world']

WebMock.disable_net_connect!(allow_localhost: true, allow: ["example.com", /example\.org/, ->(uri) { uri.host == "example.net" }])
WebMock.disable_net_connect!(net_http_connect_on_start: true)
WebMock.disallow_net_connect!({ allow: "example.com" })
# @type var allowed: Integer
allowed = WebMock.allow_net_connect! { 1 }
WebMock.enable_net_connect!
# @type var connect_allowed: boolish
connect_allowed = WebMock.net_connect_allowed?("http://localhost/")
WebMock.net_connect_allowed_by_settings?(Addressable::URI.parse("http://localhost/"))

WebMock.show_body_diff!
WebMock.hide_body_diff!
# @type var show_body_diff: bool
show_body_diff = WebMock.show_body_diff?
WebMock.show_stubbing_instructions!
WebMock.hide_stubbing_instructions!
# @type var show_stubbing_instructions: bool
show_stubbing_instructions = WebMock.show_stubbing_instructions?

WebMock.after_request(except: [:net_http]) do |request_signature, response|
  # @type var after_uri: Addressable::URI
  after_uri = request_signature.uri
  # @type var after_status: untyped
  after_status = response.status
end
WebMock.globally_stub_request { |request| { body: "global" } if request.uri.host == "example.com" }
WebMock.globally_stub_request(:after_local_stubs) { |_request| nil }

# @type var config: WebMock::Config
config = WebMock::Config.instance
# @type var query_values_notation: Symbol?
query_values_notation = config.query_values_notation
config.allow = ["example.com", /example\.org/]

class RackApp
  def self.call(env)
    [200, { "Content-Type" => "text/plain" }, ["rack"]]
  end
end

class WebMockAPITest
  include WebMock::API

  def test_stub_request
    stub = stub_request(:get, "https://example.com/")
      .with(query: { "a" => "1" }, headers: { "Accept" => "application/json" })
      .to_return(status: 200, body: "ok", headers: { "Content-Type" => "text/plain" })
      .then
      .to_return({ status: 500 }, { status: 404 })
      .times(2)
      .then
      .to_raise(StandardError)
      .then
      .to_timeout
    stub.to_return { |request| { body: request.uri.to_s } }
    stub.and_return_json(body: { "ok" => true })
    stub.request_pattern.with { |request| request.method == :get }

    stub_http_request(:post, %r{example\.com}).with(body: "x") { |request| "x" == request.body }
    stub_request(:any, Addressable::Template.new("https://example.com/{id}")).and_raise("boom")

    assert_requested(:get, "https://example.com/", times: 1)
    assert_requested(:get, "https://example.com/") { |request| request.headers.nil? }
    assert_requested(stub, at_least_times: 1)
    assert_not_requested(:delete, "https://example.com/")
    refute_requested(stub)
    a_request(:get, "https://example.com/").with(query: { "a" => "1" })

    remove_request_stub(stub)
    reset_executed_requests!
  end

  def test_typed_values
    # @type var stub: WebMock::RequestStub
    stub = stub_request("GET", URI("https://example.com/"))
    stub.to_return(lambda { |request| { body: request.uri.to_s } }, "HTTP/1.1 200 OK\r\n\r\nraw")
    stub.to_rack(RackApp)

    # @type var response: WebMock::Response
    response = stub.response
    # @type var exception: Exception?
    exception = response.exception
    # @type var should_timeout: bool
    should_timeout = response.should_timeout

    # @type var pattern: WebMock::RequestPattern
    pattern = a_request(:get, ->(uri) { uri.path == "/" })
    # @type var signature: WebMock::RequestSignature
    signature = WebMock::RequestSignature.new(:get, "https://example.com/", headers: { "Accept" => "a" })
    # @type var headers: Hash[String, String | Array[String]]?
    headers = signature.headers
    # @type var content_type: String?
    content_type = signature.content_type
    # @type var matched: boolish
    matched = pattern.matches?(signature)
    # @type var registered: WebMock::RequestStub?
    registered = WebMock.registered_request?(signature)

    # @type var requests: Array[WebMock::RequestSignature]
    requests = executed_requests
    hash_including(:a, b: "1")
    hash_excluding("c")
  end
end

class WebMockMatchersTest
  include WebMock::API
  include WebMock::Matchers

  def test_matchers
    # @type var matcher: WebMock::RequestPatternMatcher
    matcher = have_been_made.once.with(body: "x")
    # @type var made: bool
    made = matcher.matches?(a_request(:get, "https://example.com/"))
    # @type var message: String
    message = matcher.failure_message
    # @type var requested: WebMock::WebMockMatcher
    requested = have_requested(:get, "https://example.com/").twice
    have_not_requested(:get, "https://example.com/")
    have_not_been_made
  end
end

WebMock.stub_request(:get, "https://example.com/").to_return(body: "ok")
WebMock.reset!
WebMock.reset_callbacks
