redis = Redis.new

redis.set("mykey", "hello world")
# => "OK"

redis.get("mykey")
# => "hello world"

Redis.current.set(:mykey, 'hello world')

Redis.current.get(:mykey)
