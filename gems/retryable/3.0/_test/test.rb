require "retryable"

Retryable.retryable(tries: 0)

str = Retryable.retryable do
  "foo"
end
str&.ascii_only?

Retryable.retryable do |retries, exception|
  retries.bit_length
  exception&.backtrace
end

Retryable.retryable(
  ensure: ->(retries) { retries.bit_length },
  exception_cb: ->(exception) { exception.backtrace },
  log_method: ->(retries, exception) { [retries.bit_length, exception.backtrace] },
  matching: [/foo/, "bar"],
  not: [ArgumentError],
  on: StandardError,
  sleep: 10,
  sleep_method: ->(n) { n ** 1 },
  tries: 3
) do
  puts "foo"
end

Retryable.configuration.tap do |config|
  config.contexts.keys
  config.ensure.call(1)
  config.exception_cb.call(RuntimeError.new)
  config.log_method.call(1, RuntimeError.new)
  config.matching
  config.not
  config.on
  config.sleep
  config.tries.integer?
  config.enabled
  config.enabled?
  config.enable
  config.disable
  config[:tries]
  config.to_hash
  config.merge({ sleep: 1 })
end

Retryable.configuration = Retryable.configuration

Retryable.configure do |config|
  config.contexts[:foo] = {
    on: [ArgumentError],
    sleep: 10,
    tries: 5
  }
  config.ensure = ->(retries) { retries.bit_length }
  config.exception_cb = ->(exception) { exception.backtrace }
  config.log_method = ->(retries, exception) { [retries.bit_length, exception&.backtrace] }
  config.matching = /foo/
  config.matching = "bar"
  config.matching = [/foo/, "bar"]
  config.not = ArgumentError
  config.not = [ArgumentError]
  config.on = ArgumentError
  config.on = [ArgumentError]
  config.sleep = 1
  config.sleep = 0.5
  config.sleep = ->(retries) { retries ** 2 }
  config.sleep_method = ->(n) { sleep(n.to_int + 1.5) }
  config.tries = 3
end

Retryable.with_context(:foo)
Retryable.with_context(:foo, { sleep: 10 })
str = Retryable.with_context(:foo, { sleep: 10, tries: 3 }) do |retries, exception|
  retries.bit_length
  exception&.backtrace
  "foo"
end
str&.ascii_only?

Retryable.retryable_with_context(:faulty_service)
