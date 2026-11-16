require "lograge"
require "rails"
require "action_controller"

module SampleApp
  class Application < Rails::Application
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.formatter = ->(data) { data.except(:path, :location).to_json }
    config.lograge.formatter = lambda { |data| data.merge(app: "sample") }
    config.lograge.base_controller_class = ["ActionController::API", "ActionController::Base"]
    config.lograge.base_controller_class = "ActionController::API"
    config.lograge.ignore_actions = ["HealthController#show"]
    config.lograge.keep_original_rails_log = false
    config.lograge.log_level = :info
    config.lograge.logger = Logger.new($stdout)

    config.lograge.custom_options = lambda do |event|
      { time: Time.now, frozen: event.frozen? }
    end

    config.lograge.custom_payload do |controller|
      { controller: controller }
    end

    config.lograge.custom_payload do |controller|
      controller ? { host: "example.com" } : nil
    end

    config.lograge.ignore_custom = lambda do |event|
      event.frozen?
    end

    config.lograge.before_format = lambda do |data, payload|
      data.merge(user_agent: payload[:user_agent])
    end
  end
end

options = SampleApp::Application.config.lograge

# @type var enabled: bool?
enabled = options.enabled

# @type var formatter: Lograge::formatter?
formatter = options.formatter
formatter&.call({ status: 200 })

# @type var payload_method: Lograge::custom_payload?
payload_method = options.custom_payload_method
payload_method&.call("controller")&.keys

# @type var custom_options: Lograge::custom_options | Hash[Symbol, untyped] | nil
custom_options = options.custom_options

# @type var before_format: Lograge::before_format?
before_format = options.before_format
before_format&.call({ a: 1 }, { b: 2 })&.keys

# @type var ignore_actions: (String | Array[String])?
ignore_actions = options.ignore_actions

# @type var ignore_custom: Lograge::ignore_test?
ignore_custom = options.ignore_custom

# @type var base_controller_class: (String | Array[String])?
base_controller_class = options.base_controller_class

# @type var logger: Logger?
logger = options.logger
logger&.level

# @type var log_level: Symbol?
log_level = options.log_level

# @type var keep_log: bool?
keep_log = options.keep_original_rails_log

Rails.application.config.lograge.custom_options = { app: "sample" }
Rails.application.config.lograge.custom_payload_method = ->(_controller) { { a: 1 } }
Rails.application.config.lograge.formatter = nil

formatters = [
  Lograge::Formatters::KeyValue.new,
  Lograge::Formatters::KeyValueDeep.new,
  Lograge::Formatters::L2met.new,
  Lograge::Formatters::Cee.new,
  Lograge::Formatters::Json.new,
  Lograge::Formatters::Lines.new,
  Lograge::Formatters::Logstash.new,
  Lograge::Formatters::LTSV.new
]
formatters.each do |f|
  line = f.call({ method: "GET", status: 200 })
  line.upcase
end

graylog = Lograge::Formatters::Graylog2.new.call({ status: 200 })
graylog.keys
raw = Lograge::Formatters::Raw.new.call({ status: 200 })
raw.size

Lograge.formatter = Lograge::Formatters::Raw.new
Lograge.formatter = ->(data) { data.to_s }
Lograge.log_level = :warn
Lograge.logger = Logger.new($stderr)
Lograge.custom_options = ->(_event) { { a: 1 } }
Lograge.custom_options = { a: 1 }
Lograge.before_format = ->(data, _payload) { data }
Lograge.ignore(->(event) { event.frozen? })
level = Lograge.log_level
level.to_s
Lograge::VERSION.upcase

# @type var global_logger: Logger?
global_logger = Lograge.logger
global_logger&.level
# @type var global_formatter: Lograge::formatter?
global_formatter = Lograge.formatter
global_formatter&.call({ status: 200 })

event = ActiveSupport::Notifications::Event.new(
  "process_action.action_controller",
  Time.now,
  Time.now,
  "id",
  { method: "GET", path: "/posts?page=1", format: :html, controller: "PostsController", action: "index", status: 200 }
)

subscriber = Lograge::LogSubscribers::ActionController.new
subscriber.process_action(event)
