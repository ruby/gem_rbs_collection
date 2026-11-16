require "webmock"

WebMock::VERSION + WebMock.version

WebMock.enable!
WebMock.enable! except: 'hello'
WebMock.enable! except: ['hello', 'world']

WebMock.disable!
WebMock.disable! except: 'hello'
WebMock.disable! except: ['hello', 'world']

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

    stub_http_request(:post, %r{example\.com}).with(body: "x") { |request| request.body == "x" }
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
end

WebMock.stub_request(:get, "https://example.com/").to_return(body: "ok")
