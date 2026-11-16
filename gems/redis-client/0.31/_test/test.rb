require "redis-client"

module QueryCounter
  def call(command, config)
    yield command
  end

  def call_pipelined(commands, config)
    yield commands
  end
end

RedisClient.register(QueryCounter)
RedisClient.default_driver = :ruby
driver = RedisClient.default_driver
driver&.name
version = RedisClient::VERSION
version.upcase

# Configuration
config = RedisClient.config(url: "redis://localhost:6379/5", timeout: 0.5, reconnect_attempts: [0, 0.05, 0.1], protocol: 3)
config2 = RedisClient.config(
  host: "10.0.1.1",
  port: 6380,
  db: 15,
  username: "app",
  password: ->(username) { username.reverse },
  id: "worker",
  connect_timeout: 0.2,
  read_timeout: 1.0,
  write_timeout: 0.5,
  idle_timeout: 10,
  ssl: true,
  ssl_params: { ca_file: "ca.crt" },
  custom: { tags: { env: "test" } },
  middlewares: [QueryCounter],
  driver: :ruby,
  driver_info: ["sidekiq"],
  inherit_socket: false,
  reconnect_attempts: 2,
  circuit_breaker: { error_threshold: 3, error_timeout: 1 }
)
config3 = RedisClient.config(path: "/run/redis/foo.sock", password: "secret", circuit_breaker: RedisClient::CircuitBreaker.new(error_threshold: 3, error_timeout: 1, error_threshold_timeout: 2, success_threshold: 3))

db1 = config.db
db1.succ
id1 = config2.id
id1&.upcase
config.ssl.itself
config2.ssl?.itself
config2.ssl_params&.fetch(:ca_file)
config.command_builder.name
config.inherit_socket.itself
connect_timeout = config2.connect_timeout
connect_timeout&.round
read_timeout = config2.read_timeout
read_timeout&.round
write_timeout = config2.write_timeout
write_timeout&.round
idle_timeout = config2.idle_timeout
idle_timeout&.round
config.driver&.name
config.protocol.succ
config2.custom
breaker = config3.circuit_breaker
breaker&.error_threshold&.succ
breaker&.error_timeout&.round
breaker&.error_threshold_timeout&.round
breaker&.success_threshold&.succ
# @type var info: String | Array[String] | nil
info = config2.driver_info
info.nil?
config.username.upcase
config2.password&.upcase
config.server_url.upcase
config2.host&.upcase
config2.port&.succ
config3.path&.upcase
config2.server_key.compact
# @type var ssl_params: Hash[Symbol, untyped]?
ssl_params = config.ssl_params
ssl_params&.keys

# Clients
redis = config.new_client
redis_with_id = config.new_client(id: "main", connect_timeout: 0.1, read_timeout: 0.2, write_timeout: 0.3)
default_redis = RedisClient.new
url_redis = RedisClient.new(url: "redis://localhost", timeout: 1)
hash_redis = RedisClient.new({ host: "localhost" }, port: 6380)
config_redis = RedisClient.new(config, id: "x")
redis_options = { url: "redis://localhost:6379/0", reconnect_attempts: 1 }
splat_redis = RedisClient.new(**redis_options)

# @type var pong: String
pong = redis.call("PING")
pong.upcase
# @type var value: Integer
value = redis.call("GET", "counter", &:to_i)
value + 1
exists = redis.call("EXISTS", "counter") { |count| Integer(count) > 0 }
exists ? 1 : 0
redis.call("SET", "mykey", "value", nx: true, ex: 60)
redis.call("SET", "mykey", "value", nx: false, ex: nil)
redis.call("LPUSH", "list", [1, 2, 3], 4)
redis.call("HMSET", "hash", { "foo" => "1", "bar" => "2" })
redis.call("SET", "mykey", 1.23)
redis.call(:get, "mykey")
flags = { nx: true }
redis.call("SET", "mykey", "value", **flags)
values = redis.call_v(["MGET", "a", "b"] + ["c"]) { |list| Array(list).size }
values + 1
redis.call_once("INCR", "counter")
redis.call_once("INCR", "counter") { |count| String(count) }
redis.call_once_v(["INCR", "counter"])
redis.call_once_v(["INCR", "counter"]) { |count| String(count) }
# @type var popped: Array[String]?
popped = redis.blocking_call(1.5, "BRPOP", "queue", 0)
popped&.first
redis.blocking_call(false, "BRPOP", "queue", 0) { |item| String(item) }
redis.blocking_call(nil, "BRPOP", "queue", 0)
redis.blocking_call_v(1, ["BRPOP", "queue", 0])
redis.blocking_call_v(1, ["BRPOP", "queue", 0]) { |item| String(item) }

