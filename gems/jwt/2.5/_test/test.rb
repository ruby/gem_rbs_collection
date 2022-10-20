require "jwt"

payload = { data: 'test' }
token = JWT.encode(payload, nil, 'none')
decoded, header = JWT.decode(token, nil, false)

hmac_secret = 'my$ecretK3y'
token = JWT.encode(payload, hmac_secret, 'HS256')
decoded, header = JWT.decode(token, hmac_secret, true, algorithm: 'HS256')

# Custom algorithm
class CustomAlgorithm
  def alg
    'custom'
  end

  def valid_alg?(alg_to_validate)
    true
  end

  def sign(data:, signing_key:)
    'sig'
  end

  def verify(data:, signature:, verification_key:)
    true
  end
end

alg = CustomAlgorithm.new

begin
  token = ::JWT.encode(payload, 'secret', alg)
rescue JWT::EncodeError => e
  puts e.backtrace
end

begin
  decoded, header = ::JWT.decode(token, 'secret', true, algorithm: alg)
rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature, JWT::IncorrectAlgorithm, JWT::ImmatureSignature, JWT::InvalidIssuerError, JWT::InvalidIatError, JWT::InvalidAudError, JWT::InvalidSubError, JWT::InvalidJtiError, JWT::InvalidPayload, JWT::MissingRequiredClaim, JWT::JWKError => e
  puts e.backtrace
end
