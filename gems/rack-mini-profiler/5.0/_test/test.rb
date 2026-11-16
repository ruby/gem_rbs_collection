require "rack-mini-profiler"
require "logger"

config = Rack::MiniProfiler.config

# Behavior
config.authorization_mode = :allow_authorized
config.authorization_mode = :allow_all
config.authorization_mode = :whitelist
mode = config.authorization_mode
mode.to_proc

config.auto_inject = false
config.auto_inject
config.enabled = true
config.enabled
config.disable_caching = false
config.disable_caching
config.pre_authorize_cb = ->(env) { env.key?("REQUEST_METHOD") }
config.pre_authorize_cb = proc { true }
authorize_cb = config.pre_authorize_cb
authorize_cb.call({ "REQUEST_METHOD" => "GET" })
config.user_provider = ->(env) { Rack::Request.new(env).ip }
user_provider = config.user_provider
user_provider.call({ "REMOTE_ADDR" => "127.0.0.1" })
config.skip_paths = ["/assets", %r{\A/cable}]
config.skip_paths = nil
paths = config.skip_paths
paths&.push("/favicon.ico")
paths&.size
config.skip_schema_queries = true
config.skip_schema_queries
config.profile_parameter = "pp"
config.profile_parameter.upcase
config.suppress_encoding = true
config.suppress_encoding
config.enable_advanced_debugging_tools = true
config.enable_advanced_debugging_tools
config.enable_hotwire_turbo_drive_support = true
config.enable_hotwire_turbo_drive_support
config.content_security_policy_nonce = "abc123"
config.content_security_policy_nonce = ->(env, _headers) { String(env["nonce"]) }
config.content_security_policy_nonce = nil
nonce = config.content_security_policy_nonce
nonce.nil?
config.assets_url = ->(name, version, env) { "/assets/#{name}?v=#{version}&m=#{env['REQUEST_METHOD']}" }
config.assets_url = nil
assets_url = config.assets_url
assets_url.nil?
config.base_url_path = "/mini-profiler-resources/"
config.base_url_path.end_with?("/")
config.cookie_path = "/"
config.cookie_path.empty?
config.logger = Logger.new($stdout)
logger = config.logger
logger&.info("profiler")

# Storage
config.storage = Rack::MiniProfiler::RedisStore
config.storage = Rack::MiniProfiler::MemoryStore
config.storage = Rack::MiniProfiler::FileStore
config.storage = Rack::MiniProfiler::MemcacheStore
storage_class = config.storage
storage_class.name
config.storage_options = { url: "redis://localhost:6379", host: "localhost", port: 6379 }
options = config.storage_options
options&.size
config.storage_failure = ->(exception) { exception.message }
config.storage_failure = proc { nil }
failure = config.storage_failure
failure.call(RuntimeError.new("boom"))

redis_store = Rack::MiniProfiler::RedisStore.new(connection: nil, expires_in: 3600, prefix: "mp")
Rack::MiniProfiler::RedisStore.new
Rack::MiniProfiler::RedisStore.new(nil)
Rack::MiniProfiler::MemoryStore.new(expires_in: 60)
Rack::MiniProfiler::MemoryStore.new
# Not called: FileStore creates the directory and MemcacheStore needs dalli
build_file_store = -> { Rack::MiniProfiler::FileStore.new(path: "tmp/mp", expires_in: 60) }
build_memcache_store = -> { Rack::MiniProfiler::MemcacheStore.new(expires_in: 60) }
config.storage_instance = redis_store
config.storage_instance = nil
instance = config.storage_instance
instance.nil?

# Backtraces and SQL
config.backtrace_ignores = [%r{lib/rack/message_bus.rb}]
config.backtrace_ignores = nil
ignores = config.backtrace_ignores
ignores&.push(/quiet_logger/)
ignores&.size
config.backtrace_includes = [%r{\A/?(app|config|lib)}]
includes = config.backtrace_includes
includes&.size
config.backtrace_remove = "/srv/app/"
config.backtrace_remove = /\A\/srv/
config.backtrace_remove = nil
remove = config.backtrace_remove
remove.nil?
config.backtrace_threshold_ms = 5
config.backtrace_threshold_ms = 0.5
config.backtrace_threshold_ms.zero?
config.max_sql_param_length = 100
config.max_sql_param_length.succ
config.skip_sql_param_names = /password/
skip_names = config.skip_sql_param_names
skip_names&.source

