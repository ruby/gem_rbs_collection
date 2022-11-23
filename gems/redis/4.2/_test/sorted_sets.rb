redis = Redis.new

redis.zcard(:sample_key)
redis.zadd(:sample_key, 1, 'hello world')
redis.zadd("string key", 1, 'hello world', nx: true)
redis.zadd("string key", 2, 'hello world', xx: true)
redis.zadd("string key", 3, 'hello world', ch: true)
redis.zadd("string key", 4, 'hello world', incr: true)
redis.zadd(:foo, [2, "s1", 3, "s2", 4, "s3"], xx: true)
redis.zincrby(:foo, 1,  "bar")
redis.zincrby(:foo, 1.0,  "bar")
redis.zincrby(:foo, "-inf",  "bar")
redis.zincrby(:foo, "+inf",  "bar")
redis.zrem(:foo,  "bar")
