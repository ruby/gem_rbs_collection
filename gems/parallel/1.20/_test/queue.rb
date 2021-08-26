queue = Queue.new
queue.push 1
queue.push 2
queue.push 3
queue.push Parallel::Stop

puts Parallel.map(queue, in_threads: 2) { |i| "ITEM-#{i}" }
