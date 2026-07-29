require "concurrent-ruby"

ref = Concurrent::AtomicReference.new(1)
ref.get #=> 1
ref.value #=> 1

ref.set(2)
ref.value = 3

ref.get_and_set(4) #=> 3
ref.swap(5) #=> 4

ref.compare_and_set(5, 6) #=> true
ref.compare_and_swap(6, 7) #=> true

ref.update { |value| value + 1 } #=> 8
ref.try_update { |value| value + 1 } #=> 9
ref.try_update! { |value| value + 1 } #=> 10
