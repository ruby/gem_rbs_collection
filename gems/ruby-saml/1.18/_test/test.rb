require "ruby-saml"
require "openssl"

key = OpenSSL::PKey::RSA.new(2048)
certificate = OpenSSL::X509::Certificate.new
certificate.version = 2
certificate.serial = 1
certificate.subject = OpenSSL::X509::Name.parse("/CN=sp.example.com")
certificate.issuer = certificate.subject
certificate.public_key = key.public_key
certificate.not_before = Time.now - 60
certificate.not_after = Time.now + 3600
certificate.sign(key, "SHA256")
cert_pem = certificate.to_pem
key_pem = key.to_pem

saml_xml = <<~XML
  <samlp:Response xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_response" Version="2.0" IssueInstant="2030-01-01T00:00:00Z">
    <saml:Issuer>https://idp.example.com/metadata</saml:Issuer>
    <samlp:Status><samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/></samlp:Status>
    <saml:Assertion ID="_assertion" Version="2.0" IssueInstant="2030-01-01T00:00:00Z">
      <saml:Issuer>https://idp.example.com/metadata</saml:Issuer>
      <saml:Subject><saml:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress">user@example.com</saml:NameID></saml:Subject>
      <saml:Conditions NotBefore="2030-01-01T00:00:00Z" NotOnOrAfter="2030-01-01T01:00:00Z">
        <saml:AudienceRestriction><saml:Audience>https://sp.example.com/metadata</saml:Audience></saml:AudienceRestriction>
      </saml:Conditions>
      <saml:AuthnStatement AuthnInstant="2030-01-01T00:00:00Z" SessionIndex="_session" SessionNotOnOrAfter="2030-01-01T08:00:00Z">
        <saml:AuthnContext><saml:AuthnContextClassRef>urn:oasis:names:tc:SAML:2.0:ac:classes:Password</saml:AuthnContextClassRef></saml:AuthnContext>
      </saml:AuthnStatement>
      <saml:AttributeStatement>
        <saml:Attribute Name="email"><saml:AttributeValue>a@example.com</saml:AttributeValue></saml:Attribute>
      </saml:AttributeStatement>
    </saml:Assertion>
  </samlp:Response>
XML
encoded_saml = [saml_xml].pack("m0")

logout_response_xml = <<~XML
  <samlp:LogoutResponse xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_logout_response" Version="2.0" IssueInstant="2030-01-01T00:00:00Z" InResponseTo="_logout">
    <saml:Issuer>https://idp.example.com/metadata</saml:Issuer>
    <samlp:Status><samlp:StatusCode Value="urn:oasis:names:tc:SAML:2.0:status:Success"/></samlp:Status>
  </samlp:LogoutResponse>
XML
encoded_logout_response = [logout_response_xml].pack("m0")

logout_request_xml = <<~XML
  <samlp:LogoutRequest xmlns:samlp="urn:oasis:names:tc:SAML:2.0:protocol" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion" ID="_logout_request" Version="2.0" IssueInstant="2030-01-01T00:00:00Z">
    <saml:Issuer>https://idp.example.com/metadata</saml:Issuer>
    <saml:NameID Format="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress">user@example.com</saml:NameID>
    <samlp:SessionIndex>_session</samlp:SessionIndex>
  </samlp:LogoutRequest>
XML
encoded_logout_request = [logout_request_xml].pack("m0")

idp_metadata_xml = <<~XML
  <EntityDescriptor xmlns="urn:oasis:names:tc:SAML:2.0:metadata" entityID="https://idp.example.com/metadata">
    <IDPSSODescriptor protocolSupportEnumeration="urn:oasis:names:tc:SAML:2.0:protocol">
      <SingleSignOnService Binding="urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect" Location="https://idp.example.com/sso"/>
    </IDPSSODescriptor>
  </EntityDescriptor>
XML

settings = OneLogin::RubySaml::Settings.new
settings = OneLogin::RubySaml::Settings.new({ idp_sso_service_url: "https://idp.example.com/sso", "sp_entity_id" => "sp" }, true)

