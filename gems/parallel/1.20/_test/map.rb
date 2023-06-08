puts Parallel.map(['a','b','c']) { |item| item * 1 }.at(0)

puts Parallel.map(['a','b','c'], in_processes: 2) { |item| item * 2 }.at(0)

puts Parallel.map(['a','b','c'], in_threads: 2) { |item| item * 3 }.at(0)

puts Parallel.map(['a','b','c'], progress: 'Running...') { |item| item * 4 }.at(0)

puts Parallel.map(['a','b','c'], start: ->(item, index) { puts "Start: #{item}, #{index + 1}" }) { |item| item * 5 }.at(0)

puts Parallel.map(['a','b','c'], finish: ->(item, index, result) { puts "Finish: #{item}, #{index + 1}, #{result}" }) { |item| item * 6 }.at(0)

puts Parallel.map('a'..'c') { |item| item * 2 }.at(0)

items = [1,2,3]
puts Parallel.map(-> { items.pop || Parallel::Stop }) { |item|
  # @type var item: Integer
  item / 2.0
}.at(0)

puts Parallel.map_with_index(['a','b','c'], in_threads: 2) { |item, index| item * index }.at(0)

puts Parallel.map_with_index('a'..'c', in_processes: 2) { |item, index| item * index }.at(0)

items = [1,2,3]
puts Parallel.map_with_index(-> { items.pop || Parallel::Stop }) { |item, index|
  # @type var item: Integer
  item * index
}.at(0)

puts Parallel.flat_map(['a','b','c']) { |item| [item] }.at(0)

puts Parallel.flat_map('a'..'c') { |item| [item] }.at(0)
