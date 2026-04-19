redis = Redis.new

redis.with do |conn|
  conn.set "foo", "bar"
end
# => "OK"
