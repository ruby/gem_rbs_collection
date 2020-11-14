redis = Redis.new

# @type ivar @set: Redis::Future[String]
# @type ivar @incr: Redis::Future[Integer]

redis.pipelined do |redis|
  @set = redis.set "foo", "bar"
  @incr = redis.incr "baz"
end
# => ["OK", 1]

@set.value
# => "OK"

@incr.value
# => 1
