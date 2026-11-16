require "opentelemetry-sdk"
require "logger"

OpenTelemetry::SDK::VERSION.upcase

# @type var error_handler: ^(?exception: Exception?, ?message: String?) -> void
error_handler = ->(exception: nil, message: nil) { OpenTelemetry.logger.error("handled") }

OpenTelemetry::SDK.configure do |c|
  c.service_name = "sample-app"
  c.service_version = "1.2.3"
  c.logger = Logger.new($stdout)
  c.error_handler = error_handler
  c.propagators = [OpenTelemetry::Trace::Propagation::TraceContext.text_map_propagator]
  c.id_generator = OpenTelemetry::Trace
  c.resource = OpenTelemetry::SDK::Resources::Resource.create("deployment.environment" => "test", "retries" => 3)
  c.use("OpenTelemetry::Instrumentation::Rack", { untraced_endpoints: ["/ping"] })
  c.use("OpenTelemetry::Instrumentation::Redis")
  c.add_span_processor(
    OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(OpenTelemetry::SDK::Trace::Export::ConsoleSpanExporter.new)
  )
end

OpenTelemetry::SDK.configure do |c|
  c.use_all
end

OpenTelemetry::SDK.configure do |c|
  c.use_all({ "OpenTelemetry::Instrumentation::Sidekiq" => { span_naming: :queue } })
end

OpenTelemetry::SDK.configure(&:use_all)
OpenTelemetry::SDK.configure

begin
  raise OpenTelemetry::SDK::ConfigurationError, "bad"
rescue OpenTelemetry::Error => e
  e.message.upcase
end

# Resources
resource = OpenTelemetry::SDK::Resources::Resource.create("service.name" => "svc", "debug" => true)
OpenTelemetry::SDK::Resources::Resource.create
merged = resource.merge(OpenTelemetry::SDK::Resources::Resource.default)
merged = merged.merge(OpenTelemetry::SDK::Resources::Resource.telemetry_sdk).merge(OpenTelemetry::SDK::Resources::Resource.process)
merged.attribute_enumerator.each do |key, value|
  key.upcase
  value.to_s
end

scope = OpenTelemetry::SDK::InstrumentationScope.new("scope", "1.0", { "k" => "v" })
scope_name = scope.name
scope_name.upcase
scope.version = "2.0"
scope.attributes = nil

# Span limits
limits = OpenTelemetry::SDK::Trace::SpanLimits.new(
  attribute_count_limit: 64, attribute_length_limit: 256, event_count_limit: 32, link_count_limit: 32,
  event_attribute_count_limit: 16, event_attribute_length_limit: nil, link_attribute_count_limit: 16
)
OpenTelemetry::SDK::Trace::SpanLimits::DEFAULT.attribute_count_limit.succ
limits.attribute_length_limit&.succ
limits.event_count_limit.succ
limits.link_count_limit.succ
limits.event_attribute_count_limit.succ
limits.event_attribute_length_limit&.succ
limits.link_attribute_count_limit.succ

# Samplers
OpenTelemetry::SDK::Trace::Samplers::ALWAYS_ON.description.upcase
OpenTelemetry::SDK::Trace::Samplers::ALWAYS_OFF.description.upcase
parent_based = OpenTelemetry::SDK::Trace::Samplers.parent_based(root: OpenTelemetry::SDK::Trace::Samplers::ALWAYS_ON)
parent_based = OpenTelemetry::SDK::Trace::Samplers.parent_based(
  root: OpenTelemetry::SDK::Trace::Samplers.trace_id_ratio_based(0.5),
  remote_parent_sampled: OpenTelemetry::SDK::Trace::Samplers::ALWAYS_ON,
  remote_parent_not_sampled: OpenTelemetry::SDK::Trace::Samplers::ALWAYS_OFF,
  local_parent_sampled: OpenTelemetry::SDK::Trace::Samplers::ALWAYS_ON,
  local_parent_not_sampled: OpenTelemetry::SDK::Trace::Samplers::ALWAYS_OFF
)
ratio = OpenTelemetry::SDK::Trace::Samplers.trace_id_ratio_based(1)
ratio.description.upcase
parent_based.description.upcase

class InternalDropSampler
  def initialize
    @fallback = OpenTelemetry::SDK::Trace::Samplers.trace_id_ratio_based(0.25)
  end

  def should_sample?(trace_id:, parent_context:, links:, name:, kind:, attributes:)
    unless name.start_with?("internal.")
      return @fallback.should_sample?(trace_id: trace_id, parent_context: parent_context, links: links, name: name, kind: kind, attributes: attributes)
    end

    parent_span_context = OpenTelemetry::Trace.current_span(parent_context).context
    OpenTelemetry::SDK::Trace::Samplers::Result.new(
      decision: OpenTelemetry::SDK::Trace::Samplers::Decision::RECORD_ONLY,
      tracestate: parent_span_context.tracestate,
      attributes: { "sampler.dropped" => true }
    )
  end

  def description
    "InternalDropSampler"
  end
end

result = OpenTelemetry::SDK::Trace::Samplers::Result.new(decision: OpenTelemetry::SDK::Trace::Samplers::Decision::RECORD_AND_SAMPLE, tracestate: OpenTelemetry::Trace::Tracestate::DEFAULT)
result = OpenTelemetry::SDK::Trace::Samplers::Result.new(decision: OpenTelemetry::SDK::Trace::Samplers::Decision::RECORD_ONLY, tracestate: OpenTelemetry::Trace::Tracestate::DEFAULT, attributes: { "k" => 1 })
result.sampled?
result.recording?
result.attributes.fetch("k")
result.tracestate.empty?

