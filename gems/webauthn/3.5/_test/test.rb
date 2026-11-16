require "webauthn"

WebAuthn.configure do |config|
  config.allowed_origins = ["https://auth.example.com"]
  config.allowed_top_origins = ["https://app.example.com"]
  config.rp_name = "Example Inc."
  config.rp_id = "example.com"
  config.credential_options_timeout = 120_000
  config.encoding = :base64url
  config.algorithms << "ES384"
  config.verify_attestation_statement = true
  config.verify_cross_origin = true
  config.silent_authentication = false
  config.acceptable_attestation_types = ["None", "Self"]
  config.legacy_u2f_appid = "https://example.com/appid.json"
end

config = WebAuthn.configuration
# @type var origins: Array[String]?
origins = config.allowed_origins
# @type var rp_name: String?
rp_name = config.rp_name
# @type var rp_id: String?
rp_id = config.rp_id
# @type var algorithms: Array[String]
algorithms = config.algorithms
# @type var timeout: Integer
timeout = config.credential_options_timeout
config.encoding
config.allowed_top_origins&.first&.upcase
config.verify_attestation_statement ? 1 : 0
config.verify_cross_origin ? 1 : 0
config.silent_authentication ? 1 : 0
config.acceptable_attestation_types.first
config.legacy_u2f_appid&.upcase
config.attestation_root_certificates_finders.size
config.encoder.encode("abc").upcase
config.encoder.decode("YWJj").bytesize
config.relying_party.name

# @type var user_id: String
user_id = WebAuthn.generate_user_id
user_handle = WebAuthn.generate_user_handle
user_handle.upcase
WebAuthn::TYPE_PUBLIC_KEY.upcase

class RootFinder
  def find(attestation_format:, aaguid:, attestation_certificate_key_id:)
    nil
  end
end

config.attestation_root_certificates_finders = RootFinder.new
config.attestation_root_certificates_finders = [RootFinder.new]

# Registration
creation_options = WebAuthn::Credential.options_for_create(
  user: { id: user_id, name: "alice@example.com", display_name: "Alice" },
  exclude: ["credential-id"],
  authenticator_selection: { resident_key: "preferred", user_verification: "preferred" },
  attestation: "none",
  timeout: 60_000,
  extensions: { credProps: true },
  hints: ["security-key"]
)
# @type var challenge: String
challenge = creation_options.challenge
# @type var json: Hash[Symbol, untyped]
json = creation_options.as_json
creation_options.timeout + 1
creation_options.extensions.size
creation_options.hints&.first
creation_options.relying_party.id
creation_options.attestation&.upcase
creation_options.authenticator_selection&.size
creation_options.exclude&.first&.upcase
creation_options.exclude_credentials&.first&.fetch(:id)
creation_options.pub_key_cred_params.first&.fetch(:alg)
creation_options.rp.name.upcase
creation_options.rp.id&.upcase
creation_options.user.name.upcase
creation_options.user.id.upcase
creation_options.user.display_name.upcase
creation_options.attestation = "direct"
creation_options.authenticator_selection = { user_verification: "required" }
creation_options.exclude = ["other-id"]
creation_options.user = creation_options.user
creation_options.rp = creation_options.rp

WebAuthn::Credential.options_for_create(
  user: creation_options.user,
  rp: { name: "Example", id: "example.com" },
  algs: ["ES256", :RS256, -7],
  attestation_formats: ["none"],
  exclude_credentials: [{ type: "public-key", id: "credential-id" }],
  pub_key_cred_params: [{ type: "public-key", alg: -7 }],
  relying_party: WebAuthn::RelyingParty.new
)

# Authentication
request_options = WebAuthn::Credential.options_for_get(
  allow: ["credential-id"],
  user_verification: "required"
)
# @type var request_challenge: String
request_challenge = request_options.challenge
request_options.as_json
request_options.rp_id&.upcase
request_options.allow&.first&.upcase
request_options.user_verification&.upcase
request_options.allow_credentials.first&.fetch(:id)
request_options.rp_id = "example.com"
request_options.allow = ["credential-id"]
request_options.user_verification = "discouraged"

WebAuthn::Credential.options_for_get(
  rp_id: "example.com",
  allow_credentials: [{ type: "public-key", id: "credential-id", transports: ["usb"] }],
  relying_party: WebAuthn::RelyingParty.new
)

# Verification of a registration
raw_credential = {
  "id" => "Y3JlZGVudGlhbC1pZA",
  "rawId" => "Y3JlZGVudGlhbC1pZA",
  "type" => "public-key",
  "response" => { "clientDataJSON" => "e30", "attestationObject" => "", "authenticatorData" => "", "signature" => "" }
}
begin
  attestation = WebAuthn::Credential.from_create(raw_credential)
  attestation.verify(challenge, user_verification: true, user_presence: true)
  # @type var credential_id: String
  credential_id = attestation.id
  # @type var public_key: String?
  public_key = attestation.public_key
  attestation.raw_public_key&.bytesize
  # @type var sign_count: Integer?
  sign_count = attestation.sign_count
  attestation.raw_id.bytesize
  attestation.type.upcase
  attestation.client_extension_outputs&.fetch("credProps")
  attestation.authenticator_attachment&.upcase
  attestation.authenticator_extension_outputs&.size
  attestation.backup_eligible?
  attestation.backed_up?
  attestation.response.authenticator_data.aaguid&.upcase
rescue WebAuthn::Error => e
  e.message.upcase
end

