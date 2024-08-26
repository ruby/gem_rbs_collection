require "concurrent-ruby"

array = Concurrent::Array.new

array << 1
array.include?(1)
