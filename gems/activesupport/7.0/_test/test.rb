# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

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

"Id".downcase_first
ActiveSupport::TimeZone['Asia/Tokyo'].to_s
Time.find_zone(Object.name)
Time.zone.now.to_fs
1234567890.50.to_fs(:currency)
1234567890.506.to_fs(:currency, precision: 3)
(1..10).to_fs(:db)
(1..10).to_fs
[1,2].to_fs(:db)
[1,2].to_fs
Time.now.to_fs(:db)
Time.now.to_fs
Date.today.to_fs(:db)
Date.today.to_fs
DateTime.today.to_fs(:db)
DateTime.today.to_fs


Array.wrap(nil)
Array.wrap([1, 2, 3])
Array.wrap("hello")
Array.wrap({a: 1, b: 2})
