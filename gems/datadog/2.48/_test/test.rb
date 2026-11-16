require "datadog"
require "datadog/kit/identity"
require "datadog/kit/appsec/events"
require "datadog/kit/appsec/events/v2"

# Applying these settings starts the tracer, the profiler and the remote configuration, so they are type checked but never run.
# @type var configure_all: ^() -> void
configure_all = -> do
  Datadog.configure do |c|
    c.service = "example-app"
    c.env = "production"
    c.version = "1.2.3"
    c.site = "datadoghq.eu"
    c.hostname = "host-1"
    c.api_key = ENV["DD_API_KEY"]
    c.tags = { "team" => "backend", region: "eu" }

    c.agent.host = "127.0.0.1"
    c.agent.port = 8126
    c.agent.use_ssl = false
    c.agent.timeout_seconds = 30
    c.agent.uds_path = "/var/run/datadog/apm.socket"

    c.diagnostics.debug = false
    c.diagnostics.startup_logs.enabled = false
    c.logger.instance = Logger.new($stdout)
    c.logger.level = Logger::INFO
    c.profiling.enabled = true
    c.runtime_metrics.enabled = true
    c.runtime_metrics.opts = { tags: ["a:b"] }
    c.runtime_metrics.statsd = Object.new
    c.health_metrics.enabled = false
    c.health_metrics.statsd = Object.new
    c.telemetry.enabled = true
    c.remote.enabled = false

    c.tracing.enabled = true
    c.tracing.log_injection = true
    c.tracing.report_hostname = true
    c.tracing.trace_id_128_bit_generation_enabled = true
    c.tracing.trace_id_128_bit_logging_enabled = true
    c.tracing.propagation_style = ["datadog", "tracecontext"]
    c.tracing.propagation_style_extract = ["datadog"]
    c.tracing.propagation_style_inject = ["tracecontext"]
    c.tracing.partial_flush.enabled = true
    c.tracing.partial_flush.min_spans_threshold = 500
    c.tracing.sampling.default_rate = 0.5
    c.tracing.sampling.rate_limit = 100
    c.tracing.sampling.rules = "[]"
    c.tracing.sampling.span_rules = "[]"
    c.tracing.test_mode.enabled = true
    c.tracing.test_mode.async = false
    c.tracing.test_mode.writer_options = { buffer_size: 10 }
    c.tracing.writer_options = { buffer_size: 100 }

    c.tracing.instrument :rails
    c.tracing.instrument :http, split_by_domain: true, service_name: c.service
    c.tracing.instrument :pg do |pg|
      pg[:comment_propagation] = "full"
    end

    c.appsec.enabled = true
    c.appsec.instrument :rails
  end
end

# @type var config: Datadog::Core::Configuration::Settings
config = Datadog.configuration
# @type var service: String?
service = config.service
# @type var env: String?
env = config.env
# @type var version: String?
version = config.version
# @type var hostname: String?
hostname = config.hostname
# @type var site: String?
site = config.site
# @type var api_key: String?
api_key = config.api_key
# @type var tags: Hash[String, untyped]
tags = config.tags
# @type var host: String?
host = config.agent.host
# @type var port: (String | Integer)?
port = config.agent.port
# @type var use_ssl: bool?
use_ssl = config.agent.use_ssl
# @type var timeout: Numeric?
timeout = config.agent.timeout_seconds
# @type var uds: String?
uds = config.agent.uds_path
# @type var debug: bool
debug = config.diagnostics.debug
# @type var startup_logs: bool?
startup_logs = config.diagnostics.startup_logs.enabled
config.logger.instance
# @type var level: Integer
level = config.logger.level
# @type var profiling: bool
profiling = config.profiling.enabled
# @type var rm_enabled: bool
rm_enabled = config.runtime_metrics.enabled
# @type var rm_opts: Hash[Symbol, untyped]
rm_opts = config.runtime_metrics.opts
config.runtime_metrics.statsd
# @type var hm_enabled: bool
hm_enabled = config.health_metrics.enabled
config.health_metrics.statsd
# @type var telemetry: bool
telemetry = config.telemetry.enabled
# @type var remote: bool
remote = config.remote.enabled
# @type var tracing_enabled: bool
tracing_enabled = config.tracing.enabled
# @type var log_injection: bool
log_injection = config.tracing.log_injection
# @type var report_hostname: bool
report_hostname = config.tracing.report_hostname
# @type var gen128: bool
gen128 = config.tracing.trace_id_128_bit_generation_enabled
# @type var log128: bool
log128 = config.tracing.trace_id_128_bit_logging_enabled
# @type var styles: Array[String]
styles = config.tracing.propagation_style
# @type var extract_styles: Array[String]
extract_styles = config.tracing.propagation_style_extract
# @type var inject_styles: Array[String]
inject_styles = config.tracing.propagation_style_inject
# @type var flush_enabled: bool
flush_enabled = config.tracing.partial_flush.enabled
# @type var threshold: Integer
threshold = config.tracing.partial_flush.min_spans_threshold
# @type var rate: (Float | Integer | Rational)?
rate = config.tracing.sampling.default_rate
# @type var limit: Integer?
limit = config.tracing.sampling.rate_limit
# @type var rules: String?
rules = config.tracing.sampling.rules
# @type var span_rules: String?
span_rules = config.tracing.sampling.span_rules
# @type var test_mode: bool
test_mode = config.tracing.test_mode.enabled
# @type var test_async: bool
test_async = config.tracing.test_mode.async
# @type var test_writer: Hash[Symbol, untyped]
test_writer = config.tracing.test_mode.writer_options
# @type var writer_options: Hash[Symbol, untyped]
writer_options = config.tracing.writer_options
# @type var appsec_enabled: bool
appsec_enabled = config.appsec.enabled
# @type var rails_settings: Datadog::Tracing::Contrib::Configuration::Settings?
rails_settings = config.tracing[:rails]
rails_settings&.[](:service_name)
# @type var integration: Datadog::Tracing::Contrib::Integration
integration = config.tracing.instrument(:redis)

