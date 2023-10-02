# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "shoryuken"

# https://github.com/ruby-shoryuken/shoryuken/wiki/Getting-Started
class HelloWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'hello', auto_delete: true

  def perform(sqs_msg, name)
    puts "Hello, #{name}"
  end
end

# https://github.com/ruby-shoryuken/shoryuken/wiki/FIFO-Queues
Shoryuken::Client.queues('queue.fifo').send_message(
  message_body: 'body',
  message_group_id: 'id',
  message_deduplication_id: 'id'
)
