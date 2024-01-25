class HardWorker
  include Sidekiq::Job
end

class HardJob
  include Sidekiq::Job
end

class Hook
end

class Middleware
end

HardWorker.perform_async(1, 2, 3)
HardJob.perform_async(1, 2, 3)

# Test Sidekiq::Client
client = Sidekiq::Client.new
client.middleware do |chain|
  chain.add Middleware
end
Sidekiq::Client.push('class' => HardWorker, 'args' => [1, 2, 3])
Sidekiq::Client.push_bulk('class' => HardWorker, 'args' => [[1, 2, 3], [4,5,6]])
Sidekiq::Client.enqueue(HardWorker, 'foo', 1, :bat => 'bar')
Sidekiq::Client.enqueue_to(:queue_name, HardWorker, 'foo', 1, :bat => 'bar')
Sidekiq::Client.enqueue_to_in(:queue_name, Time.now + 3 * 60, HardWorker, 'foo', 1, :bat => 'bar')
Sidekiq::Client.enqueue_in(Time.now + 3 * 60, HardWorker, 'foo', 1, :bat => 'bar')

Sidekiq::Client.push('class' => HardJob, 'args' => [1, 2, 3])
Sidekiq::Client.push_bulk('class' => HardJob, 'args' => [[1, 2, 3], [4,5,6]])
Sidekiq::Client.enqueue(HardJob, 'foo', 1, :bat => 'bar')
Sidekiq::Client.enqueue_to(:queue_name, HardJob, 'foo', 1, :bat => 'bar')
Sidekiq::Client.enqueue_to_in(:queue_name, Time.now + 3 * 60, HardJob, 'foo', 1, :bat => 'bar')
Sidekiq::Client.enqueue_in(Time.now + 3 * 60, HardJob, 'foo', 1, :bat => 'bar')

# Test configuration of middleware
Sidekiq.configure_server do |config|
  config.redis = { namespace: 'rails', size: 2, url: 'redis://rails:6457/0' }
  config.server_middleware do |chain|
    chain.add Hook
  end
  config.client_middleware do |chain|
    chain.add Hook
  end
end

# Using Redis
# Taken from: https://github.com/mperham/sidekiq/wiki/Using-Redis
Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis.example.com:7372/0', network_timeout: 5 }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis.example.com:7372/0' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://redis.example.com:7372/0', size: 5 }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://redis.example.com:7372/0', size: 25 }
end

Sidekiq.configure_server do |config|
  config.on(:shutdown) do
    puts "Shutting down!"
  end
end
