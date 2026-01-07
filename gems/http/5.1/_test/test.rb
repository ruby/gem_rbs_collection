require "http"

# Test HTTP::Response initialization and methods
response = HTTP::Response.new(
  status: 200,
  version: "1.1",
  body: "Hello world!",
)

response.code == 200
response.reason
response.flush
response.to_s
response.to_str

# Test HTTP module singleton methods (verb methods)
HTTP.get("https://example.com")
HTTP.head("https://example.com")
HTTP.post("https://example.com", { json: { key: "value" } })
HTTP.put("https://example.com", { json: { key: "value" } })
HTTP.patch("https://example.com", { json: { key: "value" } })
HTTP.delete("https://example.com")
HTTP.options("https://example.com")
HTTP.trace("https://example.com")
HTTP.connect("https://example.com")

# Test HTTP module singleton chainable methods
HTTP.headers({"Accept" => "application/json"}).get("https://example.com")
HTTP["Accept" => "application/json"].get("https://example.com")
HTTP.basic_auth(user: "username", pass: "password").get("https://example.com")
HTTP.auth("Bearer token").get("https://example.com")
HTTP.cookies(session: "value").get("https://example.com")
HTTP.follow.get("https://example.com")
HTTP.follow(max_hops: 3).get("https://example.com")
HTTP.timeout(5).get("https://example.com")
HTTP.timeout(connect: 2, read: 5, write: 2).get("https://example.com")
HTTP.via("proxy.example.com", 8080).get("https://example.com")
HTTP.via("proxy.example.com", 8080, "user", "pass").get("https://example.com")
HTTP.use(:auto_inflate).get("https://example.com")

# Test HTTP.persistent
client = HTTP.persistent("https://example.com")
client.get("/path1")
client.get("/path2")
client.close

# Test HTTP.persistent with block
HTTP.persistent("https://example.com") do |http|
  http.get("/path1")
  http.get("/path2")
end

# Test HTTP::Client methods
client = HTTP::Client.new
client.get("https://example.com")
client.head("https://example.com")
client.post("https://example.com", { json: { key: "value" } })
client.put("https://example.com", { json: { key: "value" } })
client.patch("https://example.com", { json: { key: "value" } })
client.delete("https://example.com")
client.options("https://example.com")
client.trace("https://example.com")
client.connect("https://example.com")

# Test HTTP::Client chainable methods
client.headers({"Accept" => "application/json"})
client["Accept" => "application/json"]
client.basic_auth(user: "username", pass: "password")
client.auth("Bearer token")
client.cookies(session: "value")
client.follow
client.follow(max_hops: 3)
client.timeout(5)
client.timeout(connect: 2, read: 5, write: 2)
client.via("proxy.example.com", 8080)
client.via("proxy.example.com", 8080, "user", "pass")
client.use(:auto_inflate)
client.persistent?

# Test chaining
HTTP.headers("Accept" => "application/json")
    .basic_auth(user: "user", pass: "pass")
    .timeout(5)
    .follow
    .get("https://example.com")