# Verification of an authentication
begin
  assertion = WebAuthn::Credential.from_get(raw_credential, relying_party: WebAuthn::RelyingParty.new(allowed_origins: ["https://example.com"]))
  assertion.verify(challenge, public_key: "c3RvcmVkLXB1YmxpYy1rZXk", sign_count: 3, user_verification: true)
  assertion.user_handle&.upcase
  assertion.raw_user_handle&.bytesize
  assertion.response.authenticator_data.aaguid
  # @type var new_sign_count: Integer?
  new_sign_count = assertion.sign_count
rescue WebAuthn::SignCountVerificationError => e
  e.message.upcase
rescue WebAuthn::PublicKeyCredential::InvalidChallengeError
  nil
rescue WebAuthn::Error => e
  e.message.upcase
end

errors = [
  WebAuthn::Error,
  WebAuthn::RootCertificateFinderNotSupportedError,
  WebAuthn::ClientDataMissingError,
  WebAuthn::AuthenticatorDataFormatError,
  WebAuthn::AttestedCredentialDataFormatError,
  WebAuthn::AttestationStatement::FormatNotSupportedError,
  WebAuthn::PublicKeyCredential::InvalidChallengeError,
  WebAuthn::VerificationError,
  WebAuthn::AuthenticatorDataVerificationError,
  WebAuthn::BackupFlagsVerificationError,
  WebAuthn::ChallengeVerificationError,
  WebAuthn::OriginVerificationError,
  WebAuthn::RpIdVerificationError,
  WebAuthn::TopOriginVerificationError,
  WebAuthn::TypeVerificationError,
  WebAuthn::UserPresenceVerificationError,
  WebAuthn::UserVerifiedVerificationError,
  WebAuthn::AttestationStatementVerificationError,
  WebAuthn::AttestedCredentialVerificationError,
  WebAuthn::CredentialIdLengthVerificationError,
  WebAuthn::SignatureVerificationError,
  WebAuthn::SignCountVerificationError
] #: Array[singleton(WebAuthn::Error)]
errors.size

# RelyingParty
relying_party = WebAuthn::RelyingParty.new(
  name: "Example",
  id: "example.com",
  allowed_origins: ["https://example.com"],
  allowed_top_origins: nil,
  algorithms: WebAuthn::RelyingParty::DEFAULT_ALGORITHMS.dup,
  encoding: :base64url,
  verify_attestation_statement: false,
  verify_cross_origin: false,
  credential_options_timeout: 300_000,
  silent_authentication: false,
  acceptable_attestation_types: ["None"],
  attestation_root_certificates_finders: [RootFinder.new],
  legacy_u2f_appid: nil
)
relying_party.name = "Renamed"
relying_party.id = "example.org"
relying_party.allowed_origins = ["https://example.org"]
relying_party.allowed_top_origins = ["https://example.org"]
relying_party.algorithms = ["ES256"]
relying_party.encoding = :base64
relying_party.verify_attestation_statement = true
relying_party.verify_cross_origin = true
relying_party.credential_options_timeout = 1000
relying_party.silent_authentication = false
relying_party.acceptable_attestation_types = ["Self"]
relying_party.legacy_u2f_appid = "https://example.org/appid.json"
relying_party.attestation_root_certificates_finders = RootFinder.new
relying_party.name&.upcase
relying_party.id&.upcase
relying_party.allowed_origins&.first
relying_party.allowed_top_origins&.first
relying_party.algorithms.first
relying_party.encoding
relying_party.verify_attestation_statement ? 1 : 0
relying_party.verify_cross_origin ? 1 : 0
relying_party.credential_options_timeout + 1
relying_party.silent_authentication ? 1 : 0
relying_party.acceptable_attestation_types.first
relying_party.legacy_u2f_appid&.upcase
relying_party.attestation_root_certificates_finders.first
relying_party.encoder.encode("abc").upcase

registration_options = relying_party.options_for_registration(
  user: { id: user_id, name: "alice@example.com", display_name: "Alice" },
  exclude: [],
  authenticator_selection: { resident_key: "preferred", user_verification: "preferred" },
  attestation: "none"
)
registration_options.challenge.upcase
authentication_options = relying_party.options_for_authentication(allow: ["credential-id"], user_verification: "preferred")
authentication_options.challenge.upcase

class StoredCredential
  def public_key
    "c3RvcmVkLXB1YmxpYy1rZXk"
  end

  def sign_count
    0
  end

  def user_handle
    "handle"
  end
end

verifier = WebAuthn::RelyingParty.new(allowed_origins: ["https://example.com"], id: "example.com")
begin
  # @type var registered: WebAuthn::PublicKeyCredentialWithAttestation
  registered = verifier.verify_registration(raw_credential, challenge, user_presence: true)
  registered.public_key

  # @type var verified: WebAuthn::PublicKeyCredentialWithAssertion
  verified = verifier.verify_authentication(
    raw_credential,
    challenge,
    public_key: "c3RvcmVkLXB1YmxpYy1rZXk",
    sign_count: 0,
    user_verification: true
  )
  verified.sign_count

  result = verifier.verify_authentication(raw_credential, challenge, user_verification: true) do |credential|
    credential.id.upcase
    StoredCredential.new
  end
  result[0].user_handle
  result[1].user_handle
rescue WebAuthn::Error => e
  e.message.upcase
end

WebAuthn::PublicKeyCredential::Options::CHALLENGE_LENGTH + 1
WebAuthn::Encoder::STANDARD_ENCODING
