require "sentry-rails"

Sentry.init do |config|
  config.dsn = "https://examplePublicKey@o0.ingest.sentry.io/0"
  config.breadcrumbs_logger = [:active_support_logger]
  config.traces_sample_rate = 0.2

  config.rails.report_rescued_exceptions = false
  config.rails.register_error_subscriber = true
  config.rails.skippable_job_adapters = ["ActiveJob::QueueAdapters::SidekiqAdapter"]
  config.rails.enable_db_query_source = false
  config.rails.db_query_source_threshold_ms = 50
  config.rails.assets_regexp = %r{\A/assets}
  config.rails.active_support_logger_subscription_items = { "sql.active_record" => [:sql, :name] }
  config.rails.active_job_report_on_retry_error = true
  config.rails.active_job_propagate_traces = false
  config.rails.solid_queue_exclude_recurring_tasks = ["cleanup", /\Atmp_/]

  config.rails.structured_logging.enabled = true
  config.rails.structured_logging.subscribers = { active_record: Sentry::Rails::LogSubscribers::ActiveRecordSubscriber }
end

Sentry.init do |config|
  # @type var rails_config: Sentry::Rails::Configuration
  rails_config = config.rails
  # @type var report_rescued: bool
  report_rescued = rails_config.report_rescued_exceptions
  # @type var register: bool
  register = rails_config.register_error_subscriber
  # @type var adapters: Array[String]
  adapters = rails_config.skippable_job_adapters
  # @type var query_source: bool
  query_source = rails_config.enable_db_query_source
  # @type var threshold: Numeric
  threshold = rails_config.db_query_source_threshold_ms
  # @type var assets: Regexp?
  assets = rails_config.assets_regexp
  # @type var items: Hash[String, Array[Symbol]]
  items = rails_config.active_support_logger_subscription_items
  # @type var retry_error: bool
  retry_error = rails_config.active_job_report_on_retry_error
  # @type var propagate: bool
  propagate = rails_config.active_job_propagate_traces
  # @type var excluded_tasks: Array[String | Regexp]
  excluded_tasks = rails_config.solid_queue_exclude_recurring_tasks

  # @type var logging: Sentry::Rails::StructuredLoggingConfiguration
  logging = rails_config.structured_logging
  # @type var logging_enabled: bool
  logging_enabled = logging.enabled?
  # @type var subscribers: Hash[Symbol, Class]
  subscribers = logging.subscribers

  [report_rescued, register, adapters, query_source, threshold, assets, items, retry_error, propagate, excluded_tasks, logging_enabled, subscribers]
end

Sentry.init do |config|
  config.rails.tracing_subscribers.delete(Sentry::Rails::Tracing::ActionViewSubscriber)
  config.rails.tracing_subscribers.delete(Sentry::Rails::Tracing::ActiveSupportSubscriber)
  config.rails.tracing_subscribers.add(Sentry::Rails::Tracing::ActiveRecordSubscriber)

  config.rails.tracing_subscribers.merge([TrimmedViewSubscriber, Class.new(Sentry::Rails::Tracing::ActiveSupportSubscriber)])
end

class TrimmedViewSubscriber < Sentry::Rails::Tracing::ActionViewSubscriber
  def self.subscribe!
    subscribe_to_event(["render_partial.action_view"]) do |event_name, duration, payload|
      next unless Sentry::Rails::Tracing.get_current_transaction

      record_on_current_span(
        op: event_name,
        origin: Sentry::Rails::Tracing::ActionViewSubscriber::SPAN_ORIGIN,
        start_timestamp: payload[Sentry::Rails::Tracing::START_TIMESTAMP_NAME],
        description: payload[:identifier],
        duration: duration
      ) do |span|
        span
      end
    end
  end
end

class CacheSubscriber < Sentry::Rails::Tracing::ActiveSupportSubscriber
  def self.operation_name(event_name)
    # @type var base: String
    base = super
    event_name.start_with?("cache_read") ? "cache.fetch" : base
  end
end

Sentry::Rails::Tracing::ActionViewSubscriber.subscribe!
Sentry::Rails::Tracing::ActionViewSubscriber.unsubscribe!
TrimmedViewSubscriber.subscribe!
TrimmedViewSubscriber.unsubscribe!

# @type var event_names: Array[String]
event_names = Sentry::Rails::Tracing::ActionViewSubscriber::EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveRecordSubscriber::EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveStorageSubscriber::EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveSupportSubscriber::EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveSupportSubscriber::READ_EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveSupportSubscriber::WRITE_EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveSupportSubscriber::REMOVE_EVENT_NAMES +
              Sentry::Rails::Tracing::ActiveSupportSubscriber::FLUSH_EVENT_NAMES
# @type var prefixes: Array[String]
prefixes = [
  Sentry::Rails::Tracing::ActionViewSubscriber::SPAN_PREFIX,
  Sentry::Rails::Tracing::ActiveRecordSubscriber::SPAN_PREFIX
]
# @type var origins: Array[String]
origins = [
  Sentry::Rails::Tracing::ActionViewSubscriber::SPAN_ORIGIN,
  Sentry::Rails::Tracing::ActiveRecordSubscriber::SPAN_ORIGIN,
  Sentry::Rails::Tracing::ActiveStorageSubscriber::SPAN_ORIGIN,
  Sentry::Rails::Tracing::ActiveSupportSubscriber::SPAN_ORIGIN
]
# @type var timestamp_key: Symbol
timestamp_key = Sentry::Rails::Tracing::START_TIMESTAMP_NAME
# @type var version: String
version = Sentry::Rails::VERSION

[event_names, prefixes, origins, timestamp_key, version]

class ReportHandledErrors < Sentry::Rails::ErrorSubscriber
  def report(error, handled:, severity:, context:, source: nil)
    super if handled
  end
end

Sentry::Rails::ErrorSubscriber.new.report(
  RuntimeError.new("boom"),
  handled: true,
  severity: :error,
  context: { user_id: 1 },
  source: "application"
)

class PostsController
  include Sentry::Rails::ControllerMethods

  def show
    capture_message("viewed", { level: :info })
    capture_exception(RuntimeError.new("boom"), { tags: { page: "show" } })
  end
end

Sentry::Rails::ActionCableExtensions::Connection
