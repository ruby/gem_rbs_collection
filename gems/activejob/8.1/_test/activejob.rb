class SendMessageJob < ActiveJob::Base
  queue_as :default
  self.queue_adapter = :sidekiq

  before_enqueue do |job|
    # before enqueued
  end

  around_perform :around_task

  rescue_from(ActiveJob::DeserializationError) { |exception| exception.message }

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
SendMessageJob.set(queue: :another_queue).perform_later(flag: false)

SendMessageJob.logger = SendMessageJob.logger
SendMessageJob.log_arguments = false

job = SendMessageJob.new(1, "two")
job.job_id.upcase
job.arguments.size
job.executions + 1
job.exception_executions.each_value(&:succ)
job.queue_name.upcase
job.priority&.succ
job.locale&.upcase
job.timezone&.upcase
job.enqueued_at&.iso8601
job.enqueue_error&.message
job.successfully_enqueued?

if (enqueued = SendMessageJob.perform_later(1))
  enqueued.job_id.upcase
end
if (enqueued = SendMessageJob.set(wait: 1.minute).perform_later(1) { |j| j.job_id })
  enqueued.provider_job_id
end
if (enqueued = job.enqueue(queue: :low))
  enqueued.job_id.upcase
end

class SendMessageJobTest < ActiveJob::TestCase
  def test_enqueue
    assert_no_enqueued_jobs
    SendMessageJob.perform_later
    assert_enqueued_jobs 1
    assert_no_performed_jobs
  end
end

SendMessageJob.default_queue_name = "low"
SendMessageJob.default_queue_name.upcase
