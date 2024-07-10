require 'concurrent-ruby'

hash = Concurrent::Hash.new

hash[:a] = 1
hash.key?(:a)
hash.merge(b: 2)