internal_decision = OpenTelemetry::SDK::Trace::Samplers.parent_based(root: InternalDropSampler.new)
internal_decision.should_sample?(trace_id: "id", parent_context: OpenTelemetry::Context.current, links: nil, name: "n", kind: :client, attributes: nil).sampled?

# Processors and exporters
exporter = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
exporter = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new(recording: false)
exporter.recording = true
recording = exporter.recording
recording ? 1 : 0

class CountingProcessor < OpenTelemetry::SDK::Trace::SpanProcessor
  def initialize
    @started = 0
  end

  def started
    @started
  end

  def on_start(span, parent_context)
    @started += 1
  end

  def on_finishing(span)
    span.name.upcase
  end

  def on_finish(span)
    span.name.upcase
  end
end

counting = CountingProcessor.new
counting.force_flush(timeout: 1).succ
counting.shutdown.succ
counting.started.succ

class NullExporter < OpenTelemetry::SDK::Trace::Export::SpanExporter
  def export(span_data, timeout: nil)
    span_data.each { |data| data.name.upcase }
    OpenTelemetry::SDK::Trace::Export::SUCCESS
  end
end

simple = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(exporter)
batch = OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(NullExporter.new)
batch = OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(
  exporter,
  exporter_timeout: 1000, schedule_delay: 100.0, max_queue_size: 100, max_export_batch_size: 10,
  start_thread_on_boot: false, metrics_reporter: nil
)

# Tracer provider
provider = OpenTelemetry::SDK::Trace::TracerProvider.new
provider = OpenTelemetry::SDK::Trace::TracerProvider.new(
  sampler: InternalDropSampler.new,
  resource: resource,
  id_generator: OpenTelemetry::Trace,
  span_limits: limits
)
provider.add_span_processor(simple)
provider.add_span_processor(batch)
provider.add_span_processor(counting)
provider.sampler = OpenTelemetry::SDK::Trace::Samplers::ALWAYS_ON
provider.sampler.description.upcase
provider.span_limits = limits
provider.span_limits.link_count_limit.succ
provider.id_generator = OpenTelemetry::Trace
provider.id_generator.generate_trace_id.bytesize
provider.resource.merge(resource)
OpenTelemetry.tracer_provider = provider

tracer = provider.tracer("sample")
span = tracer.start_span("work", kind: :client, attributes: { "a" => 1 })
span.add_event("event", attributes: { "k" => "v" })
if span.is_a?(OpenTelemetry::SDK::Trace::Span)
  counting.on_start(span, OpenTelemetry::Context.current)
  counting.on_finishing(span)
  counting.on_finish(span)
end
span.finish
tracer.in_span("outer") do |outer, _context|
  outer.set_attribute("x", "y")
end

# Spans and span data
OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new.then do |memory|
  memory_provider = OpenTelemetry::SDK::Trace::TracerProvider.new
  memory_provider.add_span_processor(OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(memory))
  memory_provider.tracer("memory").in_span("recorded") { |recorded| recorded.set_attribute("k", "v") }

  # @type var data: OpenTelemetry::SDK::Trace::SpanData
  data = memory.finished_spans.fetch(0)
  data.name.upcase
  data.kind&.to_s
  data.status&.ok?
  data.parent_span_id.bytesize
  data.total_recorded_attributes.succ
  data.total_recorded_events.succ
  data.total_recorded_links.succ
  data.start_timestamp.succ
  data.end_timestamp&.succ
  data.attributes&.fetch("k")
  data.links&.each { |link| link.span_context.valid? }
  data.events&.each do |event|
    event.name.upcase
    event.attributes&.size
    event.timestamp.succ
  end
  data.resource.merge(resource)
  data.instrumentation_scope.name.upcase
  data.span_id.bytesize
  data.trace_id.bytesize
  data.trace_flags.sampled?
  data.tracestate.empty?
  data.parent_span_is_remote ? 1 : 0
  data.hex_span_id.upcase
  data.hex_trace_id.upcase
  data.hex_parent_span_id.upcase

  memory.force_flush.succ
  memory.reset
  memory.export([data], timeout: 1).succ
  memory.shutdown.succ
  memory_provider.force_flush(timeout: 5).succ
  memory_provider.shutdown(timeout: 5).succ
  OpenTelemetry::SDK::Trace::Export::SUCCESS + OpenTelemetry::SDK::Trace::Export::FAILURE + OpenTelemetry::SDK::Trace::Export::TIMEOUT
end

OpenTelemetry::SDK::Trace::Export::ConsoleSpanExporter.new.then do |console|
  console.export([]).succ
  console.force_flush.succ
  console.shutdown.succ
end

export_error = OpenTelemetry::SDK::Trace::Export::ExportError.new([])
export_error.spans.each { |failed| failed.name.upcase }
export_error.message.upcase

# Span (SDK)
sdk_span = OpenTelemetry::SDK::Trace::TracerProvider.new.tracer("s").start_span("sdk")
if sdk_span.is_a?(OpenTelemetry::SDK::Trace::Span)
  sdk_span.name.upcase
  sdk_span.status.ok?
  sdk_span.kind.to_s
  sdk_span.parent_span_id.bytesize
  sdk_span.start_timestamp.succ
  sdk_span.end_timestamp&.succ
  sdk_span.links&.size
  sdk_span.resource.merge(resource)
  sdk_span.instrumentation_scope.name.upcase
  sdk_span.attributes&.size
  sdk_span.events&.each { |event| event.name.upcase }
  sdk_span.to_span_data.name.upcase
end
