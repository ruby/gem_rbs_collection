# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "connection_pool"

pool = ConnectionPool.new(size: 5, timeout: 5) { Array.new }

pool.with do |array|
	array.push(123)
end
