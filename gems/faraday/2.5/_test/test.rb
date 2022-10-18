# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "faraday"

Faraday::VERSION
Faraday.default_adapter

conn = Faraday.new('http://example.com/test1')
conn.headers
response = conn.get('/get', { param: '1' }, { 'Content-Type' => 'application/json' }) do |req|
  req.path = "/new_get"
  req.path = URI("https://example.com/new_get?abc=m")
  req.url("/new_url")
  req.url("/new_url", { x_foo: "OK" })
  req.url(URI("https://example.com/new_url?abc=foo"))
  req.url(URI("https://example.com/new_url?abc=bar"), { x_bar: "OK" })
end
response.status
response.headers
response.body
response.success?

conn.head(URI("https://example.com/head")) { |req| req[:x_csrf_token] }
response = conn.head('/head')
response.status
response.headers
response.body
response.success?

conn.delete(URI("https://example.com/delete")) { |req| req[:authorization] }
response = conn.delete('/delete')
response.status
response.headers
response.body
response.success?

conn.trace(URI("https://example.com/trace")) { |req| req[:content_type] }
response = conn.trace('/trace')
response.status
response.headers
response.body
response.success?

conn = Faraday.new(
  url: 'http://example.com/test2',
  headers: { 'Content-Type' => 'application/json' }
)
conn.post(URI("http://example.com/post"))
response = conn.post('/post') do |req|
  req.body = "{ query: 'chunky bacon' }"
end
response.status
response.headers
response.body
response.success?

conn.put(URI("http://example.com/put"))
response = conn.put('/put') do |req|
  req.body = "{ query: 'chunky bacon' }"
end
response.status
response.headers
response.body
response.success?

conn.patch(URI("https://example.com/patch"))
response = conn.patch('/patch') do |req|
  req.body = "{ query: 'chunky bacon' }"
end
response.status
response.headers
response.body
response.success?
