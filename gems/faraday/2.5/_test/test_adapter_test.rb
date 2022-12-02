test = Faraday::Adapter::Test.new(Object.new) do |stubs|
  stubs.empty?
  stub, meta = stubs.match(Object.new)
  if stub && meta
    meta[:match_data]
  end

  stubs.get "/abc" do
    [200, { "Content-Type" => "text/plain" }, "Hi"]
  end
  stubs.get /foo/, { x_test: "true" } do |env, meta|
    meta.key?(:match_data) && env # TODO: Call a method of `Faraday::Env`
    [200, { content_type: "text/plain" }, "Hi"]
  end
  stubs.head(/abc/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.head("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.head("/example", { x_foo: "true", "ok" => 234 }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.post("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.post(/pp/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.post(URI("https://example.com")) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.post("/path", nil) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.post("/path", "body") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.post("/path", ->(s) { true }) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.post("/path", nil, { x_foo: "true", "ok" => "1" }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.put("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put(/pp/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put(URI("https://example.com")) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", nil) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", "body") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", ->(s) { true }) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", nil, { x_foo: "true", "ok" => "1" }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.patch("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.patch(/pp/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.patch(URI("https://example.com")) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.patch("/path", nil) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.patch("/path", "body") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.patch("/path", ->(s) { true }) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.patch("/path", nil, { x_foo: "true", "ok" => "1" }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.put("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put(/pp/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put(URI("https://example.com")) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", nil) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", "body") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", ->(s) { true }) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.put("/path", nil, { x_foo: "true", "ok" => "1" }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.delete(/abc/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.delete("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.delete("/example", { x_foo: "true", "ok" => 234 }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.options(/abc/) { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.options("/path") { [200, { content_type: "text/plain" }, "Hi"] }
  stubs.options("/example", { x_foo: "true", "ok" => 234 }) { [200, { content_type: "text/plain" }, "Hi"] }

  stubs.verify_stubbed_calls
  stubs.strict_mode = nil
  stubs.strict_mode = false
  stubs.strict_mode = true

  stubs.send(:new_stub, :get, "/path", { x_a: "a" }, nil) { [204, { x: 3 }, ""] }
  stubs.send(:matches?, {}, Object.new)
end
test.call(Object.new)

stub = Faraday::Adapter::Test::Stub.new("example.com", "/path", "a=234", Faraday::Utils::Headers.new, "body", false, -> () { true })
result, meta = stub.matches?(Object.new)
if result
  meta.key?(:match_data)
end

stub.host = "ok"; stub.host&.to_str
stub.path = "ok"; stub.path&.to_str
stub.query = "ok"; stub.query&.to_str
stub.headers = Faraday::Utils::Headers.new; stub.headers&.to_hash
stub.body = "body"; stub.body&.to_str
stub.strict_mode = true; stub.strict_mode
stub.block = -> { true }; stub.block
stub.path_match?("/request_path", {})
stub.params_match?(Object.new) ? :ok : :bad
stub.headers_match?({ x_b: "ok" }) ? :ok : :bad
stub.body_match?("request body") ? :ok : :bad
stub.to_s
