# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "connection_pool"

pool = ConnectionPool.new(size: 5, timeout: 5) { Hash.new }

pool.with do |h|
  h['some-count']
end

pool.then { |h| h['some-count'] }

pool.with(timeout: 2.0) do |h|
  h['some-count']
end
