require 'net'
require 'async'
require 'async/barrier'
require 'async/semaphore'
require 'async/waiter'

Async do |task|
  task.async{ "str" }.wait.size
  task.with_timeout(10, Async::TimeoutError, 'timeout') {}
end

Async(transient: true) do
end

Async do
  a = Async { "str" }
  p a.wait.size
end

Sync{ "str" }.size

Async("str", 1) do |task, var1, var2|
  # @type var var1: String
  # @type var var2: Integer
  var1.size / var2
end

Async do
  barrier = Async::Barrier.new
  semaphore = Async::Semaphore.new(2, parent: barrier)

  10.times do
    semaphore.async(parent: barrier) do
    end
  end

  barrier.wait
end

# based on code from docs https://github.com/socketry/async
# SPDX-License-Identifier: MIT

# from https://github.com/socketry/async/blob/975d4d5bdbff5d652f229d4cc28bc2cdcc62661d/lib/async/barrier.md
barrier = Async::Barrier.new
Sync do
	puts("Barrier Example: sleep sort.")

	# Generate an array of 10 numbers:
	numbers = 10.times.map{rand(10)}

	# Sleep sort the numbers:
	numbers.each do |number|
		barrier.async do |task|
			task.sleep(number)
		end
	end

	# Wait for all the numbers to be sorted:
	barrier.wait

	puts("Sorted")
ensure
	# Ensure all the tasks are stopped when we exit:
	barrier.stop
end

# from https://github.com/socketry/async/blob/975d4d5bdbff5d652f229d4cc28bc2cdcc62661d/lib/async/barrier.md
Sync do
	condition = Async::Condition.new

	Async do
		puts "Waiting for condition..."
		value = condition.wait
		puts "Condition was signalled: #{value}"
	end

	Async do |task|
		task.sleep(1)
		puts "Signalling condition..."
		condition.signal("Hello World")
	end
end

# from https://github.com/socketry/async/blob/975d4d5bdbff5d652f229d4cc28bc2cdcc62661d/lib/async/semaphore.md
Sync do
	# Only allow two concurrent tasks at a time:
	semaphore = Async::Semaphore.new(2)

	# Generate an array of 10 numbers:
	terms = ['ruby', 'python', 'go', 'java', 'c++']

	# Search for the terms:
	terms.each do |term|
		semaphore.async do |task|
			puts("Searching for #{term}...")
		end
	end
end

# from https://github.com/socketry/async/blob/975d4d5bdbff5d652f229d4cc28bc2cdcc62661d/lib/async/task.md
Async do |task|
	sleep(1)
end