redis.scan("MATCH", "pattern:*") { |key| key.upcase }
redis.scan("MATCH", "pattern:*", count: 100).each { |key| key.upcase }
redis.sscan("myset", "MATCH", "pattern:*") { |member| member.upcase }
redis.sscan("myset").first
redis.hscan("myhash", "MATCH", "pattern:*") { |field, field_value| field.upcase + field_value }
redis.hscan("myhash").map { |pair| pair.first }
redis.zscan("myzset") { |member, score| member.upcase + score }
redis.zscan("myzset").map { |pair| pair.last }

results = redis.pipelined do |pipeline|
  pipeline.call("SET", "foo", "bar")
  pipeline.call("INCR", "baz") { |count| Integer(count) }
  pipeline.call_v(["GET", "foo"])
  pipeline.call_once("GET", "foo")
  pipeline.call_once_v(["GET", "foo"]) { |item| String(item) }
  pipeline.blocking_call(1, "BRPOP", "queue", 0)
  pipeline.blocking_call_v(1, ["BRPOP", "queue", 0]) { |item| String(item) }
end
results.size
lenient_results = redis.pipelined(exception: false) do |pipeline|
  pipeline.call("DOESNOTEXIST", 12)
end
lenient_results.each do |result|
  case result
  when RedisClient::CommandError
    result.message.upcase
  end
end

transaction_results = redis.multi do |transaction|
  transaction.call("SET", "foo", "bar")
  transaction.call("INCR", "baz") { |count| Integer(count) }
  transaction.call_v(["GET", "foo"])
  transaction.call_once("GET", "foo")
  transaction.call_once_v(["GET", "foo"])
end
transaction_results.size
watched_results = redis.multi(watch: ["title"]) do |transaction|
  title = redis.call("GET", "title")
  transaction.call("SET", "title", String(title).upcase)
end
watched_results&.size
redis.multi(watch: "title") { |transaction| transaction.call("INCR", "baz") }
redis.multi(watch: nil) { |transaction| transaction.call("INCR", "baz") }

pubsub = redis.pubsub
pubsub.call("SUBSCRIBE", "channel-1", "channel-2")
pubsub.call_v(["PING"])
# @type var event: Array[String]?
event = pubsub.next_event(0.5)
event&.first
event = pubsub.next_event
event&.first
pubsub.close.close

# Client attributes
redis.config.server_url.upcase
redis.id&.upcase
redis.server_url.upcase
redis.timeout&.round
redis.idle_timeout&.round
redis.db.succ
redis.host&.upcase
redis.port&.succ
redis.path&.upcase
redis.username.upcase
redis.password&.upcase
redis.size.succ
redis.inspect.upcase
redis.nodes.first&.close
redis.node_for("key").close
redis.nodes_for("key1", ["key2", "key3"]).each { |node, keys| node.call("DEL", *keys) }
redis.connect_timeout = 1
redis.read_timeout = 1.5
redis.write_timeout = nil
redis.timeout = 2
redis.connect_timeout&.round
redis.read_timeout&.round
redis.write_timeout&.round
redis.measure_round_trip_delay.round
connected = redis.connected?
connected.itself
# @type var used: String?
used = redis.with { |client| client.call("GET", "a") }
used&.upcase
redis.with(timeout: 1) { |client| client.call("GET", "a") }
redis.then { |client| client.call("GET", "a") }
redis.close.close

