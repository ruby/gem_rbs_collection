# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "http"

response = HTTP::Response.new(
  status: 200,
  version: "1.1",
  body: "Hello world!",
)
