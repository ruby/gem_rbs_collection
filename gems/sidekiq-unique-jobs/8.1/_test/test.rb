require "sidekiq-unique-jobs"

SidekiqUniqueJobs.configure do |config|
  config.enabled = false
  config.logger_enabled = false
  config.lock_timeout = 5
  config.lock_ttl = 3600
  config.lock_prefix = "unique"
  config.logger = Logger.new($stdout)
  config.debug_lua = false
  config.max_history = 2_000
  config.reaper = :lua
  config.reaper_count = 500
  config.reaper_interval = 300
  config.reaper_timeout = 150
  config.reaper_resurrector_interval = 1800
  config.reaper_resurrector_enabled = true
  config.lock_info = true
  config.raise_on_config_error = true
  config.digest_algorithm = :modern
  config.on_conflict = :log
  config.locksmith_executor = Object.new
  config.add_lock :my_lock, SidekiqUniqueJobs::Lock::BaseLock
  config.add_strategy :my_strategy, SidekiqUniqueJobs::OnConflict::Strategy
end

SidekiqUniqueJobs.configure(enabled: true, lock_ttl: nil)
SidekiqUniqueJobs.configure { |config| config.on_conflict = { client: :log, server: :reject } }
SidekiqUniqueJobs.config.reaper = :none
SidekiqUniqueJobs.config.reaper = nil
SidekiqUniqueJobs.config.reaper = false

config = SidekiqUniqueJobs.config
# @type var thread_safe_config: SidekiqUniqueJobs::ThreadSafeConfig
thread_safe_config = config
thread_safe_config.class
config.enabled || config.logger_enabled || config.debug_lua || config.lock_info || config.raise_on_config_error
config.reaper_resurrector_enabled
config.lock_timeout&.succ
config.lock_ttl&.succ
config.lock_prefix.upcase
config.logger.info("done")
config.locks.keys.first&.to_proc
config.strategies.key?(:log)
config.max_history + config.reaper_count + config.reaper_interval + config.reaper_timeout + config.reaper_resurrector_interval
config.reaper.to_s
config.digest_algorithm.to_s
config.on_conflict.to_s
config.locksmith_executor
SidekiqUniqueJobs::VERSION.upcase

class MarkForLaterRun < SidekiqUniqueJobs::OnConflict::Strategy
  def call
    item.fetch("args")
    true
  end
end

module Locks
  class LogOnlyLock < SidekiqUniqueJobs::Lock::BaseLock
    def lock
      "jid"
    end

    def execute
      yield
    end
  end
end

SidekiqUniqueJobs.configure do |config|
  config.add_strategy :mark_for_later_run, MarkForLaterRun unless config.strategies.key?(:mark_for_later_run)
  config.add_lock :log_only, Locks::LogOnlyLock
end

class ReportWorker
  include Sidekiq::Job

  sidekiq_options queue: "default", lock: :until_executed, lock_ttl: 3600, on_conflict: :log
  sidekiq_options lock: :until_executing, lock_args_method: ->(args) { args }
  sidekiq_options lock: :until_executing, lock_args_method: :lock_args
  sidekiq_options lock: :while_executing, on_conflict: { client: :log, server: :reject }
  sidekiq_options lock: :until_executed, unique_across_queues: true, lock_timeout: 5

  def perform(*args)
  end
end

