require "twilio-ruby"
require "logger"

Twilio.configure do |config|
  config.account_sid = "ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  config.auth_token = "token"
  config.http_client = Twilio::HTTP::Client.new
  config.region = "au1"
  config.edge = "sydney"
  config.logger = Logger.new($stdout)
  # @type var configured_account_sid: String?
  configured_account_sid = config.account_sid
  # @type var configured_auth_token: String?
  configured_auth_token = config.auth_token
  # @type var configured_client: Twilio::HTTP::Client?
  configured_client = config.http_client
  # @type var configured_region_value: String?
  configured_region_value = config.region
  # @type var configured_edge_value: String?
  configured_edge_value = config.edge
  # @type var configured_logger_value: Logger?
  configured_logger_value = config.logger
end

# @type var configured_sid: String?
configured_sid = Twilio.account_sid
# @type var configured_token: String?
configured_token = Twilio.auth_token
# @type var configured_http: Twilio::HTTP::Client?
configured_http = Twilio.http_client
# @type var configured_region: String?
configured_region = Twilio.region
# @type var configured_edge: String?
configured_edge = Twilio.edge
# @type var configured_logger: Logger?
configured_logger = Twilio.logger
# @type var version: String
version = Twilio::VERSION

# Client
client = Twilio::REST::Client.new("ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "token")
api_key_client = Twilio::REST::Client.new("SKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "secret", "ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
Twilio::REST::Client.new("AC1", "token", nil, "au1")
client.region = "au1"
client.edge = "sydney"
client.logger = Logger.new($stdout)
client.http_client.adapter = :typhoeus
client.http_client.configure_connection { |faraday| faraday }
client.user_agent_extensions << "my-app"
# @type var username: String?
username = client.username
# @type var password: String?
password = client.password
# @type var account_sid: String?
account_sid = client.account_sid
# @type var auth_token: String?
auth_token = client.auth_token
# @type var region: String?
region = client.region
# @type var edge: String?
edge = client.edge
# @type var logger: Logger?
logger = client.logger
# @type var extensions: Array[String]
extensions = client.user_agent_extensions
# @type var http_adapter: Symbol
http_adapter = client.http_client.adapter
# @type var http_timeout: Integer?
http_timeout = Twilio::HTTP::Client.new("http", "proxy.example.com", 8080, "user", "pass", timeout: 30).timeout
api_key_client.account_sid

# Messages
message = client.messages.create(
  from: "+14159341234",
  to: "+16105557069",
  body: "Hey there!",
  status_callback: "https://example.com/status",
  media_url: ["https://example.com/image.png"],
  messaging_service_sid: "MGxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  content_sid: "HXxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
  content_variables: '{"1":"value"}'
)
# @type var message_sid: String
message_sid = message.sid
# @type var message_status: String?
message_status = message.status
# @type var message_body: String?
message_body = message.body
# @type var message_from: String?
message_from = message.from
# @type var message_to: String?
message_to = message.to
# @type var message_direction: String?
message_direction = message.direction
# @type var message_segments: String?
message_segments = message.num_segments
# @type var message_num_media: String?
message_num_media = message.num_media
# @type var message_price: String?
message_price = message.price
# @type var message_price_unit: String?
message_price_unit = message.price_unit
# @type var message_error_code: Integer?
message_error_code = message.error_code
# @type var message_error_message: String?
message_error_message = message.error_message
# @type var message_uri: String?
message_uri = message.uri
# @type var message_account_sid: String
message_account_sid = message.account_sid
# @type var message_service_sid: String?
message_service_sid = message.messaging_service_sid
# @type var message_api_version: String?
message_api_version = message.api_version
# @type var message_subresource_uris: Hash[String, untyped]?
message_subresource_uris = message.subresource_uris
# @type var message_sent: Time?
message_sent = message.date_sent
# @type var message_created: Time?
message_created = message.date_created
# @type var message_updated: Time?
message_updated = message.date_updated
# @type var fetched_message: Twilio::REST::Api::V2010::AccountContext::MessageInstance
fetched_message = message.fetch
# @type var fetched_by_sid: Twilio::REST::Api::V2010::AccountContext::MessageInstance
fetched_by_sid = client.messages("SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
# @type var recent_messages: Array[Twilio::REST::Api::V2010::AccountContext::MessageInstance]
recent_messages = client.messages.list(limit: 20, to: "+16105557069", from: "+14159341234", date_sent: Time.now, page_size: 50)
recent_messages.each { |m| m.body.to_s }

# the same resource through client.api
api_messages = client.api.v2010.account.messages
api_messages.create(from: "+14159341234", to: "+16105557069", body: "Hey there!")
client.api.account.messages("SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
client.api.v2010.messages.list(limit: 1)
client.api.v2010.messages("SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
client.api.v2010.account.messages("SMxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch

account_context = client.api.v2010.account
account_context.calls.list(status: "completed", limit: 5)
client.calls.list.each { |c| c.direction.to_s }
account_context.calls("CAxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
account_context.conferences.list
account_context.conferences("CFxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").update(status: "completed")
account_context.incoming_phone_numbers.list
account_context.incoming_phone_numbers("PNxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").update(sms_url: "https://example.com/sms")
account_context.applications.create(friendly_name: "app")
account_context.applications("APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
client.api.v2010.calls.create(from: "+14159341234", to: "+16105557069", url: "http://example.com")
client.api.v2010.calls("CAxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
client.api.v2010.conferences.list
client.api.v2010.conferences("CFxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").update(status: "completed")
client.api.v2010.incoming_phone_numbers.list
client.api.v2010.incoming_phone_numbers("PNxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").update(sms_url: "https://example.com/sms")
client.api.v2010.applications.create(friendly_name: "app")
client.api.v2010.applications("APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch

# keyword arguments built up in a Hash
send_params = { to: "+16105557069", body: "Hello", from: "+14159341234" }
client.messages.create(**send_params)

# Calls
call = client.calls.create(
  from: "+14159341234",
  to: "+16105557069",
  url: "http://example.com",
  status_callback: "https://example.com/call-status",
  status_callback_event: %w[initiated ringing answered completed],
  status_callback_method: "POST",
  timeout: 30,
  twiml: "<Response><Say>Hello</Say></Response>"
)
# @type var call_sid: String
call_sid = call.sid
# @type var call_status: String?
call_status = call.status
# @type var call_start: Time?
call_start = call.start_time
# @type var call_end: Time?
call_end = call.end_time
# @type var call_created: Time?
call_created = call.date_created
# @type var call_updated: Time?
call_updated = call.date_updated
# @type var call_parent: String?
call_parent = call.parent_call_sid
# @type var call_account_sid: String
call_account_sid = call.account_sid
# @type var call_to: String?
call_to = call.to
# @type var call_to_formatted: String?
call_to_formatted = call.to_formatted
# @type var call_from: String?
call_from = call.from
# @type var call_from_formatted: String?
call_from_formatted = call.from_formatted
# @type var call_phone_number_sid: String?
call_phone_number_sid = call.phone_number_sid
# @type var call_duration: String?
call_duration = call.duration
# @type var call_price: String?
call_price = call.price
# @type var call_price_unit: String?
call_price_unit = call.price_unit
# @type var call_direction: String?
call_direction = call.direction
# @type var call_answered_by: String?
call_answered_by = call.answered_by
# @type var call_api_version: String?
call_api_version = call.api_version
# @type var call_forwarded_from: String?
call_forwarded_from = call.forwarded_from
# @type var call_group_sid: String?
call_group_sid = call.group_sid
# @type var call_caller_name: String?
call_caller_name = call.caller_name
# @type var call_queue_time: String?
call_queue_time = call.queue_time
# @type var call_stir_verstat: String?
call_stir_verstat = call.stir_verstat
# @type var call_trunk_sid: String?
call_trunk_sid = call.trunk_sid
# @type var call_uri: String?
call_uri = call.uri
# @type var call_subresource_uris: Hash[String, untyped]?
call_subresource_uris = call.subresource_uris
# @type var fetched_call: Twilio::REST::Api::V2010::AccountContext::CallInstance
fetched_call = client.calls(call_sid).fetch
# @type var updated_call: Twilio::REST::Api::V2010::AccountContext::CallInstance
updated_call = client.calls(call_sid).update(status: "completed")
client.calls(call_sid).update(twiml: "<Response><Hangup/></Response>", url: "https://example.com", method: "POST", fallback_url: "https://example.com/fallback", fallback_method: "POST", status_callback: "https://example.com/cb", status_callback_method: "POST", time_limit: 60)
call.fetch.status
call.update(status: "canceled").status

# Conferences and participants
conferences = client.conferences.list(friendly_name: "room", status: "in-progress", date_created: Date.today, limit: 5)
conferences.each do |conference|
  # @type var conference_sid: String
  conference_sid = conference.sid
  # @type var conference_name: String?
  conference_name = conference.friendly_name
  # @type var conference_status: String?
  conference_status = conference.status
  client.conferences(conference_sid).update(status: "completed")
  client.conferences(conference_sid).update(announce_url: "https://example.com/announce", announce_method: "GET")
end
participants = client.conferences("CFxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").participants.list(muted: false, hold: false, coaching: false, limit: 10)
participants.each do |participant|
  # @type var participant_call_sid: String?
  participant_call_sid = participant.call_sid
  # @type var participant_label: String?
  participant_label = participant.label
  # @type var participant_conference_sid: String?
  participant_conference_sid = participant.conference_sid
  # @type var participant_status: String?
  participant_status = participant.status
  # @type var participant_muted: bool?
  participant_muted = participant.muted
  # @type var participant_hold: bool?
  participant_hold = participant.hold
end
client.conferences("CFxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").participants("CAxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").update(
  announce_url: "https://example.com/announce",
  announce_method: "GET",
  muted: true,
  hold: true,
  hold_url: "https://example.com/hold",
  hold_method: "GET",
  wait_url: "https://example.com/wait",
  wait_method: "GET",
  beep_on_exit: false,
  end_conference_on_exit: true,
  coaching: false,
  call_sid_to_coach: "CAxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
)

# Incoming phone numbers
numbers = client.incoming_phone_numbers.list(phone_number: "+14159341234", friendly_name: "main", beta: false, origin: "twilio", limit: 1)
number = numbers.first
if number
  # @type var number_sid: String
  number_sid = number.sid
  # @type var number_phone: String?
  number_phone = number.phone_number
  # @type var number_name: String?
  number_name = number.friendly_name
  # @type var number_capabilities: Hash[String, untyped]?
  number_capabilities = number.capabilities
  # @type var number_sms_url: String?
  number_sms_url = number.sms_url
  # @type var number_sms_method: String?
  number_sms_method = number.sms_method
  # @type var number_sms_application_sid: String?
  number_sms_application_sid = number.sms_application_sid
  # @type var number_voice_url: String?
  number_voice_url = number.voice_url
  # @type var number_voice_method: String?
  number_voice_method = number.voice_method
  # @type var number_voice_application_sid: String?
  number_voice_application_sid = number.voice_application_sid
  # @type var number_trunk_sid: String?
  number_trunk_sid = number.trunk_sid
  # @type var number_status_callback: String?
  number_status_callback = number.status_callback
  # @type var number_status_callback_method: String?
  number_status_callback_method = number.status_callback_method
  # @type var updated_number: Twilio::REST::Api::V2010::AccountContext::IncomingPhoneNumberInstance
  updated_number = client.incoming_phone_numbers(number_sid).update(
    sms_method: "POST",
    sms_url: "https://example.com/sms",
    voice_url: "https://example.com/voice",
    voice_method: "POST",
    status_callback: "https://example.com/status",
    status_callback_method: "POST",
    friendly_name: "main",
    sms_application_sid: "APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    sms_fallback_url: "https://example.com/fallback",
    sms_fallback_method: "POST",
    voice_application_sid: "APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    voice_caller_id_lookup: false,
    voice_fallback_url: "https://example.com/voice-fallback",
    voice_fallback_method: "POST",
    trunk_sid: "TKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    emergency_status: "Active",
    emergency_address_sid: "ADxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    voice_receive_mode: "voice",
    identity_sid: "RIxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    address_sid: "ADxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    bundle_sid: "BUxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    account_sid: "ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    api_version: "2010-04-01"
  )
end

# Applications
application = client.applications.create(friendly_name: "Voice app", voice_url: "https://example.com/voice", voice_method: "POST")
# @type var application_sid: String
application_sid = application.sid
# @type var application_name: String?
application_name = application.friendly_name
# @type var application_voice_url: String?
application_voice_url = application.voice_url
# @type var application_voice_method: String?
application_voice_method = application.voice_method
client.applications.create(
  api_version: "2010-04-01",
  voice_fallback_url: "https://example.com/fallback",
  voice_fallback_method: "POST",
  status_callback: "https://example.com/status",
  status_callback_method: "POST",
  voice_caller_id_lookup: false,
  sms_url: "https://example.com/sms",
  sms_method: "POST",
  sms_fallback_url: "https://example.com/sms-fallback",
  sms_fallback_method: "POST",
  sms_status_callback: "https://example.com/sms-status",
  message_status_callback: "https://example.com/message-status",
  public_application_connect_enabled: false
)
client.applications(application_sid).fetch.sid
client.applications(application_sid).update(
  friendly_name: "Renamed",
  api_version: "2010-04-01",
  voice_url: "https://example.com/voice",
  voice_method: "POST",
  voice_fallback_url: "https://example.com/fallback",
  voice_fallback_method: "POST",
  status_callback: "https://example.com/status",
  status_callback_method: "POST",
  voice_caller_id_lookup: false,
  sms_url: "https://example.com/sms",
  sms_method: "POST",
  sms_fallback_url: "https://example.com/sms-fallback",
  sms_fallback_method: "POST",
  sms_status_callback: "https://example.com/sms-status",
  message_status_callback: "https://example.com/message-status",
  public_application_connect_enabled: false
).voice_url
# @type var application_deleted: bool
application_deleted = client.applications(application_sid).delete

# Account
account = client.api.accounts("ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
# @type var account_resource_sid: String
account_resource_sid = account.sid
# @type var account_name: String?
account_name = account.friendly_name
# @type var account_state: String?
account_state = account.status
# @type var account_type: String?
account_type = account.type
client.api.v2010.accounts("ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
client.api.v2010.account.fetch
client.api.account.fetch

# Messaging
service = client.messaging.services("MGxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
# @type var service_sid: String
service_sid = service.sid
# @type var service_name: String?
service_name = service.friendly_name
# @type var service_inbound_url: String?
service_inbound_url = service.inbound_request_url
# @type var service_inbound_method: String?
service_inbound_method = service.inbound_method
# @type var service_inbound_on_number: bool?
service_inbound_on_number = service.use_inbound_webhook_on_number
client.messaging.v1.services("MGxxxxxxxxxxxxxxxxxxxxxxxxxxxxx").fetch
client.messaging.services(service_sid).update(
  inbound_method: "POST",
  inbound_request_url: "https://example.com/inbound",
  use_inbound_webhook_on_number: false,
  friendly_name: "Service",
  fallback_url: "https://example.com/fallback",
  fallback_method: "POST",
  status_callback: "https://example.com/status",
  sticky_sender: true,
  mms_converter: true,
  smart_encoding: true,
  scan_message_content: "inherit",
  fallback_to_long_code: true,
  area_code_geomatch: true,
  validity_period: 600,
  synchronous_validation: false,
  usecase: "marketing"
).sid

senders = client.messaging.v2.channels_senders.list(channel: "whatsapp")
sender = senders.find { |item| item.sender_id == "whatsapp:+14159341234" }
streamed_sender = client.messaging.v2.channels_senders.stream(channel: "whatsapp", limit: 10, page_size: 5).find { |item| item.sender_id == "whatsapp:+14159341234" }
[sender, streamed_sender].each do |s|
  next unless s

  # @type var sender_sid: String
  sender_sid = s.sid
  # @type var sender_id: String?
  sender_id = s.sender_id
  # @type var sender_status: String?
  sender_status = s.status
  # @type var sender_profile: Hash[String, untyped]?
  sender_profile = s.profile
  # @type var sender_properties: Hash[String, untyped]?
  sender_properties = s.properties
  # @type var sender_webhook: Hash[String, untyped]?
  sender_webhook = s.webhook
  client.messaging.v2.channels_senders(sender_sid).update(
    messaging_v2_channels_sender_requests_update: {
      webhook: { callback_url: "https://example.com/callback", callback_method: "POST" }
    }
  )
end

# Content
templates = client.content.v1.content_and_approvals.list(limit: 1000, page_size: 100)
templates.each do |template|
  # @type var template_sid: String
  template_sid = template.sid
  # @type var template_name: String?
  template_name = template.friendly_name
  # @type var template_language: String?
  template_language = template.language
  # @type var template_variables: Hash[String, untyped]?
  template_variables = template.variables
  # @type var template_types: Hash[String, untyped]?
  template_types = template.types
  # @type var template_approvals: Hash[String, untyped]?
  template_approvals = template.approval_requests
  # @type var template_created: Time?
  template_created = template.date_created
  # @type var template_updated: Time?
  template_updated = template.date_updated
end

# Errors
begin
  client.messages.list(limit: 20)
rescue Twilio::REST::RestError => e
  # @type var error_message: String
  error_message = e.message
  # @type var error_status: Integer
  error_status = e.status_code
  # @type var error_code: Integer
  error_code = e.code
  # @type var error_more_info: String?
  error_more_info = e.more_info
  # @type var error_details: Hash[String, untyped]?
  error_details = e.details
  # @type var error_text: String?
  error_text = e.error_message
  e.response
rescue Twilio::REST::TwilioError => e
  e.message
end

# Request validation
validator = Twilio::Security::RequestValidator.new("token")
# @type var valid: bool
valid = validator.validate("https://example.com/hook", { "From" => "+14159341234" }, "signature")
validator.validate("https://example.com/hook", '{"a":1}', "signature", "HMAC_SHA256")
# @type var algorithm: String
algorithm = Twilio::Security::RequestValidator.signature_algorithm("key=abc,algorithm=HMAC_SHA256")
Twilio::Security::RequestValidator.new
# @type var signature_header: String
signature_header = Twilio::Security::RequestValidator::SIGNATURE_HEADER
# @type var settings_header: String
settings_header = Twilio::Security::RequestValidator::SIGNATURE_SETTINGS_HEADER
# @type var sha1_name: String
sha1_name = Twilio::Security::RequestValidator::HMAC_SHA1
# @type var sha256_name: String
sha256_name = Twilio::Security::RequestValidator::HMAC_SHA256
# @type var digests: Hash[String, String]
digests = Twilio::Security::RequestValidator::DIGESTS

# @type var unsafe_params: Twilio::Security::RequestValidator::_ToUnsafeH
unsafe_params = _ = Object.new.tap { |o| o.define_singleton_method(:to_unsafe_h) { { "From" => "+14159341234" } } }
validator.validate("https://example.com/hook", unsafe_params, "signature")

# TwiML
voice = Twilio::TwiML::VoiceResponse.new do |r|
  r.say(message: "hello there", voice: "alice", loop: 2, language: "en-US")
  r.dial(caller_id: "+14159992222", action: "https://example.com/dial", method: "POST", timeout: 20, record: "record-from-start") do |d|
    d.client(identity: "jenny", url: "https://example.com/client", method: "POST", status_callback_event: "initiated", status_callback: "https://example.com/cb", status_callback_method: "POST")
    d.number("+14155551212", url: "https://example.com/number", method: "POST", status_callback_event: "answered", status_callback: "https://example.com/cb", status_callback_method: "POST")
  end
  r.redirect("https://example.com/next", method: "GET")
  r.hangup
end
# @type var voice_xml: String
voice_xml = voice.to_s
voice.to_xml
voice.to_s(false)
Twilio::TwiML::VoiceResponse.new(&:reject).to_s
Twilio::TwiML::VoiceResponse.new(&:hangup).to_s
Twilio::TwiML::VoiceResponse.new.reject(reason: "busy").to_s
Twilio::TwiML::VoiceResponse.new.tap do |response|
  response.dial do |dial|
    dial.conference(
      "room",
      muted: false,
      beep: true,
      start_conference_on_enter: true,
      end_conference_on_exit: false,
      wait_url: "https://example.com/wait",
      wait_method: "GET",
      max_participants: 10,
      record: "record-from-start",
      status_callback_event: "start end join leave",
      status_callback: "https://example.com/status",
      status_callback_method: "POST",
      recording_status_callback: "https://example.com/recording",
      recording_status_callback_method: "POST",
      recording_status_callback_event: "completed",
      participant_label: "contact",
      region: "us1"
    )
  end
  response.say(message: "Hi")
  response.comment("note")
  response.add_text("text")
  response.append(Twilio::TwiML::VoiceResponse.new)
end

messaging = Twilio::TwiML::MessagingResponse.new do |r|
  r.message(body: "Thanks", to: "+14159341234", from: "+14159992222", action: "https://example.com/a", method: "POST", status_callback: "https://example.com/s")
  r.message do |m|
    m.body("with media")
    m.media("https://example.com/image.png")
  end
  r.redirect("https://example.com/next", method: "POST")
end
# @type var messaging_xml: String
messaging_xml = messaging.to_s
Twilio::TwiML::MessagingResponse.new.to_s

# JWT
token = Twilio::JWT::AccessToken.new("ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "SKxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "secret", identity: "agent-1", ttl: 3600)
grant = Twilio::JWT::AccessToken::VoiceGrant.new
grant.incoming_allow = true
grant.outgoing_application_sid = "APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
grant.outgoing_application_params = { account_id: 1, is_agent: "true" }
grant.push_credential_sid = "CRxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
grant.endpoint_id = "endpoint"
# @type var grant_incoming: bool?
grant_incoming = grant.incoming_allow
# @type var grant_app_sid: String?
grant_app_sid = grant.outgoing_application_sid
# @type var grant_params: Hash[String | Symbol, untyped]?
grant_params = grant.outgoing_application_params
# @type var grant_push: String?
grant_push = grant.push_credential_sid
# @type var grant_endpoint: String?
grant_endpoint = grant.endpoint_id
# @type var granted: Array[Twilio::JWT::AccessTokenGrant]
granted = token.add_grant(grant)
# @type var jwt: String
jwt = token.to_jwt
token.to_s
# @type var token_headers: Hash[String | Symbol, untyped]
token_headers = token.headers
# @type var token_payload: Hash[Symbol, untyped]
token_payload = token.payload
# @type var token_account_sid: String
token_account_sid = token.account_sid
# @type var token_secret: String
token_secret = token.secret
# @type var token_signing_key_id: String?
token_signing_key_id = token.signing_key_id
token.signing_key_id = "SKyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
# @type var token_identity: String?
token_identity = token.identity
# @type var token_grants: Array[Twilio::JWT::AccessTokenGrant]
token_grants = token.grants
# @type var token_nbf: Integer?
token_nbf = token.nbf
# @type var token_ttl: Integer
token_ttl = token.ttl
# @type var token_valid_until: Integer?
token_valid_until = token.valid_until
# @type var token_region: String?
token_region = token.region
Twilio::JWT::AccessToken.new("ACx", "SKx", "secret", [grant], nbf: 1, valid_until: 2, region: "au1")

capability = Twilio::JWT::ClientCapability.new("ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "token")
capability.add_scope(Twilio::JWT::ClientCapability::OutgoingClientScope.new("APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"))
capability.add_scope(Twilio::JWT::ClientCapability::OutgoingClientScope.new("APxxxxxxxxxxxxxxxxxxxxxxxxxxxxx", "andrew", { "k" => "v" }))
capability.add_scope(Twilio::JWT::ClientCapability::IncomingClientScope.new("andrew"))
# @type var capability_token: String
capability_token = capability.to_s
capability.to_jwt
# @type var capability_account_sid: String
capability_account_sid = capability.account_sid
# @type var capability_auth_token: String
capability_auth_token = capability.auth_token
# @type var capability_client_name: String?
capability_client_name = capability.client_name
capability.client_name = "andrew"
# @type var capability_scopes: Array[Twilio::JWT::Scope]
capability_scopes = capability.scopes
Twilio::JWT::ClientCapability.new("ACx", "token", scopes: [], nbf: 1, ttl: 60, valid_until: 2)
