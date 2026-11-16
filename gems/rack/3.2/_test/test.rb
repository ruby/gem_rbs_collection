require "rack"

app = Rack::Builder.new do
  use Rack::ShowExceptions
  use Rack::Lint
  run { |_env| [200, { "content-type" => "text/plain" }, ["Hello"]] }
end.to_app

Rack::Builder.load_file("config.ru")

# Rack::Headers downcases keys
headers = Rack::Headers.new
headers["Content-Type"] = "text/plain"
headers["set-cookie"] = ["a=1", "b=2"]

response = Rack::Response.new(["Hello"], 200)
response.headers["x-frame-options"] = "DENY"
response.no_entity_body?
Rack::Utils.set_cookie_header("session", { value: "abc", path: "/", httponly: true }).length
Rack::Utils.delete_set_cookie_header("session").length
Rack::Utils.default_query_parser.bytesize_limit.zero?
Rack::Utils.multipart_total_part_limit.zero?
Rack::Request.forwarded_priority.first

request = Rack::Request.new(Rack::MockRequest.env_for("/?a=1"))
request.ip&.length
request.form_pairs.size

mock_response = Rack::MockRequest.new(app).get("/")
mock_response.cookie("session")&.value&.first

Rack::QueryParser.make_default(32, bytesize_limit: 1024).parse_nested_query("a=1")

begin
  Rack::Utils.parse_nested_query("a[]=1&a[b]=2")
rescue Rack::BadRequest => e
  e.message
end

Rack::Builder.new do
  use Rack::RewindableInput::Middleware
  run app
end
