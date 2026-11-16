require "bugsnag"
require "logger"

Bugsnag.configure do |config|
  config.api_key = "0123456789abcdef0123456789abcdef"
  config.app_version = "1.2.3"
  config.release_stage = "development"
  config.enabled_release_stages = ["production", "staging"]
  config.notify_release_stages = ["production"]
  config.project_root = "/srv/app"
  config.send_environment = false
  config.send_code = false
  config.auto_notify = true
  config.auto_track_sessions = false
  config.auto_capture_sessions = false
  config.timeout = 10
  config.hostname = "web-1"
  config.context = "worker"
  config.app_type = "rails"
  config.delivery_method = :synchronous
  config.proxy_host = "proxy.example.com"
  config.proxy_port = 3128
  config.max_breadcrumbs = 50
  config.vendor_paths = ["vendor/"]
  config.enabled_breadcrumb_types = [Bugsnag::BreadcrumbType::LOG, Bugsnag::BreadcrumbType::ERROR]
  config.endpoints = Bugsnag::EndpointConfiguration.new("https://notify.example.com", "https://sessions.example.com")

  config.ignore_classes << ArgumentError
  config.ignore_classes << ->(exception) { exception.message == "ignored" }
  config.discard_classes << "NoMethodError"
  config.discard_classes << /Timeout/
  config.redacted_keys << "secret"
  config.redacted_keys << /token/
  config.meta_data_filters << "password"

  config.logger = Logger.new(STDOUT)
  config.logger.level = Logger::ERROR

  callback = proc { |_event| nil }
  config.add_on_error(callback)
  config.remove_on_error(callback)
  config.add_on_error(->(event) { event.ignore? })
  config.on_error { |event| event.severity = "info" }

  config.add_on_breadcrumb(->(breadcrumb) { breadcrumb.message != "skip" })
  config.remove_on_breadcrumb(->(_breadcrumb) { true })

  config.add_metadata(:app, { name: "demo" })
  config.add_metadata(:app, :region, "eu")
  config.clear_metadata(:app, :region)
  config.clear_metadata(:app)
end

# @type var logger: Logger
logger = Bugsnag.configuration.logger
Bugsnag.configuration.logger = Logger.new("/dev/null")
logger.info("configured")

# @type var api_key: String?
api_key = Bugsnag.configuration.api_key
api_key&.length
# @type var stages: Array[String]?
stages = Bugsnag.configuration.enabled_release_stages
stages&.size
# @type var ignored: Set[Class | ^(Exception) -> bool | Proc]
ignored = Bugsnag.configuration.ignore_classes
ignored.size
Bugsnag.configuration.discard_classes.size
Bugsnag.configuration.redacted_keys.size
Bugsnag.configuration.meta_data_filters.size
Bugsnag.configuration.notify_release_stages&.size
Bugsnag.configuration.auto_capture_sessions ? 1 : 0
Bugsnag.configuration.auto_track_sessions ? 1 : 0
Bugsnag.configuration.auto_notify ? 1 : 0
Bugsnag.configuration.send_environment ? 1 : 0
Bugsnag.configuration.send_code ? 1 : 0
Bugsnag.configuration.app_version&.length
Bugsnag.configuration.app_type&.length
Bugsnag.configuration.release_stage&.length
Bugsnag.configuration.project_root.to_s.length
Bugsnag.configuration.context&.length
Bugsnag.configuration.hostname.length
Bugsnag.configuration.timeout + 1
Bugsnag.configuration.delivery_method.to_s
Bugsnag.configuration.proxy_host&.length
Bugsnag.configuration.proxy_port&.succ
Bugsnag.configuration.proxy_user&.length
Bugsnag.configuration.proxy_password&.length
Bugsnag.configuration.max_breadcrumbs + 1
Bugsnag.configuration.vendor_paths.size
Bugsnag.configuration.enabled_breadcrumb_types.size
Bugsnag.configuration.endpoints.notify&.length
Bugsnag.configuration.endpoints.sessions&.length
Bugsnag.configuration.metadata.size

begin
  raise "boom"
