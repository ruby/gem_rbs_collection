# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'active_support/all'

# Test ActiveSupport::NumericWithFormat
42.to_fs
42.to_fs(:phone)

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

# to_formatted_s is an alias of to_fs
[1, 2].to_formatted_s(:db).upcase
Date.new(2024, 1, 1).to_formatted_s(:db).upcase
DateTime.new(2024, 1, 1).to_formatted_s.upcase
Time.at(0).to_formatted_s(:short).upcase

"text".as_json.upcase

Date.today.compare_with_coercion(Time.now)&.positive?
(DateTime.now <=> Date.today)&.positive?
Time.now.compare_with_coercion(Time.now)&.positive?
# @type var comparison: -1 | 0 | 1 | nil
comparison = Date.today.compare_with_coercion(Time.now)
comparison = Time.now.compare_with_coercion(Date.today)
comparison = DateTime.now <=> Time.now
utc = ActiveSupport::TimeZone['UTC'] || raise
tokyo = ActiveSupport::TimeZone['Asia/Tokyo'] || raise
zoned = ActiveSupport::TimeWithZone.new(Time.now, utc)
scalar = ActiveSupport::Duration::Scalar.new(1)
(zoned <=> Time.now)&.positive?
(utc <=> tokyo)&.positive?
(scalar <=> 2)&.positive?
comparison = zoned <=> Time.now
comparison = utc <=> tokyo
comparison = scalar <=> 2
