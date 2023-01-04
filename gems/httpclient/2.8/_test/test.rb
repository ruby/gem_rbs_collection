require "httpclient"

HTTPClient.get("http://example.com").body

client = HTTPClient.new
if false
  client.set_auth("http://example.com", "user", "pass")
end
res = client.get("http://example.com", query: {"q" => "v"})
if res.status == 200
  puts res.body
end
resnil = client.get("http://example.com") { |chunk| chunk.gsub(//) }
unless resnil.body
  puts 'ok'
end
conn = client.post_async("http://example.com", body: { "name" => "ksss" }, header: { "Token" => "Yo" })
puts conn.pop.body.read
