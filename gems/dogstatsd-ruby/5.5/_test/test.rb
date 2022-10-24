# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "datadog/statsd"

stasd = Datadog::Statsd.new

stasd = Datadog::Statsd.new('localhost', 8125)

stasd = Datadog::Statsd.new(socket_path: '/file', namespace: 'test', sender_queue_size: 3.1, single_thread: true)
