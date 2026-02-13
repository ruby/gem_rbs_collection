class SendMessageJob < ActiveJob::Base
  queue_as :default
  self.queue_adapter = :sidekiq

  before_enqueue do |job|
    # before enqueued
  end

  around_perform :around_task

  def perform(*args)
    # Do something later
  end

  private

  def around_task
    # Do something before
    # yield
    # Do something after
  end
end

SendMessageJob.perform_now
SendMessageJob.logger
SendMessageJob.logger = ActiveSupport::Logger.new(STDOUT)
SendMessageJob.log_arguments = false
SendMessageJob.log_arguments
SendMessageJob.log_arguments?
SendMessageJob.set(queue: :another_queue).perform_later(flag: false)
job = SendMessageJob.new(flag: false)
job.logger
job.logger = ActiveSupport::Logger.new(STDOUT)
