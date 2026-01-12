require 'concurrent-ruby'

map = Concurrent::Map.new #: Concurrent::Map[Symbol, Integer]

map[:a] = 1
map.fetch(:b) { 2 }
map.fetch(:c, 3)

new_value = map.compute(:a) { |old_value| (old_value || 0) + 1 }
new_value + 2
map.compute(:a) { |_old_value| nil }

new_value = map.compute_if_absent(:absent) { 3 }
new_value + 2

map.compute_if_present(:maybe_present) { |old_value| old_value + 1 }
map.compute_if_present(:a) { |_old_value| nil }

map.delete(:a)
map.delete_pair(:b, 2)