# Pools
pool = config.new_pool(timeout: 0.5, size: Integer(ENV.fetch("RAILS_MAX_THREADS", 5)))
pool2 = config2.new_pool(size: 3, auto_reload_after_fork: false, id: "pool", connect_timeout: 1, read_timeout: 1, write_timeout: 1)
pool.call("PING")
pool.call("GET", "counter", &:to_i)
pool.call_v(["PING"])
pool.call_once("PING")
pool.call_once_v(["PING"])
pool.blocking_call(1, "BRPOP", "queue", 0)
pool.blocking_call_v(1, ["BRPOP", "queue", 0])
pool.scan("MATCH", "a*") { |key| key.upcase }
pool.sscan("myset").first
pool.hscan("myhash") { |field, field_value| field.upcase + field_value }
pool.zscan("myzset").to_a
pool.pipelined { |pipeline| pipeline.call("SET", "foo", "bar") }.size
pool.multi { |transaction| transaction.call("SET", "foo", "bar") }.size
pool.multi(watch: ["foo"]) { |transaction| transaction.call("SET", "foo", "bar") }&.size
pool.pubsub.close
pool.with do |client|
  client.call("SET", "mykey", "hello world")
  client.call("GET", "mykey")
end
pool.with(timeout: 0.1) { |client| client.close }
pool.then { |client| client.size }
pool.size.succ
pool.config.server_url
pool.id&.upcase
pool.nodes.size
pool.node_for("a").size
pool.nodes_for("a", "b").size
pool.connect_timeout = 0.1
pool.read_timeout = 0.2
pool.write_timeout = 0.3
pool.timeout = 0.4
pool.connect_timeout&.round
pool.read_timeout&.round
pool.write_timeout&.round
pool.close
pool2.close

# Sentinel
sentinel_config = RedisClient.sentinel(
  name: "mymaster",
  sentinels: [{ host: "127.0.0.1", port: 26380 }, "redis://127.0.0.1:26381"],
  role: :replica,
  sentinel_username: "appuser",
  sentinel_password: "mysecret",
  password: "mysecret",
  reconnect_attempts: 3
)
url_sentinel_config = RedisClient.sentinel(url: "redis://appuser:mysecret@mymaster/10", sentinels: ["redis://127.0.0.1:26380"], role: "master", sentinel_password: ->(_username) { "pw" }, protocol: 2)
sentinel_config.name.upcase
sentinel_config.sentinels.map { |sentinel| sentinel.server_url }
sentinel_config.reset
sentinel_config.host&.upcase
sentinel_config.port&.succ
sentinel_config.path.nil?
sentinel_config.server_key.compact
sentinel_config.server_url.upcase
url_sentinel_config.new_client.close
sentinel_config.new_pool(size: 1).close

# Hash ring
ring = RedisClient.ring(
  config.new_pool(timeout: 0.5, size: 3),
  config2.new_pool(timeout: 0.5, size: 3),
  replicas: 100
)
ring_from_array = RedisClient.ring([redis, config2.new_client])
ring.node_for("cache_key").call("GET", "cache_key")
ring.nodes_for("key1", "key2", "key3").each { |node, keys| node.call("DEL", *keys) }
ring.nodes_for(["key1", "key2"]).size
ring.nodes.each { |node| node.close }
ring_from_array.nodes.size
direct_ring = RedisClient::HashRing.new([redis], replicas: 10)
direct_ring.nodes.size
RedisClient::HashRing.new.nodes.size

# Drivers
driver_class = RedisClient::RubyConnection
driver_class.name

# Errors
begin
  redis.call("PING")
rescue RedisClient::CircuitBreaker::OpenCircuitError, RedisClient::CannotConnectError => error
  error.message.upcase
rescue RedisClient::ReadTimeoutError, RedisClient::WriteTimeoutError, RedisClient::CheckoutTimeoutError => error
  error.retry_attempt.succ
rescue RedisClient::TimeoutError, RedisClient::FailoverError => error
  error.config&.server_url
rescue RedisClient::ReadOnlyError, RedisClient::MasterDownError => error
  error.command&.first
  error.code&.upcase
rescue RedisClient::ConnectionError, RedisClient::ProtocolError, RedisClient::UnsupportedServer => error
  error.final?.itself
rescue RedisClient::AuthenticationError, RedisClient::PermissionError, RedisClient::WrongTypeError,
       RedisClient::OutOfMemoryError, RedisClient::NoScriptError => error
  error.code&.upcase
rescue RedisClient::CommandError => error
  error.command&.first&.upcase
  error.code&.upcase
  error.retriable?.itself
  error.final?.itself
rescue RedisClient::Error => error
  error.next_error&.message
  error.retriable?.itself
end
