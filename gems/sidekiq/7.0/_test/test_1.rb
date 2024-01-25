# Test fundamental APIs
# Taken from: https://github.com/mperham/sidekiq/wiki/Getting-Started
class HardWorker
  include Sidekiq::Job

  def perform(name, count)
    puts "Performing #{name} #{count} times"
  end
end
HardWorker.perform_async('bob', 5)
HardWorker.perform_at(Time.now + 5*60, 'bob', 5)

class HardJob
  include Sidekiq::Job

  def perform(name, count)
    puts "Performing #{name} #{count} times"
  end
end
HardJob.perform_async('bob', 5)
HardJob.perform_at(Time.now + 5*60, 'bob', 5)
