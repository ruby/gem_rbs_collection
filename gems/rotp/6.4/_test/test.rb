require "rotp"
require "rotp/version"

secret = ROTP::Base32.random
secret.upcase
random_secret = ROTP::Base32.random(10)
random_secret.upcase
legacy_secret = ROTP::Base32.random_base32
legacy_secret.upcase
short_secret = ROTP::Base32.random_base32(16)
short_secret.upcase

encoded = ROTP::Base32.encode("hello")
encoded.upcase
decoded = ROTP::Base32.decode("NBSWY3DP")
decoded.upcase

begin
  ROTP::Base32.decode("1")
rescue ROTP::Base32::Base32Error => e
  e.message.upcase
end

# TOTP
totp = ROTP::TOTP.new("base32secret3232", issuer: "My Service")

now_code = totp.now
now_code.upcase

timestamp = Time.now.to_i
at_code = totp.at(timestamp)
at_code.upcase
time_code = totp.at(Time.now)
time_code.upcase

verified = totp.verify(now_code)
verified&.succ

drift_verified = totp.verify(at_code, drift_behind: 15, drift_ahead: 15, at: timestamp + 35)
drift_verified&.succ

reuse_verified = totp.verify(at_code, after: timestamp)
reuse_verified&.succ
time_after_verified = totp.verify(at_code, after: Time.now, at: Time.now)
time_after_verified&.succ
nil_after_verified = totp.verify(at_code, after: nil)
nil_after_verified&.succ

uri = totp.provisioning_uri("alice@example.com")
uri.upcase
default_name_uri = totp.provisioning_uri
default_name_uri.upcase

interval = totp.interval
interval.succ
totp.secret.upcase
totp.digits.succ
totp.digest.upcase
totp.name&.upcase
totp.issuer&.upcase
totp.provisioning_params.keys
totp.skip_default_uri_params ? 1 : 0
totp.generate_otp(1).upcase

custom_totp = ROTP::TOTP.new(
  "base32secret3232",
  interval: 3600,
  digits: 8,
  digest: "sha256",
  name: "alice",
  provisioning_params: { image: "https://example.com/icon.png" },
  skip_default_uri_params: false
)
custom_totp.now.upcase

ROTP::TOTP.new("base32secret3232", :interval => 3600).now.upcase

# HOTP
hotp = ROTP::HOTP.new("base32secretkey3232", issuer: "My Service")
hotp_code = hotp.at(0)
hotp_code.upcase

hotp_verified = hotp.verify(hotp_code, 0)
hotp_verified&.succ
retry_verified = hotp.verify(hotp_code, 0, retries: 3)
retry_verified&.succ

hotp_uri = hotp.provisioning_uri("alice@example.com", 0)
hotp_uri.upcase
hotp_default_uri = hotp.provisioning_uri
hotp_default_uri.upcase

ROTP::DEFAULT_INTERVAL.succ
ROTP::VERSION.upcase
ROTP::OTP::DEFAULT_DIGITS.succ
ROTP::OTP::DEFAULT_DIGEST.upcase
