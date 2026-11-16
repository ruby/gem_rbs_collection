require "opentelemetry-api"
require "logger"

OpenTelemetry.logger = Logger.new($stdout, level: Logger::ERROR)
logger = OpenTelemetry.logger
logger.error("logged")

OpenTelemetry.error_handler = ->(exception: nil, message: nil) { logger.warn("handled") }
error_handler = ->(exception: nil, message: nil) { logger.warn("handled") }
error_handler.arity
OpenTelemetry.handle_error(exception: RuntimeError.new("boom"), message: "failed")

version = OpenTelemetry::VERSION
version.upcase
OpenTelemetry::Error.new("base").message

# Tracer and spans
provider = OpenTelemetry.tracer_provider
tracer = provider.tracer("sample", "1.0.0")
named_tracer = provider.tracer(name: "named", version: "2.0.0", attributes: { "team" => "core", "shards" => 3 })
named_tracer.start_root_span("root").finish

result = tracer.in_span("sample.work", attributes: { "count" => 1, "ratio" => 0.5, "flag" => true, "tags" => ["a", "b"] }, kind: :client) do |span, context|
  span.set_attribute("key", "value")
  span["other"] = 42
  span.add_attributes("a" => 1, "b" => "two")
  span.add_event("checkpoint", attributes: { "step" => 1 }, timestamp: Time.now)
  span.add_link(OpenTelemetry::Trace::Link.new(span.context))
  span.name = "renamed"
  span.status = OpenTelemetry::Trace::Status.error("failed")
  span.record_exception(RuntimeError.new("oops"), attributes: { "retry" => false })

  recording = span.recording?
  recording ? context.value(OpenTelemetry::Context.create_key("k")) : nil
  "done"
end
result.upcase

tracer.in_span("sample.simple") { 1 + 1 }.succ
tracer.in_span("sample.kind", kind: OpenTelemetry::Trace::SpanKind::SERVER, record_exception: false, start_timestamp: Time.now) { |span| span.recording? }

link = OpenTelemetry::Trace::Link.new(OpenTelemetry::Trace::SpanContext::INVALID, { "linked" => "yes" })
tracer.in_span("sample.linked", links: [link]) { |span| span.finish(end_timestamp: Time.now) }

parent = OpenTelemetry::Context.current
child = tracer.start_span("child", with_parent: parent, attributes: { "kind" => "child" }, links: [link], start_timestamp: Time.now, kind: :internal)
child.set_attribute("finished", false)
# @type var string_attributes: Hash[String, String]
string_attributes = { "kind" => "variable" }
tracer.start_span("with-variable", attributes: string_attributes).finish
child.finish

OpenTelemetry::Trace::SpanKind::INTERNAL
OpenTelemetry::Trace::SpanKind::CLIENT
OpenTelemetry::Trace::SpanKind::PRODUCER
OpenTelemetry::Trace::SpanKind::CONSUMER

# Current span and status
current = OpenTelemetry::Trace.current_span
current.set_attribute("current", true)
OpenTelemetry::Trace.current_span(parent).context.tracestate.to_s

status = OpenTelemetry::Trace::Status.error
status.code + OpenTelemetry::Trace::Status::ERROR
status.description.upcase
status.ok?
OpenTelemetry::Trace::Status.ok("fine").description
OpenTelemetry::Trace::Status.unset.code
OpenTelemetry::Trace::Status::UNSET + 1

span_context = OpenTelemetry::Trace::SpanContext.new(
  trace_id: OpenTelemetry::Trace.generate_trace_id,
  span_id: OpenTelemetry::Trace.generate_span_id,
  trace_flags: OpenTelemetry::Trace::TraceFlags::SAMPLED,
  tracestate: OpenTelemetry::Trace::Tracestate.from_string("vendor=value"),
  remote: true
)
span_context.hex_trace_id.upcase
span_context.hex_span_id.upcase
span_context.trace_id.bytesize
span_context.span_id.bytesize
span_context.valid?
span_context.remote?
span_context.trace_flags.sampled?
span_context.tracestate.to_h
OpenTelemetry::Trace::INVALID_TRACE_ID.bytesize
OpenTelemetry::Trace::INVALID_SPAN_ID.bytesize

non_recording = OpenTelemetry::Trace.non_recording_span(span_context)
non_recording.context.valid?
OpenTelemetry::Trace::Span::INVALID.recording?

OpenTelemetry::Trace.with_span(non_recording) do |span, context|
  span.recording?
  OpenTelemetry::Trace.current_span(context).context.hex_span_id
end
with_span_context = OpenTelemetry::Trace.context_with_span(non_recording, parent_context: parent)
OpenTelemetry::Trace.context_with_span(non_recording).value(OpenTelemetry::Context.create_key("x"))
OpenTelemetry::Trace.current_span(with_span_context).finish

# Trace flags and tracestate
OpenTelemetry::Trace::TraceFlags.from_byte(1).sampled?
OpenTelemetry::Trace::TraceFlags::DEFAULT.sampled?

