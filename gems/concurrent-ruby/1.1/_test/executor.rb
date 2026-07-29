require 'concurrent-ruby'

Concurrent.executor(:io).post { p :io }
Concurrent.executor(:fast).post { p :fast }
Concurrent.executor(:immediate).post { p :immediate }

Concurrent.global_io_executor.post { p :io }
Concurrent.global_fast_executor.post { p :fast }
Concurrent.global_immediate_executor.post { p :immediate }

pool = Concurrent::FixedThreadPool.new(4, name: "pool", max_queue: 10, idletime: 30, fallback_policy: :abort)
pool.post { p :fixed_thread_pool }
pool.fallback_policy #=> :abort
pool.name #=> "pool"
pool.max_length #=> 4
pool.min_length #=> 4
pool.idletime #=> 30
pool.max_queue #=> 10
pool.synchronous #=> false
pool.largest_length
pool.scheduled_task_count
pool.completed_task_count
pool.length
pool.queue_length
pool.remaining_capacity
pool.can_overflow?
pool.serialized? #=> false
pool.running? #=> true
pool.shuttingdown? #=> false
pool.shutdown? #=> false
pool.auto_terminate? #=> true
pool.to_s
pool.prune_pool
pool.shutdown #=> true
pool.wait_for_termination(1) #=> true
pool.kill #=> true
