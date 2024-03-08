# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "retries"

Retries.sleep_enabled = Retries.sleep_enabled

with_retries max_tries: 10, base_sleep_seconds: 1.2, max_sleep_seconds: 3.4, handler: ->(e,a,t){}, rescue: [StandardError] do |attempt|
  puts "Attempt ##{attempt}"
end
