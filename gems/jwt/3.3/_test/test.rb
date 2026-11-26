require "jwt"
require "openssl"

payload = { data: 'test' }

# @type var token: String
token = JWT.encode(payload, nil, 'none')
# @type var decoded: [untyped, Hash[String, untyped]]
decoded = JWT.decode(token, nil, false)
decoded_payload, header = decoded
header["alg"]

hmac_secret = 'my$ecretK3y'
token = JWT.encode(payload, hmac_secret, 'HS256', { typ: 'JWT' })
decoded_payload, header = JWT.decode(token, hmac_secret, true, algorithm: 'HS256')
JWT.decode(token, nil, true, { algorithms: ['HS256'] }) { |_header| hmac_secret }
JWT.decode(token, nil, true, { algorithms: ['HS256'] }) { |_header, _payload| hmac_secret }

# Custom algorithm
class CustomAlgorithm
  include JWT::JWA::SigningAlgorithm

  def initialize
    @alg = 'custom'
  end

  def sign(data:, signing_key:)
    OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), signing_key, data)
  end

  def verify(data:, signature:, verification_key:)
    OpenSSL.secure_compare(sign(data: data, signing_key: verification_key), signature)
  end
end

alg = CustomAlgorithm.new
JWT::JWA.register_algorithm(alg)
# @type var found: JWT::JWA::SigningAlgorithm
found = JWT::JWA.find('custom')
found.valid_alg?('CUSTOM')

begin
  token = ::JWT.encode(payload, 'secret', alg)
  decoded_payload, header = ::JWT.decode(token, 'secret', true, algorithm: alg)
rescue JWT::DecodeError, JWT::VerificationError, JWT::ExpiredSignature, JWT::IncorrectAlgorithm, JWT::ImmatureSignature, JWT::InvalidIssuerError, JWT::InvalidIatError, JWT::InvalidAudError, JWT::InvalidSubError, JWT::InvalidJtiError, JWT::InvalidPayload, JWT::MissingRequiredClaim, JWT::JWKError => e
  puts e.backtrace
rescue JWT::EncodeError, JWT::TokenError, JWT::ClaimValidationError, JWT::Error => e
  puts e.message
end

JWT.configure do |config|
  config.decode.leeway = 30
  config.decode.algorithms = ['HS256', 'RS256']
  config.jwk.kid_generator_type = :rfc7638_thumbprint
end
# @type var config: JWT::Configuration::Container
config = JWT.configuration
config.deprecation_warnings = :warn
# @type var gem_version: Gem::Version
gem_version = JWT.gem_version

# JWT::Token and JWT::EncodedToken
jwt_token = JWT::Token.new(payload: { pay: 'load', exp: Time.now.to_i + 60 }, header: { kid: 'hmac' })
jwt_token.sign!(algorithm: 'HS256', key: 'secret')
# @type var jwt: String
jwt = jwt_token.jwt
# @type var token_header: Hash[String, untyped]
token_header = jwt_token.header
# @type var claims_valid: bool
claims_valid = jwt_token.valid_claims?(:exp)

encoded_token = JWT::EncodedToken.new(jwt)
encoded_token.verify_signature!(algorithm: 'HS256', key: 'secret')
encoded_token.verify_claims!(:exp, iss: 'issuer')
# @type var claim_errors: Array[JWT::Claims::Error]
claim_errors = encoded_token.claim_errors(sub: 'not-my-subject')
claim_errors.map { |error| error.message.upcase }
encoded_token.verify!(signature: { algorithm: 'HS256', key: 'secret' })
# @type var valid: bool
valid = encoded_token.valid?(signature: { algorithm: ['HS256', 'HS512'], key: 'secret' }, claims: [:exp])
encoded_token.payload
# @type var encoded_payload: String?
encoded_payload = encoded_token.encoded_payload

# @type var payload_valid: bool
payload_valid = JWT::Claims.valid_payload?({ 'exp' => Time.now.to_i + 10 }, :exp)
JWT::Claims.verify_payload!({ 'exp' => Time.now.to_i - 10 }, exp: { leeway: 11 })

# JWK
rsa_key = OpenSSL::PKey::RSA.generate(2048)
# @type var jwk: JWT::JWK::RSA
jwk = JWT::JWK.new(rsa_key, { kid: 'my-kid', use: 'sig', alg: 'RS512' })
# @type var exported: Hash[Symbol, untyped]
exported = jwk.export(include_private: true)
# @type var signing_key: OpenSSL::PKey::RSA?
signing_key = jwk.signing_key
token = JWT.encode(payload, signing_key, jwk[:alg], kid: jwk[:kid])

# @type var hmac_jwk: JWT::JWK::HMAC
hmac_jwk = JWT::JWK.new('secret')
hmac_jwk.verify_key.upcase
# @type var imported: JWT::JWK::KeyBase
imported = JWT::JWK.import({ kty: 'oct', k: 'c2VjcmV0', alg: 'HS256' })
imported.kid

jwks = JWT::JWK::Set.new(jwk)
jwks << hmac_jwk
jwks.filter! { |key| 'sig'.eql?(key[:use]) }
# @type var algorithms: Array[untyped]
algorithms = jwks.map { |key| key[:alg] }.compact.uniq
# @type var jwks_hash: Hash[Symbol, Array[Hash[Symbol, untyped]]]
jwks_hash = jwks.export
JWT.decode(token, nil, true, algorithms: algorithms, jwks: jwks)

key_finder = JWT::JWK::KeyFinder.new(jwks: jwks)
encoded_token = JWT::EncodedToken.new(token)
encoded_token.verify!(signature: { algorithm: 'RS512', key_finder: key_finder })
finder_proc = ->(_token) { rsa_key.public_key }
encoded_token.valid_signature?(algorithm: "RS512", key_finder: finder_proc)

# @type var thumbprint: String
thumbprint = JWT::JWK::Thumbprint.new(jwk).generate

signing_jwk = JWT::JWK.new(rsa_key, { alg: 'RS256' })
token = JWT.encode(payload, signing_jwk, ['RS256', 'RS512'])
jwt_token = JWT::Token.new(payload: payload)
jwt_token.sign!(key: signing_jwk, algorithm: nil)
