require "dalli"

client = Dalli::Client.new("localhost:11211", namespace: "app", expires_in: 300, compress: true)
Dalli::Client.new(["localhost:11211", "cache-2:11211:5"], { failover: false })
Dalli::Client.new

# @type var stored: Integer | false | nil
stored = client.set("key", { a: 1 }, 60)
stored = client.set(:key, "value", 60, raw: true)
stored = client.add(42, "value")
stored = client.replace("key", "value", 3.5)
stored = client.set_cas("key", "value", 123)
stored = client.replace_cas("key", "value", "123", nil, { p_token: "p" })

value = client.get("key")
value = client.get("key", raw: true)
value = client.get("key", false)
value = client.gat("key", 120)

# @type var touched: true?
touched = client.touch("key", 60)

# @type var value_and_cas: [untyped, Integer]
value_and_cas = client.get_cas("key")
# @type var cas_from_block: Integer
cas_from_block = client.get_cas("key") { |_value, cas| cas }

# @type var metadata: Hash[Symbol, untyped]
metadata = client.get_with_metadata("key", return_hit_status: true, return_ttl_remaining: true)
metadata = client.get_with_metadata("key")
client.get_with_metadata("key")[:miss]

# @type var result: Dalli::CacheResult
result = client.get_with_metadata_result("key")
result.hit? && result.miss? && result.stale? && result.won_recache? && result.lost_recache?
# @type var result_cas: Integer?
result_cas = result.cas
result.value
result.hit_before
result.last_access
result.ttl_remaining
Dalli::CacheResult.new({ value: "v", cas: 1, miss: false })

# @type var values: Hash[String, untyped]
values = client.get_multi("a", "b")
values = client.get_multi(%w[a b], req_options: { raw: true })
values = client.get_multi([1, 2], :c, nil)
client.get_multi("a", "b") { |key, val| values[key.upcase] = val }

# @type var with_cas: Hash[String, [untyped, Integer]]
with_cas = client.get_multi_cas("a", "b")
client.get_multi_cas(%w[a b]) { |key, value_and_cas| key.upcase + value_and_cas[1].to_s }

# @type var with_metadata: Hash[String, Hash[Symbol, untyped]]
with_metadata = client.get_multi_with_metadata("a", "b")
client.get_multi_with_metadata("a") { |key, data| key.upcase + data[:stale].to_s }
# @type var results: Hash[String, Dalli::CacheResult]
results = client.get_multi_with_metadata_result("a", "b")

value = client.fetch("key")
value = client.fetch("key", 60) { "computed" }
value = client.fetch_with_lock("key", ttl: 300, lock_ttl: 30) { "computed" }

# @type var cas_result: Integer | false | nil
cas_result = client.cas("key") { |old| [old, 1] }
# @type var cas_bang_result: Integer | false
cas_bang_result = client.cas!("key", 60) { |old| [old, 2] }

# @type var quiet_result: Symbol
quiet_result = client.quiet do
  client.set("a", 1)
  client.delete("a")
  :done
end
client.multi { client.incr("counter") }

# @type var deadline_value: untyped
deadline_value = client.with_deadline(0.5) { |c| c.get("key") }
client.with { |c| c.get("key") }

client.set_multi({ "a" => 1, "b" => 2 }, 60)

# @type var deleted: bool?
deleted = client.delete("key")
deleted = client.delete("key", invalidate: true, tombstone_ttl: 30)
deleted = client.delete_cas("key", 123)
# @type var deleted_count: Integer
deleted_count = client.delete_multi(%w[a b])

# @type var appended: bool?
appended = client.append("raw", "abc")
appended = client.prepend("raw", "abc")

# @type var counter: Integer | false | nil
counter = client.incr("counter", 1, nil, 0)
counter = client.decr("counter", "2")

# @type var flushed: Array[bool?]
flushed = client.flush
flushed = client.flush_all(10)

# @type var stats: Hash[String, Hash[String, String]?]
stats = client.stats
stats = client.stats(:items)
# @type var reset: Array[bool?]
reset = client.reset_stats
# @type var versions: Hash[String, String?]
versions = client.version
client.alive!
client.not_found?(value)
client.drain_deferred_responses
client.close
client.reset

begin
  client.get("key")
rescue Dalli::RingError, Dalli::NetworkError, Dalli::MarshalError, Dalli::UnmarshalError, Dalli::ValueOverMaxSize => e
  e.message
rescue Dalli::DalliError => e
  e.message
end
Dalli::RetryableNetworkError.new("lost", request_sent: true).request_sent?

Dalli.logger.info("message")
Dalli.logger = Dalli.logger
Dalli::NOT_FOUND.equal?(value)

# @type var compressed: String
compressed = Dalli::Compressor.compress("data")
Dalli::Compressor.decompress(compressed, max_bytes: 1024)
Dalli::GzipCompressor.decompress(Dalli::GzipCompressor.compress("data"))
# @type var json: String
json = Dalli::JSONSerializer.dump({ "a" => 1 })
Dalli::JSONSerializer.load(json)

# @type var tracing: bool
tracing = Dalli::Instrumentation.enabled?
Dalli::Instrumentation.disable!
Dalli::Instrumentation.trace("get", { "db.operation.name" => "get" }) { 1 }
Dalli::Instrumentation.trace_with_result("get_multi") { |_span| 1 }
