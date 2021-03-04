puts Parallel.map([1, 2, 3]) { |x| raise Parallel::Break, x if x == 2 } == 2

puts Parallel.map([1, 2, 3]) { |x| raise Parallel::Break.new(x) if x == 2 } == 2

Parallel.map([1, 2, 3]) do |x|
  if x == 1
    sleep 0.1
    puts 'DEAD'
    raise Parallel::Kill
  elsif x == 3
    sleep 10
  else
    x
  end
end