Datadog.configure_onto(Object.new, service_name: "api-requests", split_by_domain: true)
Datadog.configuration_for(Object.new, :service_name)
# @type var dd_logger: Logger
dd_logger = Datadog.logger
Datadog.shutdown!

# Tracing
# @type var result: Integer
result = Datadog::Tracing.trace(
  "web.request",
  resource: "GET /users",
  service: "web",
  type: "web",
  start_time: Time.now,
  tags: { "http.method" => "GET" },
  on_error: ->(span, error) { span.set_tag("error.class", error.class.name) }
) do |span, trace|
  # @type var span_id: Integer
  span_id = span.id
  # @type var trace_id: Integer
  trace_id = span.trace_id
  # @type var parent_id: Integer
  parent_id = span.parent_id
  # @type var span_name: String
  span_name = span.name
  # @type var span_resource: String
  span_resource = span.resource
  # @type var span_service: String?
  span_service = span.service
  # @type var span_type: String?
  span_type = span.type
  # @type var started: Time?
  started = span.start_time
  # @type var ended: Time?
  ended = span.end_time

  span.name = "web.request.renamed"
  span.resource = "GET /users/:id"
  span.service = "web-2"
  span.type = "http"
  span.set_tag("user.id", 1)
  span.set_tags({ "a" => "b" })
  span["custom"] = "value"
  # @type var tag: (String | Float)?
  tag = span.get_tag("user.id")
  # @type var tag2: (String | Float)?
  tag2 = span["custom"]
  # @type var has_tag: bool
  has_tag = span.has_tag?("user.id")
  span.set_metric("custom.metric", 1.5)
  # @type var metric: (String | Float)?
  metric = span.get_metric("custom.metric")
  span.clear_tag("a")
  span.clear_metric("custom.metric")
  # @type var span_tags: Hash[String, String | Float]
  span_tags = span.tags
  # @type var is_root: bool
  is_root = span.root?

  begin
    raise "boom"
  rescue => e
    span.set_error(e)
    span.record_exception(e, attributes: { "retry" => 1 })
  end

  # @type var trace_name: String?
  trace_name = trace.name
  # @type var trace_service: String?
  trace_service = trace.service
  # @type var trace_resource: String?
  trace_resource = trace.resource
  trace.name = "trace-name"
  trace.service = "trace-service"
  trace.resource = "trace-resource"
  trace.sampling_priority = 1
  # @type var priority: Integer?
  priority = trace.sampling_priority
  # @type var trace_active: Datadog::Tracing::SpanOperation?
  trace_active = trace.active_span
  # @type var trace_id_value: Integer
  trace_id_value = trace.id
  # @type var sampled: bool
  sampled = trace.sampled?
  # @type var trace_finished: bool
  trace_finished = trace.finished?
  trace.keep!
  trace.reject!
  trace.set_tag("t", "v")
  # @type var digest: Datadog::Tracing::TraceDigest
  digest = trace.to_digest
  Datadog::Tracing.continue_trace!(digest)
  # @type var continued: Integer
  continued = Datadog::Tracing.continue_trace!(digest) { 42 }
  continued

  1
end
result

Datadog::Tracing.trace("with.proc", on_error: proc { nil }) { 1 }

# @type var manual_span: Datadog::Tracing::SpanOperation
manual_span = Datadog::Tracing.trace("service.call", service: "svc", resource: "Foo")
manual_span.set_tag("result.status", "success")
# @type var finished: Datadog::Tracing::Span
finished = manual_span.finish
# @type var finished_flag: bool
finished_flag = manual_span.finished?
# @type var duration: Float?
duration = manual_span.duration
# @type var finished_id: Integer
finished_id = finished.id
# @type var finished_trace_id: Integer
finished_trace_id = finished.trace_id
# @type var finished_parent_id: Integer
finished_parent_id = finished.parent_id
# @type var finished_name: String
finished_name = finished.name
# @type var finished_resource: String
finished_resource = finished.resource
# @type var finished_service: String?
finished_service = finished.service
# @type var finished_type: String?
finished_type = finished.type
# @type var finished_status: Integer
finished_status = finished.status
# @type var finished_start: Time?
finished_start = finished.start_time
# @type var finished_end: Time?
finished_end = finished.end_time
# @type var finished_duration: Float?
finished_duration = finished.duration
# @type var finished_started: bool
finished_started = finished.started?
# @type var finished_stopped: bool
finished_stopped = finished.stopped?
# @type var finished_finished: bool
finished_finished = finished.finished?
finished.id = 1
finished.trace_id = 1
finished.parent_id = 0
finished.name = "n"
finished.resource = "r"
finished.service = "s"
finished.type = "t"
finished.status = 1
finished.start_time = Time.now
finished.end_time = Time.now
finished.set_error(RuntimeError.new("x"))
manual_span.finish(Time.now)