# These calls connect to Redis or enqueue jobs, so they are type checked but never run.
# @type var use_redis: ^() -> void
use_redis = -> do
  SidekiqUniqueJobs.validate_worker!(ReportWorker.get_sidekiq_options)

  SidekiqUniqueJobs.use_config(enabled: true) do
    ReportWorker.perform_async(1)
  end
  enabled_result = SidekiqUniqueJobs.use_config(enabled: false) { 1 }
  enabled_result.succ

  SidekiqUniqueJobs.enable!
  SidekiqUniqueJobs.disable!
  SidekiqUniqueJobs.disable! { ReportWorker.perform_async(2) }
  # @type var was_enabled: bool
  was_enabled = SidekiqUniqueJobs.enable! { ReportWorker.perform_async(3) }
  SidekiqUniqueJobs.enabled?
  SidekiqUniqueJobs.disabled?
  SidekiqUniqueJobs.logger.info("hello")
  SidekiqUniqueJobs.logger = Logger.new($stderr)
  SidekiqUniqueJobs.reset!.enabled

  Sidekiq.configure_client do |config|
    config.client_middleware do |chain|
      chain.add SidekiqUniqueJobs::Middleware::Client
    end
  end

  Sidekiq.configure_server do |config|
    config.client_middleware do |chain|
      chain.add SidekiqUniqueJobs::Middleware::Client
    end

    config.server_middleware do |chain|
      chain.add SidekiqUniqueJobs::Middleware::Server
    end

    SidekiqUniqueJobs::Server.configure(config)
  end


  digests = SidekiqUniqueJobs::Digests.new
  digests.delete_by_pattern("*", count: digests.count)
  until digests.delete_by_pattern("*").nil?; end
  # @type var deleted: Integer?
  deleted = digests.delete_by_pattern("uniquejobs:*")
  digests.delete_by_digest("uniquejobs:abc")
  digests.delete_by_digest("uniquejobs:abc", queuetime: true, runtime: false)
  # @type var entries: Hash[String, Float]
  entries = digests.entries(pattern: "uniquejobs:*", count: 100)
  entries = digests.entries
  digests.exist?
  digests.expires?
  digests.ttl + digests.pttl

  expiring_digests = SidekiqUniqueJobs::ExpiringDigests.new
  expiring_digests.delete_by_pattern("*", count: expiring_digests.count)
  expiring_digests.entries.keys.first&.upcase
  SidekiqUniqueJobs::Digests.new("uniquejobs:custom")

  job_item = { "class" => "ReportWorker", "queue" => "default", "args" => [1], "jid" => "abc" }
  # @type var unlocked: String | false
  unlocked = SidekiqUniqueJobs::Unlockable.unlock(job_item)
  unlocked = SidekiqUniqueJobs::Unlockable.unlock!(job_item)
  # @type var removed: bool?
  removed = SidekiqUniqueJobs::Unlockable.delete(job_item)
  # @type var removed_now: bool
  removed_now = SidekiqUniqueJobs::Unlockable.delete!(job_item)

  begin
    SidekiqUniqueJobs.validate_worker!({ "queue" => "default" })
  rescue SidekiqUniqueJobs::InvalidWorker, SidekiqUniqueJobs::UniqueJobsError => e
    e.message
  end
  begin
    SidekiqUniqueJobs.config.add_lock :until_executed, Locks::LogOnlyLock
  rescue SidekiqUniqueJobs::DuplicateLock
    nil
  end
  begin
    SidekiqUniqueJobs.config.add_strategy :log, MarkForLaterRun
  rescue SidekiqUniqueJobs::DuplicateStrategy
    nil
  end
end

SidekiqUniqueJobs.reflect do |on|
  on.lock_failed do |job_hash|
    job_hash.fetch("class")
  end
  on.after_unlock_callback_failed do |job_hash, error|
    job_hash.fetch("jid")
    error&.message
  end
  on.execution_failed do |job_hash, error|
    job_hash.fetch("jid")
    error&.message
  end
  on.unknown_sidekiq_worker { |job_hash| job_hash.fetch("class") }
  on.locked { |job_hash| job_hash.fetch("class") }
  on.reschedule_failed { |job_hash| job_hash.fetch("class") }
  on.rescheduled { |job_hash| job_hash.fetch("class") }
  on.timeout { |job_hash| job_hash.fetch("class") }
  on.unlock_failed { |job_hash| job_hash.fetch("class") }
  on.unlocked { |job_hash| job_hash.fetch("class") }
end

