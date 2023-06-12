Parallel.any?(['a','b','c']) { |item| item.size == 1 }

Parallel.any?(['a','b','c'], in_processes: 2) { |item| item.size == 1 }

Parallel.any?(['a','b','c'], in_threads: 2) { |item| item.size == 1 }

Parallel.any?(['a','b','c'], progress: 'Running...') { |item| item.size == 1 }

Parallel.any?(['a','b','c'], start: ->(item, index) { puts "Start: #{item}, #{index + 1}" }) { |item| item.size == 1 }

Parallel.any?(['a','b','c'], finish: ->(item, index, result) { puts "Finish: #{item}, #{index + 1}, #{result}" }) { |item| item.size == 1 }

Parallel.any?('a'..'c') { |item| item.size == 1 }

items = [1,2,3]
Parallel.any?(-> { items.pop || Parallel::Stop }) { |item|
  # @type var item: Integer
  item.zero?
}

puts Parallel.any?(['a','b','c']) { |item| item.size == 1 } & false