# @type var active_trace: Datadog::Tracing::TraceOperation?
active_trace = Datadog::Tracing.active_trace
# @type var active_span: Datadog::Tracing::SpanOperation?
active_span = Datadog::Tracing.active_span
active_span&.set_tag("k", "v")
# @type var correlation: Datadog::Tracing::Correlation::Identifier
correlation = Datadog::Tracing.correlation
# @type var corr_trace_id: String
corr_trace_id = correlation.trace_id
# @type var corr_span_id: String
corr_span_id = correlation.span_id
# @type var corr_env: String?
corr_env = correlation.env
# @type var corr_service: String
corr_service = correlation.service
# @type var corr_version: String?
corr_version = correlation.version
# @type var corr_hash: Hash[Symbol, untyped]
corr_hash = correlation.to_h
# @type var corr_log: String
corr_log = correlation.to_log_format
# @type var log_correlation: String
log_correlation = Datadog::Tracing.log_correlation
# @type var tracing_logger: Logger
tracing_logger = Datadog::Tracing.logger
# @type var tracing_on: bool
tracing_on = Datadog::Tracing.enabled?
Datadog::Tracing.keep!
Datadog::Tracing.reject!

filter = Datadog::Tracing::Pipeline::SpanFilter.new { |span| span.resource == "Internal::PingController#index" }
lambda_filter = Datadog::Tracing::Pipeline::SpanFilter.new(->(span) { span.name == "ping" })
processor = Datadog::Tracing::Pipeline::SpanProcessor.new { |span| span.set_tag("processed", "true") }
Datadog::Tracing.before_flush(filter, lambda_filter, processor)
Datadog::Tracing.before_flush do |segment|
  # @type var segment_spans: Array[Datadog::Tracing::Span]
  segment_spans = segment.spans
  # @type var segment_name: String?
  segment_name = segment.name
  # @type var segment_resource: String?
  segment_resource = segment.resource
  # @type var segment_service: String?
  segment_service = segment.service
  # @type var segment_id: Integer
  segment_id = segment.id
  # @type var segment_priority: Integer?
  segment_priority = segment.sampling_priority
  segment.set_tag("a", "b")
  segment
end
Datadog::Tracing.shutdown!

# Kit
trace_op = Datadog::Tracing.active_trace
if trace_op
  Datadog::Kit::Identity.set_user(trace_op, id: "42", login: "abc")
end
Datadog::Kit::Identity.set_user(id: "42", email: "a@example.com", name: "Alice", session_id: "s", role: "admin", scope: "all")
Datadog::Kit::Identity.set_user(trace_op, active_span, id: "42")

Datadog::Kit::AppSec::Events.track_login_success(user: { id: "42" }, "usr.login": "alice")
Datadog::Kit::AppSec::Events.track_login_success(trace_op, active_span, user: { id: "42", login: "alice" })
Datadog::Kit::AppSec::Events.track_login_failure(user_exists: true, user_id: "42")
Datadog::Kit::AppSec::Events.track_signup(user: { id: "42" })
Datadog::Kit::AppSec::Events.track("custom.event", "usr.id": "42", "actor.kind": "key")
Datadog::Kit::AppSec::Events.track("custom.event", trace_op, active_span, key: "value")
# @type var login_event: String
login_event = Datadog::Kit::AppSec::Events::LOGIN_SUCCESS_EVENT
# @type var failure_event: String
failure_event = Datadog::Kit::AppSec::Events::LOGIN_FAILURE_EVENT
# @type var signup_event: String
signup_event = Datadog::Kit::AppSec::Events::SIGNUP_EVENT

Datadog::Kit::AppSec::Events::V2.track_user_login_success("alice")
Datadog::Kit::AppSec::Events::V2.track_user_login_success("alice", "42")
Datadog::Kit::AppSec::Events::V2.track_user_login_success("alice", { id: "42", email: "a@example.com" }, { "usr.id": "42", key: 1 })
Datadog::Kit::AppSec::Events::V2.track_user_login_failure("alice")
Datadog::Kit::AppSec::Events::V2.track_user_login_failure("alice", true, { "usr.id": "42" })
Datadog::Kit::AppSec::Events::V2.track_user_signup("alice")
Datadog::Kit::AppSec::Events::V2.track_user_signup("alice", "42", { key: "value" })
