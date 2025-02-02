# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "base64"

Base64.decode64(Base64.encode64(""))
Base64.strict_decode64(Base64.strict_encode64(""))
Base64.urlsafe_decode64(Base64.urlsafe_encode64(""))
Base64.urlsafe_decode64(Base64.urlsafe_encode64("", padding: "true"))
