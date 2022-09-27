# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "faraday"

Faraday.default_adapter

conn = Faraday.new(
  url: 'http://example.com/test1',
)
conn.headers
response = conn.get('/get', { param: '1' }, { 'Content-Type' => 'application/json' })
response.status
response.headers
response.body
response.success?

response = conn.head('/head')
response.status
response.headers
response.body
response.success?

response = conn.delete('/delete')
response.status
response.headers
response.body
response.success?

response = conn.trace('/trace')
response.status
response.headers
response.body
response.success?

conn = Faraday.new(
  url: 'http://example.com/test2',
  headers: { 'Content-Type' => 'application/json' }
)
response = conn.post('/post') do |req|
  req.body = "{ query: 'chunky bacon' }"
end
response.status
response.headers
response.body
response.success?

response = conn.put('/put') do |req|
  req.body = "{ query: 'chunky bacon' }"
end
response.status
response.headers
response.body
response.success?

response = conn.patch('/patch') do |req|
  req.body = "{ query: 'chunky bacon' }"
end
response.status
response.headers
response.body
response.success?
