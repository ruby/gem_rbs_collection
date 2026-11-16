require "devise-two-factor"
require "active_record"
require "devise/orm/active_record"

class User < ActiveRecord::Base
  devise :two_factor_authenticatable, otp_secret_length: 32
  devise :two_factor_backupable, otp_backup_code_length: 16, otp_number_of_backup_codes: 10
end

Devise.otp_secret_length = 20
Devise.otp_allowed_drift = 240
Devise.otp_allowed_drift = 60.seconds
Devise.otp_encrypted_attribute_options = {}
Devise.otp_backup_code_length = 16
Devise.otp_number_of_backup_codes = 5

# @type var secret_length: Integer
secret_length = Devise.otp_secret_length
# @type var drift: Integer | ActiveSupport::Duration
drift = Devise.otp_allowed_drift
# @type var encryption_key: String?
encryption_key = Devise.otp_secret_encryption_key
# @type var attribute_options: Hash[Symbol, untyped]?
attribute_options = Devise.otp_encrypted_attribute_options
# @type var backup_code_length: Integer
backup_code_length = Devise.otp_backup_code_length
# @type var number_of_backup_codes: Integer
number_of_backup_codes = Devise.otp_number_of_backup_codes

class TwoFactorSetup
  def run(user, code)
    user.otp_secret = User.generate_otp_secret
    # @type var generated: String
    generated = User.generate_otp_secret(32)
    user.otp_secret = generated
    # @type var secret: String?
    secret = user.otp_secret
    secret&.length

    # @type var uri: String
    uri = user.otp_provisioning_uri("user@example.com", issuer: "Example")
    user.otp_provisioning_uri("user@example.com")

    # @type var current: String
    current = user.current_otp

    # @type var valid: bool
    valid = user.validate_and_consume_otp!(code)
    user.validate_and_consume_otp!(code, otp_secret: generated)
    user.validate_and_consume_otp!(nil)

    user.otp_attempt = code
    # @type var attempt: String?
    attempt = user.otp_attempt
    attempt&.length
    user.otp_required_for_login = true
    # @type var drift_value: Integer | ActiveSupport::Duration
    drift_value = User.otp_allowed_drift
    # @type var length: Integer
    length = User.otp_secret_length
    # @type var key: String?
    key = User.otp_secret_encryption_key
    # @type var options: Hash[Symbol, untyped]?
    options = User.otp_encrypted_attribute_options
    # @type var code_length: Integer
    code_length = User.otp_backup_code_length
    # @type var code_count: Integer
    code_count = User.otp_number_of_backup_codes

    # @type var codes: Array[String]
    codes = user.generate_otp_backup_codes!
    # @type var invalidated: bool
    invalidated = user.invalidate_otp_backup_code!(code)
    user.invalidate_otp_backup_code!(nil)

    [uri, current, *codes, *[valid, invalidated, key, options, drift_value, length, code_length, code_count].map(&:to_s)]
  end
end