rescue => e
  Bugsnag.notify(e)

  Bugsnag.notify(e) do |report|
    report.severity = "warning"
    report.add_tab(:deprecation, { reason: "demo" })
    report.add_tab(:note, "text")
    report.remove_tab(:note)
    report.add_metadata(:export, { job: "daily", requested_by: 2 })
    report.add_metadata(:export, :step, "render")
    report.clear_metadata(:export, :step)
    report.clear_metadata(:export)
    report.context = "reports#create"
    report.grouping_hash = "group"
    report.user = { id: 1, email: "user@example.com" }
    report.set_user(nil, nil, "name")
    report.set_user(42, "user@example.com")
    report.set_user("abc")
    report.ignore! if report.severity == "info"
    report.add_feature_flag("beta", "on")
    report.add_feature_flags([Bugsnag::FeatureFlag.new("flag")])
    report.clear_feature_flag("beta")
    report.clear_feature_flags
    report.metadata = { "tab" => { "key" => 1 } }
  end

  Bugsnag.notify(e, false) { |report| report.unhandled = false }
end

Bugsnag.notify("plain message")
Bugsnag.notify(nil, true)

Bugsnag.notify(RuntimeError.new("x")) do |report|
  # @type var tabs: Bugsnag::sections
  tabs = report.metadata
  tabs.size
  report.severity.upcase
  report.user.size
  report.context&.length
  report.api_key&.length
  report.app_type&.length
  report.app_version&.length
  report.release_stage&.length
  report.hostname.length
  report.delivery_method.to_s
  report.grouping_hash&.length
  report.unhandled ? 1 : 0
  report.ignore? ? 1 : 0
  report.errors.size
  report.original_error.to_s
  report.breadcrumbs.each { |breadcrumb| breadcrumb.message.length }
  report.feature_flags.each { |flag| flag.name.length }
  report.api_key = "key"
  report.app_type = "rack"
  report.app_version = "1"
  report.release_stage = "staging"
  report.hostname = "host"
  report.delivery_method = :thread_queue
  report.breadcrumbs = []
end

Bugsnag.notify("event") do |event|
  # @type var typed_event: Bugsnag::Event
  typed_event = event
  typed_event.severity
end

# @type var lambda_callback: ^(Bugsnag::Report) -> untyped
lambda_callback = ->(report) { report.severity = "error" }
Bugsnag.add_on_error(lambda_callback)
Bugsnag.remove_on_error(lambda_callback)
Bugsnag.on_error { |report| report.add_tab(:extra, { a: 1 }) }

Bugsnag.leave_breadcrumb("clicked")
Bugsnag.leave_breadcrumb("loaded", { page: "home", count: 1, cached: true })
Bugsnag.leave_breadcrumb("navigated", { from: "a" }, Bugsnag::BreadcrumbType::NAVIGATION)
Bugsnag.leave_breadcrumb("auto", {}, "log", :auto)

Bugsnag.add_on_breadcrumb(->(breadcrumb) do
  breadcrumb.ignore! if breadcrumb.message == "noisy"
  breadcrumb.type = "manual"
  # @type var meta: Hash[String | Symbol, untyped]?
  meta = breadcrumb.metadata
  breadcrumb.metadata = meta
  breadcrumb.message = "renamed"
  breadcrumb.ignore? ? true : false
  breadcrumb.auto ? 1 : 0
  breadcrumb.timestamp.year
  breadcrumb.to_h.size
  true
end)
breadcrumb_callback = proc { |_breadcrumb| nil }
Bugsnag.add_on_breadcrumb(breadcrumb_callback)
Bugsnag.remove_on_breadcrumb(breadcrumb_callback)

Bugsnag.start_session
Bugsnag.pause_session
Bugsnag.resume_session ? 1 : 0

Bugsnag.metadata.size
Bugsnag.add_metadata(:account, { plan: "free" })
Bugsnag.add_metadata(:account, :id, 5)
Bugsnag.clear_metadata(:account, :id)
Bugsnag.clear_metadata(:account)

Bugsnag.add_feature_flag("checkout", "new")
Bugsnag.add_feature_flag("search")
Bugsnag.add_feature_flags([Bugsnag::FeatureFlag.new("a", "b")])
Bugsnag.clear_feature_flag("search")
Bugsnag.clear_feature_flags

flag = Bugsnag::FeatureFlag.new("x", nil)
flag.name.length
flag.variant&.length
flag.to_h.size
Bugsnag::VERSION.length