settings.idp_entity_id = "https://idp.example.com/metadata"
settings.idp_sso_service_url = "https://idp.example.com/sso"
settings.idp_slo_service_url = "https://idp.example.com/slo"
settings.idp_slo_response_service_url = "https://idp.example.com/slo/response"
settings.idp_cert = cert_pem
settings.idp_cert_fingerprint = "AA:BB"
settings.idp_cert_fingerprint_algorithm = XMLSecurity::Document::SHA256
settings.idp_cert_multi = { signing: [cert_pem], encryption: [] }
settings.idp_attribute_names = ["email"]
settings.idp_name_qualifier = "idp"
settings.valid_until = "2030-01-01T00:00:00Z"
settings.sp_entity_id = "https://sp.example.com/metadata"
settings.issuer = "https://sp.example.com/metadata"
settings.assertion_consumer_service_url = "https://sp.example.com/saml/consume"
settings.single_logout_service_url = "https://sp.example.com/saml/logout"
settings.assertion_consumer_logout_service_url = "https://sp.example.com/saml/logout"
settings.sp_name_qualifier = "sp"
settings.name_identifier_format = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
settings.name_identifier_value = "user@example.com"
settings.name_identifier_value_requested = "user@example.com"
settings.sessionindex = "_session"
settings.compress_request = false
settings.compress_response = false
settings.double_quote_xml_attribute_values = true
settings.message_max_bytesize = 500_000
settings.check_malformed_doc = true
settings.passive = false
settings.attributes_index = 5
settings.force_authn = true
settings.certificate = cert_pem
settings.certificate_new = cert_pem
settings.private_key = key_pem
multi_cert_settings = OneLogin::RubySaml::Settings.new
multi_cert_settings.sp_cert_multi = { signing: [{ certificate: cert_pem, private_key: key_pem }], encryption: [] }
multi_cert_settings.get_sp_cert
settings.authn_context = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
settings.authn_context = ["urn:oasis:names:tc:SAML:2.0:ac:classes:Password", "urn:oasis:names:tc:SAML:2.0:ac:classes:X509"]
settings.authn_context_comparison = "exact"
settings.authn_context_decl_ref = "urn:decl"
settings.soft = false
settings.idp_sso_service_binding = :redirect
settings.idp_slo_service_binding = OneLogin::RubySaml::Utils::BINDINGS[:post]
settings.protocol_binding = :post
settings.assertion_consumer_service_binding = :post
settings.single_logout_service_binding = :redirect
settings.assertion_consumer_logout_service_binding = :redirect

settings.security[:authn_requests_signed] = true
settings.security[:logout_requests_signed] = true
settings.security[:logout_responses_signed] = true
settings.security[:want_assertions_signed] = true
settings.security[:want_assertions_encrypted] = true
settings.security[:want_name_id] = true
settings.security[:metadata_signed] = true
settings.security[:check_idp_cert_expiration] = true
settings.security[:check_sp_cert_expiration] = true
settings.security[:strict_audience_validation] = true
settings.security[:lowercase_url_encoding] = true
settings.security[:digest_method] = XMLSecurity::Document::SHA256
settings.security[:signature_method] = XMLSecurity::Document::RSA_SHA256
settings.security = { want_assertions_signed: true, digest_method: XMLSecurity::Document::SHA256 }

settings.attribute_consuming_service.configure do
  service_name "Service"
  service_index 5
  add_attribute name: "Name", name_format: "Name Format", friendly_name: "Friendly Name"
  add_attribute name: "Another", attribute_value: ["a", "b"]
end

# @type var service_configured: bool
service_configured = settings.attribute_consuming_service.configured?

# @type var fingerprint: String?
fingerprint = settings.get_fingerprint
# @type var idp_cert: OpenSSL::X509::Certificate?
idp_cert = settings.get_idp_cert
# @type var sp_cert: OpenSSL::X509::Certificate?
sp_cert = settings.get_sp_cert
# @type var sp_cert_new: OpenSSL::X509::Certificate?
sp_cert_new = settings.get_sp_cert_new
# @type var sp_key: OpenSSL::PKey::RSA?
sp_key = settings.get_sp_key
# @type var sp_signing_key: OpenSSL::PKey::RSA?
sp_signing_key = settings.get_sp_signing_key

