require 'newrelic_rpm'

# Test NewRelic version constants
puts NewRelic::VERSION::STRING
puts NewRelic::VERSION::MAJOR
puts NewRelic::VERSION::MINOR
puts NewRelic::VERSION::TINY

# Test manual agent control
NewRelic::Agent.manual_start(
  app_name: 'TestApp',
  log_level: 'info',
  env: 'test'
)

# Test after_fork
NewRelic::Agent.after_fork(force_reconnect: true)

# Test recording metrics
NewRelic::Agent.record_metric('Custom/TestMetric', 1.5)
NewRelic::Agent.record_metric('Custom/TestMetric2', { count: 5, total: 10.0, min: 1.0, max: 3.0 })
NewRelic::Agent.increment_metric('Custom/Counter')
NewRelic::Agent.increment_metric('Custom/Counter2', 5)

# Test error handling
begin
  raise StandardError, "Test error"
rescue => e
  NewRelic::Agent.notice_error(e)
  NewRelic::Agent.notice_error(e, custom_params: { user_id: 123 })
  NewRelic::Agent.notice_error(e, expected: true, uri: '/test', metric: 'Controller/test')
end

# Test error filter - just test the method call without checking the block content
NewRelic::Agent.ignore_error_filter do |_error|
  nil
end

# Test error group callback - simplified to avoid untyped issues
NewRelic::Agent.set_error_group_callback(->(hash) {
  "error_group_test"
})

# Test custom events
NewRelic::Agent.record_custom_event('TestEvent', { user_id: 123, action: 'click' })
NewRelic::Agent.record_custom_event(:AnotherEvent, { value: 99.9, active: true })

# Test LLM feedback
NewRelic::Agent.record_llm_feedback_event(
  trace_id: '1234567890',
  rating: 'Good',
  category: 'helpful',
  message: 'Very helpful response',
  metadata: { session_id: 'abc123' }
)

# Test LLM token count callback - simplified to avoid untyped issues
NewRelic::Agent.set_llm_token_count_callback(->(hash) {
  42  # Just return a constant
})

# Test transaction control
NewRelic::Agent.set_transaction_name('TestTransaction')
NewRelic::Agent.set_transaction_name('TestTransaction2', category: :task)
name = NewRelic::Agent.get_transaction_name

NewRelic::Agent.ignore_transaction
NewRelic::Agent.ignore_apdex
NewRelic::Agent.ignore_enduser

# Test tracing control
result = NewRelic::Agent.disable_all_tracing do
  "traced block result"
end

sql_result = NewRelic::Agent.disable_sql_recording do
  "sql recording disabled"
end

# Test custom attributes
NewRelic::Agent.add_custom_attributes(user_id: 123, plan: 'premium')
NewRelic::Agent.add_custom_span_attributes(span_type: 'http', duration: 100)
NewRelic::Agent.add_custom_log_attributes(environment: 'production', service: 'api')
NewRelic::Agent.set_user_id('user123')

# Test database metric name
NewRelic::Agent.with_database_metric_name('User', 'find') do
  "database operation"
end

# Test browser timing
header = NewRelic::Agent.browser_timing_header
header_with_nonce = NewRelic::Agent.browser_timing_header('abc123nonce')

# Test linking metadata
metadata = NewRelic::Agent.linking_metadata

# Test instrumentation
NewRelic::Agent.add_instrumentation('lib/custom/*.rb')

# Test SQL obfuscator
NewRelic::Agent.set_sql_obfuscator(:replace) do |sql|
  sql.gsub(/\d+/, '?')
end

# Test drop_buffered_data without agent running
NewRelic::Agent.drop_buffered_data

# Test that modules are included properly (just verify they exist)
NewRelic::Agent::MethodTracer
NewRelic::Agent::MethodTracer::ClassMethods
NewRelic::Agent::Instrumentation::ControllerInstrumentation
NewRelic::Agent::Instrumentation::ControllerInstrumentation::ClassMethods

# Test constants
NewRelic::Agent::Instrumentation::ControllerInstrumentation::NR_DO_NOT_TRACE_KEY
NewRelic::Agent::Instrumentation::ControllerInstrumentation::NR_IGNORE_APDEX_KEY
NewRelic::Agent::Instrumentation::ControllerInstrumentation::NR_IGNORE_ENDUSER_KEY
NewRelic::Agent::Instrumentation::ControllerInstrumentation::NR_DEFAULT_OPTIONS

# Cleanup
NewRelic::Agent.drop_buffered_data
NewRelic::Agent.shutdown

puts "All NewRelic RPM tests completed"