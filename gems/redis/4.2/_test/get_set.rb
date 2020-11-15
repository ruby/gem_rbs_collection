redis = Redis.new

redis.set("mykey", "hello world")
# => "OK"

redis.get("mykey")
# => "hello world"
