require 'apm_traceable'

ApmTraceable.configure do |config|
  config.adapter = 'stdout'
end

class TracerTestClass
  include ApmTraceable::Tracer
  extend ApmTraceable::Tracer::ClassMethods

  trace_methods :test_trace_method

  def test_trace_method
    'test'
  end

  def test_trace_span
    trace_span('test_name', option1: :value1) do
      'test'
    end
  end
end
