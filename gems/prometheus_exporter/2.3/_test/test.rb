require "prometheus_exporter"
require "prometheus_exporter/client"
require "prometheus_exporter/server"
require "prometheus_exporter/middleware"
require "prometheus_exporter/instrumentation"

PrometheusExporter::Metric::Base.default_prefix = "myapp_"
PrometheusExporter::Metric::Base.default_labels = { region: "eu" }
# @type var prefix: String
prefix = PrometheusExporter::Metric::Base.default_prefix
prefix.upcase
PrometheusExporter::Metric::Base.default_labels.fetch(:region)
PrometheusExporter::Metric::Base.default_aggregation = PrometheusExporter::Metric::Histogram
PrometheusExporter::Metric::Base.default_aggregation = PrometheusExporter::Metric::Summary
PrometheusExporter::Metric::Base.default_aggregation.new("a", "b")

# Client
client = PrometheusExporter::Client.new(host: "localhost", port: 9394, custom_labels: { host: "web-1" })
client.custom_labels = { host: "web-2" }
PrometheusExporter::Client.default = client
# @type var default_client: PrometheusExporter::Client
default_client = PrometheusExporter::Client.default
default_client.logger.warn("hello")

gauge_remote = client.register(:gauge, "memory", "Memory used")
gauge_remote.observe(100)
gauge_remote.observe(200, { host: "web-1" })
# @type var counter_remote: PrometheusExporter::Client::RemoteMetric
counter_remote = client.register(:counter, "requests", "Requests", { buckets: [1, 2] })
counter_remote.increment
counter_remote.increment({ path: "/" }, 2)
counter_remote.decrement({ path: "/" }, 1)
counter_remote.name.upcase
counter_remote.help.upcase
counter_remote.type.to_s
client.find_registered_metric("requests", type: :counter, help: "Requests")&.name&.upcase
client.send_json(type: "my_type", value: 1)
client.stop(wait_timeout_seconds: 10)

PrometheusExporter::Client.new(port: "9394", max_queue_size: nil, thread_sleep: 0.5, connect_timeout: 1, json_serializer: :oj,
                               logger: Logger.new($stderr), log_level: Logger::INFO, process_queue_once_and_stop: false,
                               tls_ca_file: "ca.pem", tls_cert_file: "cert.pem", tls_key_file: "key.pem")

# Metrics
gauge = PrometheusExporter::Metric::Gauge.new("temperature", "Temperature")
gauge.observe(1.5)
gauge.observe(2, region: "us")
gauge.set(3, { region: "ap" })
gauge.observe(nil, region: "us")
gauge.increment
gauge.increment({ region: "ap" }, 2)
gauge.decrement({ region: "ap" })
gauge.remove(region: "ap")
# @type var gauge_data: Hash[PrometheusExporter::Metric::labels, Numeric]
gauge_data = gauge.data
gauge_data.size
gauge.to_h.size
gauge.name.upcase
gauge.help.upcase
gauge.name = "other"
gauge.help = "Other"
gauge.type.upcase
gauge.metric_text.upcase
gauge.to_prometheus_text.upcase
gauge.reset!

counter = PrometheusExporter::Metric::Counter.new("jobs_total", "Jobs")
counter.observe
counter.observe(2, queue: "default")
counter.increment
counter.increment({ queue: "default" }, 3)
counter.decrement({ queue: "default" }, 1)
counter.reset({ queue: "default" }, 0)
counter.remove(queue: "default")
counter.data.size
counter.to_h.size

PrometheusExporter::Metric::Histogram.default_buckets = [0.1, 0.5, 1]
PrometheusExporter::Metric::Histogram.default_buckets.size
PrometheusExporter::Metric::Histogram::DEFAULT_BUCKETS.size
histogram = PrometheusExporter::Metric::Histogram.new("latency", "Latency", buckets: [0.1, 1])
histogram.observe(0.3)
histogram.observe(1, route: "/")
histogram.remove(route: "/")
histogram.buckets.size
histogram.type.upcase

summary = PrometheusExporter::Metric::Summary.new("duration", "Duration", quantiles: [0.5, 0.99])
summary.observe(0.3)
summary.observe(1, route: "/")
summary.remove(route: "/")
PrometheusExporter::Metric::Summary::DEFAULT_QUANTILES.size
PrometheusExporter::Metric::Summary::ROTATE_AGE.succ
PrometheusExporter::Metric::Summary.new("duration", "Duration")
PrometheusExporter::Metric::Histogram.new("latency", "Latency")

# Server
class MyCollector < PrometheusExporter::Server::TypeCollector
  def initialize
    @gauge = PrometheusExporter::Metric::Gauge.new("my_gauge", "My gauge")
  end

  def type
    "my_collector"
  end

  def collect(obj)
    @gauge.observe(obj.fetch("value"), name: obj["name"])
  end

  def metrics
    [@gauge]
  end
