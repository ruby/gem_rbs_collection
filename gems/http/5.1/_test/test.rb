require "http"

response = HTTP::Response.new(
  status: 200,
  version: "1.1",
  body: "Hello world!",
)

response.code == 200