tracestate = OpenTelemetry::Trace::Tracestate.from_hash({ "vendor" => "value" })
tracestate.value("vendor")&.upcase
tracestate["vendor"]&.upcase
tracestate.set_value("other", "x").delete("vendor").empty?
OpenTelemetry::Trace::Tracestate.create({ "a" => "b" }).to_s
OpenTelemetry::Trace::Tracestate::DEFAULT == tracestate

link.span_context.valid?
link.attributes.size
link == link

# Context
context = OpenTelemetry::Context.current
key = OpenTelemetry::Context.create_key("custom")
key.name.upcase
key.get
key.get(context)
OpenTelemetry::Context.empty.value(key)
OpenTelemetry::Context::ROOT.value(key)
OpenTelemetry::Context.value(key)

with_key = context.set_value(key, "v")
with_key[key]
with_key.set_values({ key => "w" }).value(key)

token = OpenTelemetry::Context.attach(with_key)
detached = OpenTelemetry::Context.detach(token)
detached ? 1 : 0

OpenTelemetry::Context.with_current(context) { |ctx| ctx.value(key) }
OpenTelemetry::Context.with_value(key, "inner") do |ctx, value|
  # @type var stored: String
  stored = ctx.value(key)
  stored + value
end.upcase
OpenTelemetry::Context.with_values({ key => 1 }) do |ctx, values|
  # @type var stored: Integer
  stored = ctx.set_values(values).value(key)
  values.size + stored
end.succ
OpenTelemetry::Context.clear.size
begin
  raise OpenTelemetry::Context::DetachError, "mismatch"
rescue OpenTelemetry::Error => e
  e.message
end

# Propagation
# @type var carrier: Hash[String, String]
carrier = {}
OpenTelemetry.propagation.inject(carrier)
OpenTelemetry.propagation.inject(carrier, context: context, setter: OpenTelemetry::Context::Propagation.text_map_setter)
extracted = OpenTelemetry.propagation.extract(carrier)
extracted.value(key)
OpenTelemetry.propagation.extract(carrier, context: context, getter: OpenTelemetry::Context::Propagation.text_map_getter).value(key)
OpenTelemetry.propagation.fields.first&.upcase

traceparent = OpenTelemetry::Trace::Propagation::TraceContext.text_map_propagator
baggage_propagator = OpenTelemetry::Baggage::Propagation.text_map_propagator
composite = OpenTelemetry::Context::Propagation::CompositeTextMapPropagator.compose_propagators([traceparent, baggage_propagator])
OpenTelemetry.propagation = composite
composite.inject(carrier)
composite.extract(carrier).value(key)
composite.fields.map(&:upcase)

OpenTelemetry::Context::Propagation::CompositeTextMapPropagator.compose(injectors: [traceparent], extractors: [baggage_propagator]).fields

noop = OpenTelemetry::Context::Propagation::NoopTextMapPropagator.new
noop.inject(carrier, context: context)
noop.extract(carrier, getter: OpenTelemetry::Context::Propagation::RackEnvGetter.new).value(key)
noop.fields

traceparent.inject(carrier, context: with_span_context, setter: OpenTelemetry::Context::Propagation::TextMapSetter.new)
traceparent.extract(carrier, context: context, getter: OpenTelemetry::Context::Propagation::TextMapGetter.new)
traceparent.fields

getter = OpenTelemetry::Context::Propagation::TextMapGetter.new
getter.get(carrier, "traceparent")&.upcase
getter.keys(carrier).map(&:upcase)
OpenTelemetry::Context::Propagation::RackEnvGetter.new.get({ "HTTP_TRACEPARENT" => "00" }, "traceparent")
OpenTelemetry::Context::Propagation::TextMapSetter.new.set(carrier, "k", "v")

# Baggage
baggage_context = OpenTelemetry::Baggage.build(context: context) do |builder|
  entry = builder.set_value("user", "alice", metadata: "meta")
  entry.value.upcase
  builder.set_value("tenant", "acme")
  builder.remove_value("tenant")&.metadata
  builder.entries.size
end
OpenTelemetry::Baggage.build { |builder| builder.clear.size }
OpenTelemetry::Baggage.value("user", context: baggage_context)&.upcase
OpenTelemetry::Baggage.value("user")
OpenTelemetry::Baggage.values(context: baggage_context).keys
OpenTelemetry::Baggage.raw_entries(context: baggage_context).each_value { |entry| entry.metadata&.upcase }
OpenTelemetry::Baggage.set_value("a", "b", metadata: "m", context: baggage_context).value(key)
OpenTelemetry::Baggage.set_value("a", "b").value(key)
OpenTelemetry::Baggage.remove_value("a", context: baggage_context).value(key)
OpenTelemetry::Baggage.clear.value(key)
OpenTelemetry::Baggage.clear(context: baggage_context).value(key)

