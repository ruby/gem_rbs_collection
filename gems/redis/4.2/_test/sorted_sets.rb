redis = Redis.new

redis.zcard(:sample_key)
redis.zadd(:sample_key, 1, 'hello world')
redis.zincrby(:foo, 1,  "bar")
redis.zrem(:foo,  "bar")
