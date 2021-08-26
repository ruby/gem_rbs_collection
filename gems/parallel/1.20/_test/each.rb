Parallel.each(['a','b','c']) { |item| puts item }

Parallel.each(['a','b','c'], in_processes: 2) { |item| puts item * 2 }

Parallel.each(['a','b','c'], in_threads: 2) { |item| puts item * 3 }

Parallel.each(['a','b','c'], progress: 'Running...') { |item| puts item * 4 }

Parallel.each(['a','b','c'], start: ->(item, index) { puts "Start: #{item * (index + 1)}" }) { |item| puts item * 5 }

Parallel.each(['a','b','c'], finish: ->(item, index, result) { puts "Finish: #{item * (index + 1)}, #{result.inspect}" }) { |item| item * 6 }

Parallel.each('a'..'c') { |item| puts item * 7 }

items = [1,2,3]
puts Parallel.each(-> { items.pop || Parallel::Stop }) { |item| puts item }.call

puts Parallel.each(['a','b','c']) { |item| item }.map(&:ascii_only?).count

puts Parallel.each_with_index(['a','b','c']) { |item, index| puts item * index }.count

items = [1,2,3]
puts Parallel.each_with_index(-> { items.pop || Parallel::Stop }) { |item, index| puts item * index }.call
