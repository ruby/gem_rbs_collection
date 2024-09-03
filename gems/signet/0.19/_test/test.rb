require "signet"

begin
  raise Signet::AuthorizationError
rescue Signet::AuthorizationError => e
  # nop
end

class MyClient < Signet::OAuth2::Client
end
