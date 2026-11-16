require "honeybadger"
require "logger"

class BillingAccount
  def to_honeybadger_context
    { user_id: 1, plan: "pro" }
  end
end

Honeybadger.configure do |config|
  config.api_key = "hbp_example"
  config.env = "staging"
  config.revision = "be2ceb6"
  config.root = "/srv/app"
  config.hostname = "web-1"
  config.report_data = false
  config.debug = true
  config.sync = false
  config.send_data_at_exit = false
  config.development_environments = ["development", "test"]
  config.plugins = [:rails, "sidekiq"]
  config.skipped_plugins = [:net_http]
  config.logger = Logger.new($stdout)

  config.exceptions.enabled = true
  # @type var default_ignore: Array[String]
  default_ignore = Honeybadger::Config::DEFAULTS[:"exceptions.ignore"]
  config.exceptions.ignore = default_ignore | [ArgumentError, "Custom::Error"]
  config.exceptions.ignore_only = nil
  config.exceptions.ignored_user_agents = ["Pingdom", /bot/i]
  config.exceptions.rescue_rake = true
  config.exceptions.notify_at_exit = false
  config.exceptions.source_radius = 3
  config.exceptions.backtrace_limit = 20
  config.exceptions.local_variables = false
  config.exceptions.unwrap = true

  config.request.filter_keys += ["authorization", :token, /secret/i]
  # @type var scrub_card: ^(String, String) -> void
  scrub_card = ->(key, value) { value.replace("[FILTERED]") if key == "card" }
  config.request.filter_keys += [scrub_card]
  config.request.disable_session = true
  config.request.disable_params = false
  config.request.disable_environment = false
  config.request.disable_url = false

  config.breadcrumbs.enabled = false
  config.breadcrumbs.active_support_notifications = { "sql.active_record" => { exclude_when: nil } }
  config.insights.enabled = false
  config.events.ignore = [{ event_type: "sql.active_record" }, /cache_/, "noisy"]
  config.events.sample_rate = 50
  config.events.batch_size = 500
  config.logging.path = "log/honeybadger.log"
  config.logging.level = "WARN"
  config.connection.host = "api.honeybadger.io"
  config.connection.port = 443
  config.connection.secure = true
  config.connection.http_open_timeout = 2
  config.connection.http_read_timeout = 5

  config.sidekiq.attempt_threshold = 10
  config.active_job.attempt_threshold = 3
  config.delayed_job.attempt_threshold = 2
  config.shoryuken.attempt_threshold = 4
  config.faktory.attempt_threshold = 5

  config.before_notify do |notice|
    notice.halt! if notice.error_class == "SignalException"
    inspect_notice(notice)
  end

  config.before_notify(->(notice) { notice.halt! if notice.error_class == "Timeout::Error" })
  config.before_notify(proc { |_notice| nil })

  config.after_notify do |notice, response|
    next unless response.code == 413

    Honeybadger.event("honeybadger.notice_rejected", { notice_id: notice.id, reason: response.error_message })

    code = response.code
    response.body&.upcase
    response.message&.upcase
    response.error&.upcase
    response.success?
    response.error_message&.upcase
  end

  config.before_event do |event|
    event.halt! if event.event_type == "internal"
    inspect_event(event)
  end
end

# @type var api_key: String?
api_key = Honeybadger.config.get(:api_key)
Honeybadger.config.set(:before_notify, [])
Honeybadger.config[:"breadcrumbs.enabled"]
Honeybadger.config[:report_data] = false
# @type var settings: Hash[Symbol, untyped]
settings = Honeybadger.config.to_hash(true)
settings = Honeybadger.config.to_h
Honeybadger::VERSION.upcase

# @type var agent: Honeybadger::Agent
agent = Honeybadger.context(user_id: 5, user_email: "a@example.com")
Honeybadger.context({ "tags" => "vip" })
Honeybadger.context(BillingAccount.new)
# @type var block_result: String
block_result = Honeybadger.context({ job_id: 9 }) { "done" }
agent = Honeybadger.context
# @type var current_context: Hash[Symbol | String, untyped]?
current_context = Honeybadger.get_context
agent = Honeybadger.event_context(request_id: "r1")
Honeybadger.event_context({ region: "eu" }) { 1 }.succ
# @type var current_event_context: Hash[Symbol | String, untyped]?
current_event_context = Honeybadger.get_event_context
Honeybadger.clear!

Honeybadger.add_breadcrumb("Email sent", metadata: { to: "a@example.com" }, category: "mail")
agent = Honeybadger.add_breadcrumb("Started")

def report_errors
  # @type var notice_id: String | false
  notice_id = Honeybadger.notify(RuntimeError.new("boom"))
  notice_id = Honeybadger.notify("Something odd happened")
  notice_id = Honeybadger.notify(error_class: "Billing::Failure", error_message: "card declined")
  notice_id = Honeybadger.notify({ error_class: "Billing::Failure" })
  notice_id = Honeybadger.notify
  notice_id = Honeybadger.notify(
    StandardError.new("bad input"),
    context: { user_id: 1 },
    params: { "q" => "x" },
    session: {},
    cgi_data: { "HTTP_HOST" => "example.com" },
    details: { shard: 2 },
    tags: "billing, urgent",
    fingerprint: "billing-failure",
    component: "invoices",
    action: "create",
    url: "https://example.com/invoices",
    api_key: "other",
    force: true,
    sync: true
  )
  notice_id = Honeybadger.notify(
    "with extras",
    exception: IOError.new("closed"),
    error_class: "IOError",
    error_message: "closed stream",
    backtrace: ["app/models/user.rb:10:in 'save'"],
    cause: nil,
    parameters: { id: 1 },
    controller: "users",
    tags: ["a", "b"]
  )
  # @type var opts: Hash[Symbol, untyped]
  opts = { error_class: "Dynamic", context: { a: 1 } }
  notice_id = Honeybadger.notify(RuntimeError.new("splat"), **opts)
