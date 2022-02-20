require 'aws-sdk-core'

class Client < Seahorse::Client::Base
  include Aws::ClientStubs
  add_plugin(Aws::Plugins::StubResponses)
end

# singleton methods
Client.api

# new
client = Client.new(
  endpoint: 'https://example.com',
  stub_responses: true
)

# instance methods
client.config.endpoint
client.config.api
client.handlers
client.operation_names

# HandlerBuilder
handler = client.handle_request { |c| c }
handler.new(->(_) { }).call('context')

# ClientStubs
client.api_requests
