require 'active_support/all'

# Test ActiveSupport::NumericWithFormat
42.to_s
42.to_s(:phone)

5.try(:to_s)
5.try('round', 2)
5.try(:tap) { |n| p n }
5.try { p 'hello' }
5.try { |n| p n }
nil.try(:to_s)
nil.try('round', 2)
nil.try(:tap) { |n| p n }
nil.try { p 'hello' }
nil.try { |n| p n }
[1, 2, 3, 4].in_groups(2)
[1, 2, 3, 4].in_groups(2) { |group| p group }

hash = { a: 1, b: 2, c: 3 }
hash.stringify_keys
hash.stringify_keys!

hash.symbolize_keys
hash.symbolize_keys!

hash = { hoge: { hogefuga: { hogehoge: 1 }, fugahoge: 2 }, fuga: 3 }
hash.deep_stringify_keys
hash.deep_stringify_keys!

hash.deep_symbolize_keys
hash.deep_symbolize_keys!
