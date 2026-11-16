require "redis-namespace"

# These calls connect to Redis, so they are type checked but never run.
# @type var use_namespace: ^() -> void
use_namespace = -> do
  redis_connection = Redis.new
  namespaced_redis = Redis::Namespace.new(:ns, redis: redis_connection)

  set_result = namespaced_redis.set("foo", "bar")
  set_result == "OK"

  value = namespaced_redis.get("foo")
  value&.upcase

  namespaced_redis.set("count", 1, ex: 60, nx: true)
  namespaced_redis.set("count", 1, px: 500, xx: false, keepttl: true)

  deleted = namespaced_redis.del("foo")
  deleted + 1
  namespaced_redis.del("a", "b")
  namespaced_redis.del(["a", "b"])

  Redis::Namespace.new(Proc.new { "tenant" }, redis: redis_connection)
  Redis::Namespace.new(-> { :tenant }, redis: redis_connection, warning: true, deprecations: false)
  Redis::Namespace.new("plain")
  Redis::Namespace.new("hash_options", { redis: redis_connection, warning: false })

  ns = Redis::Namespace.new("alfred", warning: true)

  ns.namespace.to_s
  ns.namespace = "other"
  ns.namespace = -> { "dynamic" }
  ns.namespace = Proc.new { "dynamic" }
  ns.namespace(:inner) do |inner|
    inner.get("key")
  end
  ns.namespace("inner") { |inner| inner.incr("n") + 1 }

  ns.redis
  ns.warning = false
  ns.warning ? 1 : 0

  ns.full_namespace.upcase

  info = ns.connection
  info[:namespace]

  ns.multi do |multi|
    multi.set("a", 1)
    multi.incr("b")
  end
  exec_result = ns.exec
  exec_result&.size
  ns.pipelined do |pipeline|
    pipeline.set("a", 1)
  end.size

  ns.setex("key", 10, "value").upcase
  ns.exists("a", "b") + 1
  ns.keys.map(&:upcase)
  ns.keys("prefix*").first
  ns.keys(nil).size

  ns.expire("key", 30) ? 1 : 0
  ns.ttl("key") + 1

  ns.mget("a", "b").compact.size
  ns.mset("a", 1, "b", 2).upcase

  ns.incr("n") + 1
  ns.incrby("n", 5) + 1
  ns.decr("n") + 1
  ns.decrby("n", 5) + 1

  # @type var script_result: Array[untyped]
  script_result = ns.eval("return 1", ["key"], ["arg", 1])
  script_result.size
  ns.eval("return 1", keys: ["key"], argv: ["arg"])
  ns.eval("return 1")
  ns.evalsha("sha", ["key"], ["arg"])
  ns.evalsha("sha", keys: ["key"], argv: ["arg"])
  ns.evalsha("sha")

  ns.hget("h", "field")&.upcase
  ns.hset("h", "field", "value") + 1
  ns.hset("h", { "a" => 1, "b" => 2 }) + 1
  ns.hdel("h", "a", "b") + 1
  ns.hexists("h", "a") ? 1 : 0
  ns.hgetall("h").keys.first
  ns.hkeys("h").first
  ns.hvals("h").first
  ns.hlen("h") + 1
  ns.hincrby("h", "a", 2) + 1

  ns.lpush("l", "a") + 1
  ns.lpush("l", ["a", "b"]) + 1
  ns.rpush("l", "a") + 1
  ns.rpush("l", ["a", "b"]) + 1
  ns.lpop("l")&.upcase
  ns.rpop("l")&.upcase
  ns.llen("l") + 1
  ns.lrange("l", 0, -1).first

  # @type var added: Integer | bool
  added = ns.sadd("s", "a")
  added.is_a?(Integer)
  ns.sadd("s", ["a", "b"]) + 1
  # @type var removed: Integer | bool
  removed = ns.srem("s", "a")
  removed.is_a?(Integer)
  ns.srem("s", ["a", "b"]) + 1
  ns.sismember("s", "a") ? 1 : 0
  ns.smembers("s").first
  ns.scard("s") + 1

  zadd_result = ns.zadd("z", 1, "a", nx: true)
  zadd_result == 1
  ns.zadd("z", [[1, "a"], [2, "b"]], ch: true, incr: false)
  ns.zadd("z", 1, "a", xx: true)
  ns.zcard("z") + 1
  zscore = ns.zscore("z", "a")
  zscore&.round
  ns.zrem("z", "a") ? 1 : 0
  ns.zrem("z", ["a", "b"]) + 1
  ns.zrange("z", 0, -1, with_scores: true).size
end

Redis::Namespace::VERSION.upcase
