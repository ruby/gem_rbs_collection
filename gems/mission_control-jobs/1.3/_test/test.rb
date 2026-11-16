require "mission_control/jobs"

# @type var version: String
version = MissionControl::Jobs::VERSION

# @type var engine: MissionControl::Jobs::Engine
engine = MissionControl::Jobs::Engine.instance
engine.root

MissionControl::Jobs.base_controller_class = "AdminController"
# @type var controller_name: String
controller_name = MissionControl::Jobs.base_controller_class
controller_name.upcase

MissionControl::Jobs.http_basic_auth_enabled = false
# @type var auth_enabled: bool
auth_enabled = MissionControl::Jobs.http_basic_auth_enabled

MissionControl::Jobs.http_basic_auth_user = ENV.fetch("MISSION_CONTROL_USER")
MissionControl::Jobs.http_basic_auth_password = ENV.fetch("MISSION_CONTROL_PASSWORD")
MissionControl::Jobs.http_basic_auth_user&.upcase
MissionControl::Jobs.http_basic_auth_password&.upcase

MissionControl::Jobs.show_console_help = false
# @type var help: bool
help = MissionControl::Jobs.show_console_help

MissionControl::Jobs.adapters = [:resque, :solid_queue]
MissionControl::Jobs.adapters = Set[:async]
MissionControl::Jobs.adapters.include?(:async)

MissionControl::Jobs.logger = Logger.new($stdout)
MissionControl::Jobs.logger.info("started")

MissionControl::Jobs.delay_between_bulk_operation_batches = 2
MissionControl::Jobs.delay_between_bulk_operation_batches = 5.seconds
MissionControl::Jobs.delay_between_bulk_operation_batches = 2
MissionControl::Jobs.delay_between_bulk_operation_batches.to_s

MissionControl::Jobs.internal_query_count_limit = 1_000
# @type var limit: Integer
limit = MissionControl::Jobs.internal_query_count_limit

MissionControl::Jobs.scheduled_job_delay_threshold = 1.minute
MissionControl::Jobs.scheduled_job_delay_threshold = 90
MissionControl::Jobs.scheduled_job_delay_threshold.to_s

MissionControl::Jobs.backtrace_cleaner = Rails::BacktraceCleaner.new
MissionControl::Jobs.backtrace_cleaner&.clean([])

MissionControl::Jobs.back_to_main_app_path = "/admin"
MissionControl::Jobs.back_to_main_app_path&.length

MissionControl::Jobs.filter_arguments = ["password"]
MissionControl::Jobs.filter_arguments.first

MissionControl::Jobs.applications = MissionControl::Jobs::Applications.new
adapter = ActiveJob::QueueAdapters::AsyncAdapter.new
# @type var application: MissionControl::Jobs::Application
application = MissionControl::Jobs.applications.add("billing", { "primary" => adapter })
MissionControl::Jobs.applications.add(:billing, { "primary" => [adapter, Rails::BacktraceCleaner.new] })
MissionControl::Jobs.applications.add("empty")
# @type var elements: MissionControl::Jobs::IdentifiedElements
elements = MissionControl::Jobs.applications
# @type var app_name: String
app_name = application.name
application.id.upcase
application.to_param.upcase
application.to_s.upcase
