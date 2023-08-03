# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "shoryuken"

class HelloWorker
  include Shoryuken::Worker

  shoryuken_options queue: 'hello', auto_delete: true

  def perform(sqs_msg, name)
    puts "Hello, #{name}"
  end
end
