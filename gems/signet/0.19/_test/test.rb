require "signet"

begin
  raise Signet::AuthorizationError
rescue Signet::AuthorizationError => e
  # nop
end
