require "strong_migrations"
require "active_record"

# Configuration
StrongMigrations.start_after = 20250101000000
start_after = StrongMigrations.start_after
start_after.succ

StrongMigrations.target_version = 16
StrongMigrations.target_version = "18"
StrongMigrations.target_version = 16.3
StrongMigrations.target_version = { primary: 16, catalog: 18 }
StrongMigrations.target_version = nil
# @type var target: StrongMigrations::target_version?
target = StrongMigrations.target_version
target.to_s

StrongMigrations.target_postgresql_version = 15
StrongMigrations.target_postgresql_version
StrongMigrations.target_mysql_version = "8.0.12"
StrongMigrations.target_mysql_version
StrongMigrations.target_mariadb_version = "10.5"
StrongMigrations.target_mariadb_version
StrongMigrations.target_sql_mode = "STRICT_ALL_TABLES"
sql_mode = StrongMigrations.target_sql_mode
sql_mode&.upcase

StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.lock_timeout = 10
lock_timeout = StrongMigrations.lock_timeout
lock_timeout&.to_i
StrongMigrations.statement_timeout = 1.hour
statement_timeout = StrongMigrations.statement_timeout
statement_timeout&.to_i
StrongMigrations.transaction_timeout = 5.minutes
transaction_timeout = StrongMigrations.transaction_timeout
transaction_timeout&.to_i
StrongMigrations.lock_timeout_limit = 30
StrongMigrations.lock_timeout_limit = false
limit = StrongMigrations.lock_timeout_limit
limit.is_a?(Numeric)
StrongMigrations.lock_timeout_retries = 3
retries = StrongMigrations.lock_timeout_retries
retries.succ
StrongMigrations.lock_timeout_retry_delay = 10.seconds
StrongMigrations.lock_timeout_retry_delay = 10
delay = StrongMigrations.lock_timeout_retry_delay
delay.to_i

StrongMigrations.auto_analyze = true
auto_analyze = StrongMigrations.auto_analyze
auto_analyze ? 1 : 0
StrongMigrations.check_down = true
check_down = StrongMigrations.check_down
check_down ? 1 : 0
StrongMigrations.safe_by_default = true
safe_by_default = StrongMigrations.safe_by_default
safe_by_default ? 1 : 0
StrongMigrations.alphabetize_schema = true
alphabetize = StrongMigrations.alphabetize_schema
alphabetize ? 1 : 0
StrongMigrations.remove_invalid_indexes = true
remove_invalid = StrongMigrations.remove_invalid_indexes
remove_invalid ? 1 : 0

StrongMigrations.error_messages[:add_column_default] = "Your custom instructions"
messages = StrongMigrations.error_messages
messages.size
StrongMigrations.error_messages = { add_index: "No more indexes" }

# Checks
StrongMigrations.add_check do |method, args|
  if method == :add_index && args.size > 1
    stop! "No more indexes on the users table"
  end
end
StrongMigrations.add_check do |method, _args|
  stop!("Not allowed", header: "Custom header") if method == :drop_table
end

StrongMigrations.enable_check(:remove_index)
StrongMigrations.enable_check(:remove_index, start_after: 20250101000000)
StrongMigrations.disable_check(:add_index)

StrongMigrations.skip_database(:catalog)
StrongMigrations.skipped_databases << "archive"
skipped = StrongMigrations.skipped_databases
skipped.size
StrongMigrations.skipped_databases = []

StrongMigrations::VERSION.upcase

# Errors
begin
  raise StrongMigrations::UnsafeMigration, "unsafe"
rescue StrongMigrations::Error => e
  e.message.upcase
end
StrongMigrations::UnsupportedVersion.new("old").message.upcase

# Migration helpers
class AddNameToUsers < ActiveRecord::Migration::Current
  def change
    result = safety_assured { 42 }
    result.succ
    safety_assured { say "removing users.name" }
  end
end

class StopMigration < ActiveRecord::Migration::Current
  def change
    stop! "Do not run"
  end
end
