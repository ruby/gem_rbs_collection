# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "signet"

begin
  raise Signet::AuthorizationError
rescue Signet::AuthorizationError => e
  # nop
end