end

def report_events_and_deploys
  Honeybadger.event("user_signed_up", user_id: 123)
  Honeybadger.event("order_placed", { total: 10 })
  Honeybadger.event(event_type: "user_signed_up", user_id: 123)

  # @type var checked: bool
  checked = Honeybadger.check_in("1MqIo1")
  checked = Honeybadger.track_deployment(environment: "production", revision: "be2ceb6", local_username: "deployer", repository: "https://example.com/repo")
  checked = Honeybadger.track_deployment
  Honeybadger.flush
  # @type var flushed: Integer
  flushed = Honeybadger.flush { 42 }
  Honeybadger.stop
  Honeybadger.stop(true)
end

def report_with_own_agent
  own_agent = Honeybadger::Agent.new(api_key: "hbp_second")
  own_agent = Honeybadger::Agent.new
  own_agent = Honeybadger::Agent.new(Honeybadger.config)
  own_agent.notify("from the agent")
  own_agent.context(user_id: 1)
  own_agent.clear!
  own_agent.configure { |config| config.api_key = "hbp_third" }
  own_agent.config.get(:env)
end

Honeybadger::Plugin.register(:billing) do
  requirement { defined?(Billing) }
  requirement { config[:"billing.enabled"] }

  execution do
    logger.info("billing plugin loaded")
    Honeybadger.add_breadcrumb("billing loaded")
  end

  collect(interval: 10) do
    gauge("billing.open_invoices") { 3 }
  end

  collect do
    gauge("billing.pending", -> { 1 })
  end
end

# @type var default_ignored: Array[String | Class]
default_ignored = []
Honeybadger.configure do |config|
  config.exceptions.ignore = default_ignored
  # @type var enabled: bool
  enabled = config.exceptions.enabled
  # @type var threshold: Integer
  threshold = config.sidekiq.attempt_threshold
  # @type var key: String?
  key = config.api_key
  # @type var current_env: String?
  current_env = config.env
  config.exceptions.ignore_only&.size
  config.exceptions.ignored_user_agents.size
  config.exceptions.rescue_rake
  config.exceptions.notify_at_exit
  config.exceptions.source_radius.succ
  config.exceptions.backtrace_limit.succ
  config.exceptions.local_variables
  config.exceptions.unwrap
  config.request.filter_keys.size
  config.request.disable_session
  config.request.disable_params
  config.request.disable_environment
  config.request.disable_url
  config.breadcrumbs.enabled
  config.breadcrumbs.active_support_notifications.size
  config.insights.enabled
  config.events.ignore.size
  config.events.sample_rate.succ
  config.events.batch_size.succ
  config.logging.path&.upcase
  config.logging.level.upcase
  config.connection.host.upcase
  config.connection.port&.succ
  config.connection.secure
  config.connection.http_open_timeout.succ
  config.connection.http_read_timeout.succ
  config.active_job.attempt_threshold.succ
  config.delayed_job.attempt_threshold.succ
  config.shoryuken.attempt_threshold.succ
  config.faktory.attempt_threshold.succ
  config.revision&.upcase
  config.root.upcase
  config.hostname.upcase
  config.report_data
  config.debug
  config.sync
  config.send_data_at_exit
  config.development_environments.size
  config.plugins&.size
  config.skipped_plugins&.size
  config.logger.warn("logger")
  config.to_h
end

def inspect_notice(notice)
  notice.fingerprint = notice.error_message.include?("timeout") ? "timeout" : nil
  notice.tags = "slow, db"
  notice.tags = ["api", "v2"]
  # @type var id: String
  id = notice.id
  # @type var wrapped: Exception?
  wrapped = notice.exception
  wrapped = notice.cause
  # @type var tag_list: Array[String]
  tag_list = notice.tags
  # @type var lines: Array[String]
  lines = notice.backtrace
  notice.backtrace = lines
  # @type var fp: String?
  fp = notice.fingerprint
  notice.error_class.upcase
  notice.error_message.upcase
  notice.context[:user_id]
  notice.context = {}
  notice.cgi_data = {}
  notice.params = {}
  notice.session = {}
  notice.details = {}
  notice.component&.upcase
  notice.component = "x"
  notice.action&.upcase
  notice.action = "y"
  notice.url&.upcase
  notice.url = "https://example.com"
  notice.api_key&.upcase
  notice.api_key = "k"
  notice.request_id&.upcase
  notice.error_class = "E"
  notice.error_message = "m"
  notice.fingerprint = "f"
  notice.tags = "t"
end

def inspect_event(event)
  event[:service] = "web"
  event.ts.upcase
  event.event_type&.upcase
  event.payload.keys
  event[:a]
  event[:a] = { b: 1 }
  event.dig(:a, :b)
  event.delete(:a)
end
