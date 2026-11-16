require "active_support/all"
require "logger"
require "pathname"
require "prosopite"
require "prosopite/middleware/rack"

class ReportCollector
  def warn(report)
    report.length
  end
end

Prosopite.raise = true
Prosopite.raise = nil
Prosopite.rails_logger = true
Prosopite.stderr_logger = false
Prosopite.prosopite_logger = true
Prosopite.prosopite_logger = "log/prosopite.log"
Prosopite.prosopite_logger = Pathname("log/prosopite.log")
Prosopite.prosopite_logger = ReportCollector.new
Prosopite.prosopite_logger = nil
Prosopite.custom_logger = ReportCollector.new
Prosopite.custom_logger = Logger.new($stderr)
Prosopite.custom_logger = false
Prosopite.backtrace_cleaner = ActiveSupport::BacktraceCleaner.new
# @type var cleaner: ActiveSupport::BacktraceCleaner
cleaner = Prosopite.backtrace_cleaner

Prosopite.enabled = false
Prosopite.suggest_fixes = true
Prosopite.ignore_pauses = false
Prosopite.add_footer = true
Prosopite.browser_console = true
Prosopite.github_annotations = true
Prosopite.json_report = "tmp/prosopite.jsonl"
Prosopite.json_report = Pathname("tmp/prosopite.jsonl")
Prosopite.json_report = nil
Prosopite.todo_file = Pathname("prosopite_todo.yml")
Prosopite.todo_file = ".prosopite_todo.yml"
Prosopite.record_todo = false
Prosopite.display_query_count = true
Prosopite.display_max_n_queries = 3
Prosopite.display_max_n_queries = nil

Prosopite.allow_stack_paths = ["app/models/legacy_report.rb", %r{lib/generated/}]
Prosopite.focus_stack_paths = ["app"]
Prosopite.ignore_queries = [/regex_match/, "SELECT * from EXACT_STRING_MATCH"]
Prosopite.ignore_location_paths = ["sorbet-runtime", /observability/]
Prosopite.ignore_location_paths = nil
Prosopite.min_n_queries = 5
Prosopite.min_duration_ms = 50
Prosopite.min_duration_ms = 0.5
Prosopite.sample_rate = 0.01
Prosopite.sample_rate = nil

# @type var allow_paths: Array[String | Regexp]?
allow_paths = Prosopite.allow_stack_paths
# @type var focus_paths: Array[String | Regexp]?
focus_paths = Prosopite.focus_stack_paths
# @type var ignored: Array[String | Regexp]?
ignored = Prosopite.ignore_queries
# @type var ignored_locations: Array[String | Regexp]?
ignored_locations = Prosopite.ignore_location_paths
# @type var min_queries: Integer?
min_queries = Prosopite.min_n_queries
# @type var min_duration: Numeric?
min_duration = Prosopite.min_duration_ms
# @type var rate: Float?
rate = Prosopite.sample_rate
# @type var max_queries: Integer?
max_queries = Prosopite.display_max_n_queries
# @type var show_count: bool?
show_count = Prosopite.display_query_count
# @type var footer: bool?
footer = Prosopite.add_footer
# @type var console: bool?
console = Prosopite.browser_console
# @type var annotations: bool?
annotations = Prosopite.github_annotations
# @type var report: (String | Pathname)?
report = Prosopite.json_report
# @type var todo: String?
todo = Prosopite.todo_file
# @type var recording: bool?
recording = Prosopite.record_todo

Prosopite.local_raise?
Prosopite.start_raise
Prosopite.stop_raise

Prosopite.scan
Prosopite.scan("GET /users")
finished = Prosopite.finish
if finished
  # @type var notification: Prosopite::notification
  notification = finished.fetch(0)
  notification[:queries].first.upcase
  notification[:call_stack].first.upcase
  notification[:fixes].first.upcase
  notification[:fingerprint].upcase
  notification[:duration_ms].round(1)
end

# @type var count: Integer
count = Prosopite.scan do
  1
end
Prosopite.scan("ImportJob 1") { :done }.to_proc

Prosopite.pause
Prosopite.resume
# @type var paused: String
paused = Prosopite.pause { "result" }
Prosopite.pause_during("factory_bot.run_factory")

found = Prosopite.n_plus_one_queries { Prosopite.pause { 1 } }
found.each do |n_plus_one|
  n_plus_one[:queries].size
  n_plus_one[:context].to_s
end

begin
  raise Prosopite::NPlusOneQueriesError, "N+1 queries detected"
rescue Prosopite::NPlusOneQueriesError => e
  e.message.upcase
end

Prosopite::VERSION.upcase

Prosopite::Middleware::Rack.is_a?(Class)

# Sidekiq has to be loaded before the middleware file, so it is required when called
class SidekiqLoader
  def load_middleware
    require "prosopite/middleware/sidekiq"
    Prosopite::Middleware::Sidekiq.is_a?(Class)
  end
end
