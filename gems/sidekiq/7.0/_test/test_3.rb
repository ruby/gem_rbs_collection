# Test error handling
# Taken from: https://github.com/mperham/sidekiq/wiki/Error-Handling
Sidekiq.configure_server do |config|
    config.error_handlers << proc { |ex,ctx_hash| puts "#{ex} exception: #{ctx_hash} context" }
end

class LessRetryableWorker
  include Sidekiq::Job
  sidekiq_options retry: 5 # Only five retries and then to the Dead Job Queue

  def perform
  end
end

class LessRetryableJob
  include Sidekiq::Job
  sidekiq_options retry: 5 # Only five retries and then to the Dead Job Queue

  def perform
  end
end

class NonRetryableWorker
  include Sidekiq::Job
  sidekiq_options retry: false # job will be discarded if it fails

  def perform
  end
end

class NonRetryableJob
  include Sidekiq::Job
  sidekiq_options retry: false # job will be discarded if it fails

  def perform
  end
end

class NoDeathWorker
  include Sidekiq::Job
  sidekiq_options retry: 5, dead: false # will retry 5 times and then disappear

  def perform
  end
end

class NoDeathJob
  include Sidekiq::Job
  sidekiq_options retry: 5, dead: false # will retry 5 times and then disappear

  def perform
  end
end

class WorkerWithCustomRetry
  include Sidekiq::Job
  sidekiq_options retry: 5

  # The current retry count and exception is yielded. The return value of the
  # block must be an integer. It is used as the delay, in seconds. A return value
  # of nil will use the default.
  sidekiq_retry_in do |count, exception|
    case exception
    when Object
      10 * (count + 1) # (i.e. 10, 20, 30, 40, 50)
    end
  end

  def perform
  end
end

class JobWithCustomRetry
  include Sidekiq::Job
  sidekiq_options retry: 5

  # The current retry count and exception is yielded. The return value of the
  # block must be an integer. It is used as the delay, in seconds. A return value
  # of nil will use the default.
  sidekiq_retry_in do |count, exception|
    case exception
    when Object
      10 * (count + 1) # (i.e. 10, 20, 30, 40, 50)
    end
  end

  def perform
  end
end

class FailingWorker
  include Sidekiq::Job

  sidekiq_retries_exhausted do |msg, ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform
    raise "or I don't work"
  end
end

class FailingJob
  include Sidekiq::Job

  sidekiq_retries_exhausted do |msg, ex|
    Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform
    raise "or I don't work"
  end
end

# this goes in your initializer
Sidekiq.configure_server do |config|
  config.death_handlers << -> (job, ex) do
    puts "Error!"
  end
end
