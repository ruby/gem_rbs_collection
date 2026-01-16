require "signet"

begin
  raise Signet::AuthorizationError
rescue Signet::AuthorizationError => e
  # nop
end

class MyClient < Signet::OAuth2::Client
end

client = Signet::OAuth2::Client.new({
  :authorization_uri => 'https://example.com/authorization',
  :token_credential_uri => 'https://example.com/token',
  :client_id => 'my_client_id',
  :client_secret => 'my_client_secret',
  :scope => 'example',
  :redirect_uri => 'https://example.com/oauth'
})