# @type var sso_url: String?
sso_url = settings.idp_sso_service_url
# @type var sso_binding: String?
sso_binding = settings.idp_sso_service_binding
# @type var slo_binding: String?
slo_binding = settings.idp_slo_service_binding
# @type var protocol_binding: String?
protocol_binding = settings.protocol_binding
# @type var acs_binding: String?
acs_binding = settings.assertion_consumer_service_binding
# @type var logout_binding: String?
logout_binding = settings.single_logout_service_binding
# @type var acls_binding: String?
acls_binding = settings.assertion_consumer_logout_service_binding
# @type var digest: String?
digest = settings.security[:digest_method]

# Metadata parsing
parser = OneLogin::RubySaml::IdpMetadataParser.new
parsed_settings = parser.parse(idp_metadata_xml, { settings: OneLogin::RubySaml::Settings.new, slo_binding: "urn:binding", name_id_format: ["urn:format"] })
parsed_settings = parser.parse(idp_metadata_xml, { settings: { sp_entity_id: "sp" } })
# @type var parsed: OneLogin::RubySaml::Settings
parsed = parsed_settings
# @type var metadata_hash: OneLogin::RubySaml::IdpMetadataParser::metadata
metadata_hash = parser.parse_to_hash(idp_metadata_xml)
# @type var metadata_array: Array[OneLogin::RubySaml::IdpMetadataParser::metadata]
metadata_array = parser.parse_to_array(idp_metadata_xml, { entity_id: "https://idp.example.com/metadata" })

# These methods open an HTTP connection, so they are only defined here.
def fetch_idp_metadata(parser)
  # @type var remote_settings: OneLogin::RubySaml::Settings
  remote_settings = parser.parse_remote("https://idp.example.com/metadata")
  remote_settings = parser.parse_remote("https://idp.example.com/metadata", true, { entity_id: "https://idp.example.com", sso_binding: [OneLogin::RubySaml::Utils::BINDINGS[:redirect]] })
  remote_settings.idp_sso_service_url
  # @type var remote_hash: OneLogin::RubySaml::IdpMetadataParser::metadata
  remote_hash = parser.parse_remote_to_hash("https://idp.example.com/metadata")
  # @type var remote_array: Array[OneLogin::RubySaml::IdpMetadataParser::metadata]
  remote_array = parser.parse_remote_to_array("https://idp.example.com/metadata", true)
  # @type var idp_cert_str: String?
  idp_cert_str = remote_hash[:idp_cert]
end

# @type var idp_sso: String?
idp_sso = metadata_hash[:idp_sso_service_url]
parsed.sp_entity_id

# AuthnRequest
auth_request = OneLogin::RubySaml::Authrequest.new
# @type var auth_uuid: String
auth_uuid = auth_request.uuid
auth_request.uuid = "_id"
# @type var auth_request_id: String
auth_request_id = auth_request.request_id
# @type var login_url: String
login_url = auth_request.create(settings)
login_url = auth_request.create(settings, { RelayState: "state" })
login_url = auth_request.create(settings, { "RelayState" => nil })

# Response
saml_response = OneLogin::RubySaml::Response.new(encoded_saml)
saml_response = OneLogin::RubySaml::Response.new(
  encoded_saml,
  settings: settings,
  matches_request_id: "_request",
  allowed_clock_drift: 30,
  check_duplicated_attributes: true,
  skip_audience: false,
  skip_authnstatement: false,
  skip_conditions: false,
  skip_destination: false,
  skip_recipient_check: false,
  skip_subject_confirmation: false
)
saml_response.settings = settings
# @type var response_settings: OneLogin::RubySaml::Settings?
response_settings = saml_response.settings
saml_response.soft = true
# @type var response_soft: bool
response_soft = saml_response.soft
# @type var valid: bool
valid = saml_response.is_valid?
valid = saml_response.is_valid?(true)
# @type var response_errors: Array[String]
response_errors = saml_response.errors
saml_response.errors = []
# @type var name_id: String?
name_id = saml_response.name_id
name_id = saml_response.nameid
# @type var name_id_format: String?
name_id_format = saml_response.name_id_format
name_id_format = saml_response.nameid_format
# @type var sp_qualifier: String?
sp_qualifier = saml_response.name_id_spnamequalifier
# @type var qualifier: String?
qualifier = saml_response.name_id_namequalifier
# @type var session_index: String?
session_index = saml_response.sessionindex
# @type var expires_at: Time?
expires_at = saml_response.session_expires_at
# @type var authn_instant: String?
authn_instant = saml_response.authn_instant
# @type var class_ref: String?
class_ref = saml_response.authn_context_class_ref
# @type var success: bool
success = saml_response.success?
# @type var status_code: String?
status_code = saml_response.status_code
# @type var status_message: String?
status_message = saml_response.status_message
# @type var not_before: Time?
not_before = saml_response.not_before
# @type var not_on_or_after: Time?
not_on_or_after = saml_response.not_on_or_after
# @type var in_response_to: String?
in_response_to = saml_response.in_response_to
# @type var destination: String?
destination = saml_response.destination
# @type var audiences: Array[String]
audiences = saml_response.audiences
# @type var drift: Float
drift = saml_response.allowed_clock_drift
# @type var encrypted: bool
encrypted = saml_response.assertion_encrypted?
# @type var response_id: String?
response_id = saml_response.response_id
# @type var assertion_id: String?
assertion_id = saml_response.assertion_id