end

class MyBaseCollector < PrometheusExporter::Server::CollectorBase
  def type
    "my_base"
  end

  def metrics
    gauge = PrometheusExporter::Metric::Gauge.new("base_gauge", "Base gauge")
    gauge.observe(1)
    [gauge]
  end
end

my_collector = MyCollector.new
my_collector.type.upcase
my_collector.metrics.map(&:to_prometheus_text)
my_collector.collect({ "value" => 1 })
MyBaseCollector.new.process("{}")
MyBaseCollector.new.prometheus_metrics_text("")

collector = PrometheusExporter::Server::Collector.new(json_serializer: nil, logger: Logger.new($stdout))
collector.register_collector(my_collector)
collector.process('{"type":"my_collector","value":1}')
collector.process_hash({ "type" => "my_collector", "value" => 1 })
collector.prometheus_metrics_text.upcase
collector.logger.info("collector")

server = PrometheusExporter::Server::WebServer.new(bind: "localhost", port: 9394)
server.start
server.collector.process("{}")
server.stop
PrometheusExporter::Server::WebServer.new(port: nil, bind: nil, timeout: 5, verbose: true, auth: "/etc/prometheus/htpasswd", realm: "Metrics",
                                          collector: collector)

local_client = PrometheusExporter::LocalClient.new(collector: server.collector)
PrometheusExporter::LocalClient.new(collector: collector, json_serializer: :oj, custom_labels: { a: 1 })
# @type var local_collector: PrometheusExporter::Server::CollectorBase
local_collector = local_client.collector
local_collector.process("{}")
PrometheusExporter::Client.default = local_client

# Middleware
class RackApp
  def call(env)
    [200, { "content-type" => "text/plain" }, [env.fetch("PATH_INFO", "")]]
  end
end

class MyMiddleware < PrometheusExporter::Middleware
  def call(env)
    queue_time = measure_queue_time(env)
    result = @app.call(env)
    @client.send_json(type: "web", queue_time: queue_time)
    result
  end

  def custom_labels(env)
    { host: env.fetch("HTTP_HOST", "") }
  end
end

PrometheusExporter::Middleware.new(RackApp.new).call({ "PATH_INFO" => "/" })
# @type var empty_env: Hash[String, untyped]
empty_env = {}
PrometheusExporter::Middleware.new(RackApp.new, instrument: false).call(empty_env)
PrometheusExporter::Middleware.new(RackApp.new, { instrument: :prepend, client: client }).call(empty_env)
MyMiddleware.new(RackApp.new, instrument: false).custom_labels(empty_env)

# Instrumentation
# @type var thread: Thread
thread = PrometheusExporter::Instrumentation::Process.start(type: "web")
PrometheusExporter::Instrumentation::Process.start(client: client, type: nil, frequency: 10, labels: { app: "x" })
PrometheusExporter::Instrumentation::Process.started?
PrometheusExporter::Instrumentation::Process.stop
PrometheusExporter::Instrumentation::Puma.start unless PrometheusExporter::Instrumentation::Puma.started?
PrometheusExporter::Instrumentation::Puma.start(client: client, frequency: 15, labels: { type: "puma" })
PrometheusExporter::Instrumentation::ActiveRecord.start(custom_labels: { type: "puma" }, config_labels: [:database, :host])
PrometheusExporter::Instrumentation::ActiveRecord.start(client: client, frequency: 20, config_labels: ["host"])
PrometheusExporter::Instrumentation::ActiveRecord::ALLOWED_CONFIG_LABELS.size
PrometheusExporter::Instrumentation::SidekiqProcess.start
PrometheusExporter::Instrumentation::SidekiqProcess.start(client: client, frequency: 5)
PrometheusExporter::Instrumentation::SidekiqQueue.start
PrometheusExporter::Instrumentation::SidekiqQueue.start(client: client, frequency: 5, all_queues: true)
PrometheusExporter::Instrumentation::SidekiqStats.start
PrometheusExporter::Instrumentation::SidekiqStats.start(client: client, frequency: 5)
PrometheusExporter::Instrumentation::SidekiqStats.stop

class Job
end

PrometheusExporter::Instrumentation::Sidekiq.death_handler.call({ "class" => "Job", "retry" => false }, RuntimeError.new("boom"))

PrometheusExporter::VERSION.upcase
PrometheusExporter::DEFAULT_PORT.succ
PrometheusExporter::DEFAULT_BIND_ADDRESS.upcase
PrometheusExporter::DEFAULT_PREFIX.upcase
PrometheusExporter::DEFAULT_LABEL.size
PrometheusExporter::DEFAULT_TIMEOUT.succ
PrometheusExporter::DEFAULT_REALM.upcase
PrometheusExporter.hostname.upcase