# Flamegraphs
config.flamegraph_sample_rate = 0.5
config.flamegraph_sample_rate.zero?
config.flamegraph_mode = :cpu
config.flamegraph_mode.to_proc
config.flamegraph_ignore_gc = true
config.flamegraph_ignore_gc

# UI
config.collapse_results = false
config.collapse_results
config.html_container = "#profiler"
config.html_container.upcase
config.max_traces_to_show = 50
config.max_traces_to_show.succ
config.position = "bottom-right"
config.position.upcase
config.show_children = true
config.show_children
config.show_controls = true
config.show_controls
config.show_total_sql_count = true
config.show_total_sql_count
config.show_trivial = true
config.show_trivial
config.start_hidden = true
config.start_hidden
config.toggle_shortcut = "alt+p"
config.toggle_shortcut.upcase

# Snapshots
config.snapshot_every_n_requests = 100
config.snapshot_every_n_requests.succ
config.max_snapshot_groups = 50
config.max_snapshot_groups.succ
config.max_snapshots_per_group = 15
config.max_snapshots_per_group.succ
config.snapshot_hidden_custom_fields = ["Site"]
config.snapshot_hidden_custom_fields.size
config.snapshots_transport_destination_url = "https://example.com/snapshots"
transport_url = config.snapshots_transport_destination_url
transport_url&.upcase
config.snapshots_transport_auth_key = "secret"
transport_key = config.snapshots_transport_auth_key
transport_key&.upcase
config.snapshots_redact_sql_queries = false
config.snapshots_redact_sql_queries
config.snapshots_transport_gzip_requests = true
config.snapshots_transport_gzip_requests

Rack::MiniProfiler::VERSION.upcase

# Class-level API
Rack::MiniProfiler.reset_config.position.upcase
authorized = Rack::MiniProfiler.authorize_request
authorized.to_s
Rack::MiniProfiler.deauthorize_request.nil?
Rack::MiniProfiler.request_authorized?
Rack::MiniProfiler.discard_results
Rack::MiniProfiler.snapshots_transporter? ? 1 : 2
context = Rack::MiniProfiler.current
context.nil?
field = Rack::MiniProfiler.add_snapshot_custom_field("Application version", "1.0")
field.upcase

sum = Rack::MiniProfiler.step("Adding two elements") { 1 + 2 }
sum.succ
Rack::MiniProfiler.step("no block").nil?
Rack::MiniProfiler.step("with options", { skip: true }) { "done" }.upcase
counted = Rack::MiniProfiler.counter("redis") { "value" }
counted.upcase
Rack::MiniProfiler.counter("redis", 1.5).nil?

class Post
  def title
    "title"
  end

  def self.recent
    []
  end
end

Rack::MiniProfiler.profile_method(Post, :title) { |*args| "executing title #{args.size}" }
Rack::MiniProfiler.profile_method(Post, "title", :counter)
Rack::MiniProfiler.unprofile_method(Post, :title)
Rack::MiniProfiler.counter_method(Post, :title) { "post title" }
Rack::MiniProfiler.counter_method(Post, "title")
Rack::MiniProfiler.uncounter_method(Post, :title)
Rack::MiniProfiler.profile_singleton_method(Post, :recent) { |*_args| "executing recent" }
Rack::MiniProfiler.unprofile_singleton_method(Post, :recent)

# Middleware
# @type var app: ^(Rack::env) -> Rack::response
app = ->(_env) { [200, { "Content-Type" => "text/plain" }, ["ok"]] }
middleware = Rack::MiniProfiler.new(app)
Rack::MiniProfiler.new(app, config)
Rack::MiniProfiler.new(app, { auto_inject: false })
Rack::MiniProfiler.new(app, nil)
status, _headers, _body = middleware.call({ "PATH_INFO" => "/" })
status.to_i

# Rails integration
# Not called: a second initialize! raises
initialize_profiler = -> { Rack::MiniProfilerRails.initialize!(Rails.application) }
Rack::MiniProfilerRails.subscribe("render.view_component") do |name, start, finish, id, payload|
  Rack::MiniProfilerRails.render_notification_handler(
    Rack::MiniProfilerRails.shorten_identifier(String(payload[:identifier])),
    finish,
    start,
    name_as_description: false
  )
  Rack::MiniProfilerRails.render_notification_handler(name + id, finish, start)
end
