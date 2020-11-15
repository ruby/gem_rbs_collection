redis = Redis.new

redis.multi do
  redis.set "foo", "bar"
  redis.incr "baz"
end
# => ["OK", 1]
