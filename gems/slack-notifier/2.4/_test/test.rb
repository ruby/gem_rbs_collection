# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "slack-notifier"

notifier = Slack::Notifier.new "WEBHOOK_URL", channel: "#default",
  username: "notifier"

notifier.ping "Hello default"
notifier.ping "Hello random", channel: "#random"

class NoOpHTTPClient
  def self.post(uri, params = {}); end
end

Slack::Notifier.new "WEBHOOK_URL" do
  defaults channel: "#default",
    username: "notifier"

  http_client NoOpHTTPClient
  middleware format_message: { formats: [:html] }
end

message = "Hello world, [check](http://example.com) it <a href='http://example.com'>out</a>"
notifier.ping Slack::Notifier::Util::LinkFormatter.format(message)
notifier.ping Slack::Notifier::Util::LinkFormatter.format(message, formats: [:html])

link_text = Slack::Notifier::Util::Escape.html("User <user@example.com>")
message = "Write to [#{link_text}](mailto:user@example.com)"
notifier.ping message

class SwapWords < Slack::Notifier::PayloadMiddleware::Base
  middleware_name :swap_words

  options pairs: ["hipchat" => "slack"]

  def call payload={}
    return payload unless payload[:text] # noope if there is no message to work on

    payload # always return the payload from your middleware
  end
end
