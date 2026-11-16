require "sidekiq-scheduler"

Sidekiq.configure_server do |config|
  Sidekiq.schedule = {
    "heartbeat" => {
      "every" => ["1m"],
      "class" => "HeartbeatWorker",
      "queue" => "default"
    },
    cleanup: { cron: "0 3 * * *", class: "CleanupWorker", args: [1, "two"] }
  }

  SidekiqScheduler::Scheduler.instance.reload_schedule!
end

SidekiqScheduler::Scheduler.instance.enabled = false unless Sidekiq.server?

SidekiqScheduler::RedisManager.key_prefix = "my-app"
SidekiqScheduler::RedisManager.key_prefix = nil
SidekiqScheduler::RedisManager.key_prefix&.upcase

# These methods read and write the schedule in Redis, so they are defined but never called
def manage_schedule
  # @type var jobs: Hash[String, Hash[String, untyped]]
  jobs = Sidekiq.reload_schedule!
  jobs = Sidekiq.schedule!
  jobs = Sidekiq.get_schedule
  jobs = Sidekiq.get_all_schedules

  heartbeat = Sidekiq.get_schedule("heartbeat")
  heartbeat.fetch("class") if heartbeat

  # @type var current: Hash[String, Hash[String, untyped]]?
  current = Sidekiq.schedule
  current&.keys&.first&.upcase

  # @type var stored: Hash[String | Symbol, untyped]
  stored = Sidekiq.set_schedule("heartbeat", { "every" => ["1m"], "class" => "HeartbeatWorker" })
  Sidekiq.set_schedule("nightly", { class: "NightlyWorker", every: "15mins", queue: "high", args: "/tmp/file" })
  Sidekiq.remove_schedule("heartbeat")

  SidekiqScheduler::Scheduler.instance.reload_schedule!
  Sidekiq::Scheduler.instance.reload_schedule!
  Sidekiq::Scheduler.reload_schedule!

  # @type var enabled: bool?
  enabled = SidekiqScheduler::Scheduler.instance.enabled
  SidekiqScheduler::Scheduler.instance.enabled = true
  SidekiqScheduler::Scheduler.instance.enabled = nil
end
