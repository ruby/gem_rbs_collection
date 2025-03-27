require "sidekiq-cron"

Sidekiq::Cron.configure do |config|
  config.cron_schedule_file = "config/users_schedule.yml"
end

# return array of all jobs
Sidekiq::Cron::Job.all

# return one job by its unique name - case sensitive
Sidekiq::Cron::Job.find "Job Name"

# return one job by its unique name - you can use hash with 'name' key
Sidekiq::Cron::Job.find name: "Job Name"


# destroy all jobs
Sidekiq::Cron::Job.destroy_all!

# destroy job by its name
Sidekiq::Cron::Job.destroy "Job Name"

# destroy found job
Sidekiq::Cron::Job.find('Job name')&.destroy


job = Sidekiq::Cron::Job.find('Job name')

if job
  # disable cron scheduling
  job.disable!

  # enable cron scheduling
  job.enable!

  # get status of job:
  job.status
  # => enabled/disabled

  # enqueue job right now!
  job.enqueue!
end
