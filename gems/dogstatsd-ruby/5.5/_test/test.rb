# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "datadog/statsd"

statsd = Datadog::Statsd.new

statsd = Datadog::Statsd.new('localhost', 8125)

statsd = Datadog::Statsd.new(
  socket_path: '/file',
  namespace: 'test',
  tags: { "hello" => "world" },
  logger: Logger.new(STDERR),
  buffer_max_payload_size: 1,
  buffer_max_pool_size: 2,
  sender_queue_size: 3,
  buffer_flush_interval: 0.3,
  sample_rate: 0.1,
  single_thread: true,
  telemetry_enable: true,
  telemetry_flush_interval: 4
)

statsd.increment("sample")
statsd.increment("sample", 0.1)
statsd.increment("sample", sample_rate: 1, pre_sampled: true, tags: [], by: 10)

statsd.decrement("sample")
statsd.decrement("sample", 0.1)
statsd.decrement("sample", sample_rate: 1, pre_sampled: true, tags: [], by: 10)

statsd.count("sample", 1)
statsd.count("sample", 1, sample_rate: 1, pre_sampled: true, tags: [])

statsd.gauge("sample", 1)
statsd.gauge("sample", 1, 0.1)
statsd.gauge("sample", 1, sample_rate: 1, pre_sampled: true, tags: [])

statsd.histogram("sample", 1)
statsd.histogram("sample", 1, sample_rate: 1, pre_sampled: true, tags: [])

statsd.distribution("sample", 1)
statsd.distribution("sample", 1, sample_rate: 1, pre_sampled: true, tags: [])

statsd.distribution_time("sample", 0.1) { 123 }
statsd.distribution_time("sample", sample_rate: 1, tags: []) { :hello }

statsd.timing("sample", 1)
statsd.timing("sample", 1, 0.1)
statsd.timing("sample", 1, sample_rate: 1, pre_sampled: true, tags: [])

statsd.time("sample") { true }
statsd.time("sample", 0.1) { false }
statsd.time("sample", sample_rate: 1, pre_sampled: true, tags: []) { nil }

statsd.set("sample", 1)
statsd.set("sample", 1, 0.1)
statsd.set("sample", 1, sample_rate: 1, pre_sampled: true, tags: [])

statsd.service_check("sample", "status")
statsd.service_check("sample", "status", timestamp: Time.now.to_i, hostname: "localhost", message: "hello world", tags: [])

statsd.event("title", "text")
statsd.event("title", "text", date_happened: Time.now.to_i, hostname: "localhost", aggregation_key: "key", priority: "normal", source_type_name: "source", alert_type: "success", truncate_if_too_long: false, tags: [])

statsd.batch do
  statsd.set("sample", 1)
end

statsd.close
statsd.close(flush: true)

statsd.flush()
statsd.flush(flush_telemetry: true, sync: true)