# These readers raise ValidationError unless the assertion is signed, so they are only defined here.
def read_signed_response(response)
  # @type var issuers: Array[String]
  issuers = response.issuers
end

# Attributes
attributes = saml_response.attributes
# @type var single: String?
single = attributes.single("email")
# @type var multi: Array[String?]?
multi = attributes.multi(:groups)
# @type var email: (String | Array[String?])?
email = attributes["email"]
email = attributes.fetch(/mail/)
email = attributes.fetch("email")
# @type var all: Hash[String, Array[String?]]
all = attributes.all
all = attributes.attributes
# @type var included: bool
included = attributes.include?("email")
attributes.set("email", ["a@example.com"])
attributes["groups"] = ["admin"]
attributes.add("groups", "staff")
attributes.add(:groups, ["a", nil])
attributes.add("empty")
# @type var same: bool
same = attributes == attributes
attributes.each do |attribute_name, values|
  # @type var attribute_name_str: String
  attribute_name_str = attribute_name
  # @type var attribute_values: Array[String?]
  attribute_values = values
end
attributes.map { |attribute_name, values| attribute_name.upcase + values.size.to_s }
OneLogin::RubySaml::Attributes.single_value_compatibility = false
# @type var compat: bool
compat = OneLogin::RubySaml::Attributes.single_value_compatibility

# Logout request
logout_request = OneLogin::RubySaml::Logoutrequest.new
# @type var logout_uuid: String
logout_uuid = logout_request.uuid
logout_request.uuid = "_logout"
# @type var logout_request_id: String
logout_request_id = logout_request.request_id
# @type var logout_url: String
logout_url = logout_request.create(settings)
logout_url = logout_request.create(settings, { RelayState: "state" })

# Logout response (from the IdP)
logout_response = OneLogin::RubySaml::Logoutresponse.new(encoded_logout_response)
logout_response = OneLogin::RubySaml::Logoutresponse.new(encoded_logout_response, settings)
logout_response = OneLogin::RubySaml::Logoutresponse.new(
  encoded_logout_response,
  settings,
  matches_request_id: "_logout",
  allowed_clock_drift: 1.5,
  relax_signature_validation: true,
  get_params: { "SAMLResponse" => encoded_saml },
  raw_get_params: { "SAMLResponse" => "PHNhbWw%2B" }
)
logout_response.settings = settings
# @type var logout_response_settings: OneLogin::RubySaml::Settings?
logout_response_settings = logout_response.settings
logout_response.soft = true
# @type var logout_response_soft: bool
logout_response_soft = logout_response.soft
# @type var logout_valid: bool
logout_valid = logout_response.validate
logout_valid = logout_response.validate(true)
# @type var logout_errors: Array[String]
logout_errors = logout_response.errors
# @type var logout_response_id: String?
logout_response_id = logout_response.response_id
# @type var logout_success: bool
logout_success = logout_response.success?
# @type var logout_in_response_to: String?
logout_in_response_to = logout_response.in_response_to
# @type var logout_issuer: String?
logout_issuer = logout_response.issuer
# @type var logout_status_code: String?
logout_status_code = logout_response.status_code
# @type var logout_status_message: String?
logout_status_message = logout_response.status_message

