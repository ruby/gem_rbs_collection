require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "tmp/cassettes"
  c.default_cassette_options = { record: :new_episodes, match_requests_on: [:method, :uri, :body] }
  c.default_cassette_options[:allow_playback_repeats] = true
  c.ignore_hosts "example.org", "example.net"
  c.ignore_localhost = true
  c.ignore_request { |request| request.uri.include?("health") }
  c.allow_http_connections_when_no_cassette = false
  c.filter_sensitive_data("<API_KEY>") { "secret" }
  c.define_cassette_placeholder("<TOKEN>", :auth) { |interaction| interaction.request.headers["Authorization"]&.first }
  c.before_record do |interaction, cassette|
    interaction.ignore! if interaction.response.status.code >= 500
    interaction.response.headers.delete("Set-Cookie") if cassette.tags.include?(:no_cookie)
  end
  c.before_playback(:auth) { |interaction| interaction.filter!("old", "new") }
  c.before_http_request(:real?) { |request| "#{request.method&.upcase} #{request.uri}" }
  c.after_http_request(->(request) { request.recordable? }) do |request, response|
    "#{request.type} #{response&.status&.code}"
  end
  c.around_http_request(:real?) do |request|
    request.method
    request.proceed
  end
  c.register_request_matcher(:path_without_query) { |r1, r2| r1.uri.split("?").first == r2.uri.split("?").first }
  c.preserve_exact_body_bytes { |message, _cassette| !message.body.valid_encoding? }
  c.debug_logger = $stderr
  c.debug_logger = nil
  c.query_parser = ->(query) { query.split("&") }
end

config = VCR.configuration
dir = config.cassette_library_dir
dir&.length
config.allow_http_connections_when_no_cassette?

matcher = VCR.request_matchers.uri_without_param(:timestamp)
VCR.request_matchers[:method].matches?(VCR::Request.new(:get, "http://a.test/"), VCR::Request.new(:get, "http://b.test/"))

name = VCR.use_cassette("example", record: :once, match_requests_on: [:method, matcher], tag: :auth) do |cassette|
  if cassette
    cassette.recording?
    cassette.http_interactions.remaining_unused_interaction_count
    cassette.new_recorded_interactions.size
    cassette.originally_recorded_at&.year
    cassette.record_mode
    cassette.name
  else
    "ignored"
  end
end
name.upcase

VCR.use_cassettes([{ name: "first" }, { name: "second", options: { erb: { id: 1 } } }]) { 1 + 1 }

cassette = VCR.insert_cassette("manual", exclusive: true, tags: [:no_cookie])
cassette&.file
VCR.current_cassette&.name
VCR.cassettes.map(&:name)
VCR.eject_cassette(skip_no_unused_interactions_assertion: true)

VCR.turned_off(ignore_cassettes: true) { VCR.turned_on? }
VCR.turn_off!
VCR.turn_on!
VCR.real_http_connections_allowed?
VCR.http_interactions.remaining_unused_interaction_count
VCR.version.split(".")

request = VCR::Request.new(:post, "http://example.com/users", '{"name":"a"}', { "Content-Type" => "application/json" })
request.method&.to_s
request.headers["Content-Type"]&.first
response = VCR::Response.new(VCR::ResponseStatus.new(200, "OK"), {}, "ok", "1.1")
response.status.message
response.content_encoding
interaction = VCR::HTTPInteraction.new(request, response)
interaction.recorded_at.year
VCR::HTTPInteraction.from_hash(interaction.to_hash).response.body
interaction.hook_aware.ignored?

serializer = VCR.cassette_serializers[:json]
serializer.deserialize(serializer.serialize({ "a" => 1 }))
serializer.file_extension

begin
  VCR.insert_cassette("example")
  VCR.insert_cassette("example")
rescue ArgumentError, VCR::Errors::CassetteInUseError => e
  e.message
ensure
  VCR.eject_cassette
end

begin
  VCR.use_cassette("unhandled") { nil }
rescue VCR::Errors::UnhandledHTTPRequestError => e
  e.request.uri
  e.request.method
end
