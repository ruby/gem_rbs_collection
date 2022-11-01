Faraday::Adapter.register_middleware(custom: Faraday::Adapter)
Faraday::Adapter.registered_middleware.each { |k, v| [k, v] }
Faraday::Adapter.lookup_middleware(:custom)
Faraday::Adapter.unregister_middleware(:custom)
Faraday::Adapter::CONTENT_LENGTH.chomp
Faraday::Adapter.supports_parallel = true
Faraday::Adapter.supports_parallel
Faraday::Adapter.supports_parallel?

class MyAdapter < Faraday::Adapter
end

MyAdapter.supports_parallel?

MyAdapter.new(Object.new, { test: 1234 })
MyAdapter.new(Object.new)
my_adapter = MyAdapter.new(Object.new) {}
my_adapter.connection(Object.new)
my_adapter.connection(Object.new) {}
my_adapter.close
my_adapter.send(:save_response, Object.new, 200, "🚀")
my_adapter.send(:save_response, Object.new, 200, "🚀", { test: 34 })
my_adapter.send(:save_response, Object.new, 200, "🚀", { test: 34 }, "No problem!")
my_adapter.send(:save_response, Object.new, 200, "🚀", { test: 34 }, "No problem!", true)
my_adapter.send(:save_response, Object.new, 200, "🚀", { test: 34 }, "No problem!", true) {}
my_adapter.send(:request_timeout, :read, { read_timeout: "ok" })
my_adapter.send(:request_timeout, :open, { timeout: "ok" })
response = my_adapter.call(Object.new)
response.status
response.headers
response.success?
MyAdapter::TIMEOUT_KEYS.slice(:read, :open, :write)
