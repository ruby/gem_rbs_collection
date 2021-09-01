require "httpclient"

client = HTTPClient.new
res = client.get("http://example.com")
if res.status == 200
  puts res.body
end
resnil = client.get("http://example.com") { |chunk| chunk.gsub(//) }
unless resnil.body
  puts 'ok'
end
conn = client.post_async("http://example.com", body: { "name" => "ksss" }, header: { "Token" => "Yo" })
puts conn.pop.body.read
