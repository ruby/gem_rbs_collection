Parallel.each(1..5) { |i| puts "#{i}: #{Parallel.worker_number / 2.0}" }

puts Parallel.physical_processor_count.even?

puts Parallel.processor_count.odd?
