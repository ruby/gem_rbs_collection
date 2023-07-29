# Test advanced configurations
# Taken from: https://github.com/mperham/sidekiq/wiki/Advanced-Options
class ImportantWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'critical', retry: true, dead: true, backtrace: false, tags: ['important', 'test']

  def perform
    puts "Doing critical work"
  end
end

Sidekiq.default_worker_options = { 'backtrace' => true }
ImportantWorker.set(queue: :critical).perform_async('name', 15)
