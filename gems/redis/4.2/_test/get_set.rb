redis = Redis.new

redis.set("mykey", "hello world")
# => "OK"

redis.get("mykey")
# => "hello world"

redis.set(:other_key, 'hello world')
# => "OK"

redis.get(:other_key)
# => "hello world"
