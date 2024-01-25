# Test logging configuration
# Taken from: https://github.com/mperham/sidekiq/wiki/Logging
class YourWorker
  include Sidekiq::Job

  def perform
    logger.info "Things are happening."
    logger.debug "Here's some info: #{hash.inspect}"
  end
end

class YourJob
  include Sidekiq::Job

  def perform
    logger.info "Things are happening."
    logger.debug "Here's some info: #{hash.inspect}"
  end
end

Sidekiq.logger.level = Logger::ERROR
Sidekiq.configure_server do |config|
  config.logger = Sidekiq::Logger.new($stdout, level: Logger::INFO)
end
Sidekiq.configure_server do |config|
  config.logger.level = Logger::WARN
end
Sidekiq.configure_server do |config|
  config.logger.formatter = Sidekiq::Logger::Formatters::JSON.new
end
