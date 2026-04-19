require "concurrent-ruby"

set = Concurrent::Set.new

set.add(1)
set.member?(1)
