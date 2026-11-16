require "active_support"
require "active_support/core_ext/integer/time"
require "rack/attack"

Rack::Attack.enabled = false
# @type var enabled: bool
enabled = Rack::Attack.enabled
enabled.!

Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new
Rack::Attack.cache.prefix = "myapp"
# @type var prefix: String
prefix = Rack::Attack.cache.prefix
prefix.upcase
# @type var store: untyped
store = Rack::Attack.cache.store
store ? 1 : 0

Rack::Attack.safelist("allow localhost") do |req|
  req.ip == "127.0.0.1"
end

Rack::Attack.safelist_ip("10.0.0.0/8")
Rack::Attack.blocklist_ip("203.0.113.0/24")

Rack::Attack.blocklist("block bad agents") do |req|
  req.user_agent.to_s.start_with?("BadBot")
end

Rack::Attack.blocklist do |req|
  Rack::Attack::Fail2Ban.filter("pentest:#{req.ip}", maxretry: 3, findtime: 10 * 60, bantime: 5 * 60) do
    req.path.include?("/etc/passwd")
  end
end

Rack::Attack.blocklist("allow2ban") do |req|
  Rack::Attack::Allow2Ban.filter(req.ip, maxretry: 10, findtime: 60, bantime: 3600) do
    req.path.start_with?("/login")
  end
end

Rack::Attack.blocklist("fail2ban with durations") do |req|
  Rack::Attack::Fail2Ban.filter(req.ip, maxretry: 3, findtime: 1.minute, bantime: 1.hour) do
    req.path.start_with?("/admin")
  end
end

# @type var throttle: Rack::Attack::Throttle
throttle = Rack::Attack.throttle("req/ip", limit: 300, period: 5 * 60) do |req|
  req.ip
end
throttle.name
throttle.type.to_s

Rack::Attack.throttle("logins/email", limit: 5, period: 20, type: :throttle) do |req|
  email = req.params["email"] # @type var email: String?
  email.to_s.downcase if req.path == "/login" && req.post?
end

Rack::Attack.throttle("dynamic", limit: ->(req) { req.ip == "127.0.0.1" ? 100 : 10 }, period: ->(_req) { 60 }) do |req|
  req.ip
end

Rack::Attack.throttle("by proc", limit: proc { |_req| 100 }, period: proc { |_req| 60 }) do |req|
  req.ip
end

Rack::Attack.throttle("by duration", limit: 20, period: 1.hour) do |req|
  req.ip
end

# @type var track: Rack::Attack::Track
track = Rack::Attack.track("special_agent") do |req|
  req.user_agent == "SpecialAgent"
end
# @type var filter: Rack::Attack::Check | Rack::Attack::Throttle
filter = track.filter

Rack::Attack.track("heavy", limit: 10, period: 60) do |req|
  req.ip
end

Rack::Attack.throttled_response_retry_after_header = true
# @type var retry_after: bool
retry_after = Rack::Attack.throttled_response_retry_after_header
retry_after.!

Rack::Attack.throttled_responder = lambda do |req|
  [429, { "content-type" => "text/plain", "retry-after" => "10" }, ["Retry later #{req.ip}\n"]]
end

Rack::Attack.blocklisted_responder = lambda do |_req|
  [403, { "content-type" => "text/plain" }, ["Forbidden\n"]]
end

# @type var throttled_responder: Rack::Attack::responder
throttled_responder = Rack::Attack.throttled_responder
# @type var blocklisted_responder: Rack::Attack::responder
blocklisted_responder = Rack::Attack.blocklisted_responder
request = Rack::Attack::Request.new({ "REQUEST_METHOD" => "GET", "PATH_INFO" => "/", "REMOTE_ADDR" => "127.0.0.1" })
# @type var response: Rack::response
response = throttled_responder.call(request)
response = blocklisted_responder.call(request)
response[0].to_i

# @type var count: Integer
count = Rack::Attack.cache.count("rate_limit/key", 60)
count = Rack::Attack.cache.count("rate_limit/key", 1.minute)
count.succ

Rack::Attack.cache.write("key", 1, 60)
Rack::Attack.cache.write("key", 1, 1.hour)
Rack::Attack.cache.read("key")
Rack::Attack.cache.delete("key")
Rack::Attack.cache.reset_count("key", 60)
Rack::Attack.cache.reset!
Rack::Attack.reset!

Rack::Attack.throttles.each do |name, t|
  name.to_s
  # @type var period: Integer | Proc | ^(Rack::Attack::Request) -> Integer
  period = t.period
  # @type var limit: Rack::Attack::limit
  limit = t.limit
  t.name.to_s
  t.type.to_s
  limit.is_a?(Integer)
  period.is_a?(Integer)
end

Rack::Attack.safelists.each_value do |s|
  s.name&.to_s
  s.type&.to_s
end

Rack::Attack.blocklists.each_value do |b|
  b.name&.to_s
end

Rack::Attack.tracks.each_value do |t|
  t.filter
end

# @type var banned: bool
banned = Rack::Attack::Fail2Ban.banned?("1.2.3.4")
banned.!
Rack::Attack::Fail2Ban.reset("1.2.3.4", findtime: 60)

Rack::Attack.notifier = ActiveSupport::Notifications
# @type var notifier: Rack::Attack::_Notifier?
notifier = Rack::Attack.notifier
notifier&.instrument("example.rack_attack", { request: request })
Rack::Attack.throttle_discriminator_normalizer = ->(discriminator) { discriminator }
Rack::Attack.throttle_discriminator_normalizer = nil
# @type var normalizer: (^(untyped) -> untyped)?
normalizer = Rack::Attack.throttle_discriminator_normalizer

class LocalProxy < Rack::Attack::StoreProxy::RedisCacheStoreProxy
end

Rack::Attack.cache.store = LocalProxy.new(ActiveSupport::Cache::MemoryStore.new)

if defined?(::Redis)
  Rack::Attack.cache.store = Rack::Attack::StoreProxy::RedisProxy.new(Object.new)
end

# @type var config: Rack::Attack::Configuration
config = Rack::Attack.configuration
config.safelist("x") { |req| req.get? }
config.blocklist("y") { |req| req.post? }
config.safelist_ip("127.0.0.1")
config.blocklist_ip("192.0.2.1")
config.throttle("z", limit: 1, period: 1) { |req| req.ip }
config.track("w", limit: 1, period: 1) { |req| req.ip }
config.safelists.size
config.blocklists.size
config.throttles.size
config.tracks.size
config.throttled_response_retry_after_header = false
config.throttled_responder = config.blocklisted_responder
config.clear_configuration
Rack::Attack.clear_configuration
