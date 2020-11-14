require "retryable"

Retryable.retryable do
  puts "foo"
end

Retryable.retryable(tries: 3, on: ArgumentError) do
  puts "foo"
end

Retryable.configuration

Retryable.configure do |config|
  config.contexts = {}
  config.ensure = ->(retries) { puts "retries: #{retries}" }
  config.exception_cb = ->(exception) { puts exception.message }
  config.log_method = ->(retries, exception) { puts "retries: #{retries}, exception=#{exception.message}" }
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