# Logout request (from the IdP) and its response
slo_request = OneLogin::RubySaml::SloLogoutrequest.new(encoded_logout_request)
slo_request = OneLogin::RubySaml::SloLogoutrequest.new(
  encoded_logout_request,
  settings: settings,
  allowed_clock_drift: 1,
  relax_signature_validation: true,
  get_params: { "SAMLRequest" => encoded_saml },
  raw_get_params: { "SAMLRequest" => "PHNhbWw%2B" }
)
slo_request.settings = settings
# @type var slo_request_settings: OneLogin::RubySaml::Settings?
slo_request_settings = slo_request.settings
slo_request.soft = true
# @type var slo_request_soft: bool
slo_request_soft = slo_request.soft
# @type var slo_valid: bool
slo_valid = slo_request.is_valid?
slo_valid = slo_request.is_valid?(true)
# @type var slo_errors: Array[String]
slo_errors = slo_request.errors
# @type var slo_id: String?
slo_id = slo_request.id
# @type var slo_issuer: String?
slo_issuer = slo_request.issuer
# @type var slo_name_id: String?
slo_name_id = slo_request.name_id
slo_name_id = slo_request.nameid
# @type var slo_name_id_format: String?
slo_name_id_format = slo_request.name_id_format
slo_name_id_format = slo_request.nameid_format
# @type var slo_not_on_or_after: Time?
slo_not_on_or_after = slo_request.not_on_or_after
# @type var slo_session_indexes: Array[String]
slo_session_indexes = slo_request.session_indexes

slo_response = OneLogin::RubySaml::SloLogoutresponse.new
# @type var slo_response_uuid: String
slo_response_uuid = slo_response.uuid
slo_response.uuid = "_response"
# @type var slo_response_id: String
slo_response_id = slo_response.response_id
# @type var slo_response_url: String
slo_response_url = slo_response.create(settings)
slo_response_url = slo_response.create(settings, "_request", "logged out", { RelayState: "state" }, "urn:oasis:names:tc:SAML:2.0:status:Success")
slo_response_url = slo_response.create(settings, nil, nil, {}, nil)

# SP metadata
metadata = OneLogin::RubySaml::Metadata.new
# @type var metadata_xml: String
metadata_xml = metadata.generate(settings)
metadata_xml = metadata.generate(settings, true)
metadata_xml = metadata.generate(settings, false, Time.now + 172_800, 604_800)

# Utils
# @type var formatted_cert: String?
formatted_cert = OneLogin::RubySaml::Utils.format_cert(cert_pem)
# @type var formatted_key: String?
formatted_key = OneLogin::RubySaml::Utils.format_private_key(key_pem)
# @type var cert_object: OpenSSL::X509::Certificate?
cert_object = OneLogin::RubySaml::Utils.build_cert_object(formatted_cert)
# @type var key_object: OpenSSL::PKey::RSA?
key_object = OneLogin::RubySaml::Utils.build_private_key_object(formatted_key)
if cert_object
  # @type var expired: bool
  expired = OneLogin::RubySaml::Utils.is_cert_expired(cert_object)
  # @type var active: bool
  active = OneLogin::RubySaml::Utils.is_cert_active(cert_object)
end
expired = OneLogin::RubySaml::Utils.is_cert_expired(cert_pem)
# @type var post_binding: String
post_binding = OneLogin::RubySaml::Utils::BINDINGS.fetch(:post)

# Errors
saml_response.soft = false
begin
  saml_response.is_valid?
rescue OneLogin::RubySaml::ValidationError => e
  e.message.upcase
rescue OneLogin::RubySaml::SettingError, OneLogin::RubySaml::HttpError => e
  e.message.upcase
end

# @type var version: String
version = OneLogin::RubySaml::VERSION
# @type var c14n: String
c14n = XMLSecurity::BaseDocument::C14N
# @type var dsig: String
dsig = XMLSecurity::BaseDocument::DSIG
# @type var signature_methods: Array[String]
signature_methods = [
  XMLSecurity::Document::RSA_SHA1, XMLSecurity::Document::RSA_SHA256,
  XMLSecurity::Document::RSA_SHA384, XMLSecurity::Document::RSA_SHA512
]
# @type var digest_methods: Array[String]
digest_methods = [
  XMLSecurity::Document::SHA1, XMLSecurity::Document::SHA256,
  XMLSecurity::Document::SHA384, XMLSecurity::Document::SHA512
]
