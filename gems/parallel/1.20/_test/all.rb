Parallel.all?(['a','b','c']) { |item| item.size == 1 }

Parallel.all?(['a','b','c'], in_processes: 2) { |item| item.size == 1 }

Parallel.all?(['a','b','c'], in_threads: 2) { |item| item.size == 1 }

Parallel.all?(['a','b','c'], progress: 'Running...') { |item| item.size == 1 }

Parallel.all?(['a','b','c'], start: ->(item, index) { puts "Start: #{item * (index + 1)}" }) { |item| item.size == 1 }

Parallel.all?(['a','b','c'], finish: ->(item, index, result) { puts "Finish: #{item * (index + 1)}, #{result.inspect}" }) { |item| item.size == 1 }

Parallel.all?('a'..'c') { |item| item.size == 1 }

items = [1,2,3]
Parallel.all?(-> { items.pop || Parallel::Stop }) { |item| item.size == 1 }

puts Parallel.all?(['a','b','c']) { |item| item.size == 1 } & false
