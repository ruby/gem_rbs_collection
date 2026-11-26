require "connection_pool"

pool = ConnectionPool.new(size: 5, timeout: 5) { Hash.new }

pool.with do |h|
  h['some-count']
end

pool.then { |h| h['some-count'] }

pool.with(timeout: 2.0) do |h|
  h['some-count']
end

# @type var version: String
version = ConnectionPool::VERSION

# @type var count: Integer
count = pool.with { |h| h.size }

# @type var conn: Hash[untyped, untyped]
conn = pool.checkout(timeout: 1)
pool.checkin
pool.checkout
pool.checkin(force: true)

pool.with(role: :replica) { |h| h }
pool.with { |h| pool.discard_current_connection { |c| c.clear } }
pool.with { |h| pool.discard_current_connection }

# @type var size: Integer
size = pool.size
# @type var available: Integer
available = pool.available
# @type var idle: Integer
idle = pool.idle

pool.reap(idle_seconds: 30) { |h| h.clear }
pool.reap { |h| h.clear }
pool.reload { |h| h.clear }
pool.shutdown { |h| h.clear }

ConnectionPool.new(size: "2", timeout: 0.5, auto_reload_after_fork: false, name: "redis") { Object.new }

# @type var after_fork: nil
after_fork = ConnectionPool.after_fork

# @type var wrapper: ConnectionPool::Wrapper[String]
wrapper = ConnectionPool.wrap(size: 1, timeout: 1) { +"conn" }
# @type var wrapped: ConnectionPool[String]
wrapped = wrapper.wrapped_pool
# @type var length: Integer
length = wrapper.with { |s| s.length }
# @type var pool_size: Integer
pool_size = wrapper.pool_size
# @type var pool_available: Integer
pool_available = wrapper.pool_available
# @type var responds: bool
responds = wrapper.respond_to?(:upcase)
wrapper.method_missing(:upcase)
wrapper.pool_shutdown { |s| s.clear }

# @type var wrapper2: ConnectionPool::Wrapper[Hash[untyped, untyped]]
wrapper2 = ConnectionPool::Wrapper.new(pool: ConnectionPool.new { Hash.new })
wrapper2 = ConnectionPool.wrap(pool: ConnectionPool.new { Hash.new })
ConnectionPool::Wrapper.new(size: 2) { Hash.new }

stack = ConnectionPool::TimedStack.new(size: 2) { Object.new }
# @type var obj: Object
obj = stack.pop
obj = stack.pop(timeout: 0.1)
stack.push(obj)
stack << obj
# @type var maybe: Object?
maybe = stack.pop(timeout: 0, exception: false)
# @type var empty: bool
empty = stack.empty?
# @type var stack_length: Integer
stack_length = stack.length
# @type var stack_idle: Integer
stack_idle = stack.idle
# @type var max: Integer
max = stack.max
stack.decrement_created
stack.reap(idle_seconds: 0) { |o| o }
stack.shutdown(reload: true) { |o| o }
stack.shutdown { |o| o }

begin
  pool.checkout(timeout: 0)
rescue ConnectionPool::PoolShuttingDownError, ConnectionPool::TimeoutError, ConnectionPool::Error
end
