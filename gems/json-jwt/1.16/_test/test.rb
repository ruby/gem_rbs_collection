# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'json/jwt'

private_key = OpenSSL::PKey::RSA.new <<-PEM
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAyBKIFSH8dP6bDkGBziB6RXTTfZVTaaNSWNtIzDmgRFi6FbLo
 :
-----END RSA PRIVATE KEY-----
PEM

public_key = OpenSSL::PKey::RSA.new <<-PEM
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyBKIFSH8dP6bDkGBziB6
 :
-----END PUBLIC KEY-----
PEM

# Sign & Encode
claim = {
  iss: 'nov',
  exp: 1.week.from_now,
  nbf: Time.now
}
jws = JSON::JWT.new(claim).sign(private_key, :RS256)
jws.to_s

# Decode & Verify
input = "jwt_header.jwt_claims.jwt_signature"
JSON::JWT.decode(input, public_key)
