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

# Test ActiveSupport::Duration arithmetic on Time/Date
(Time.now + 1.day).to_fs
(Time.now - 2.hours).to_fs
(Date.today + 3.days).to_fs
(Date.today - 1.week).to_fs

# Test time zones
Time.zone = 'Asia/Tokyo'
Time.zone.now.to_fs(:db)
Time.now.in_time_zone('Asia/Tokyo').to_fs
Time.now.in_time_zone(false).to_fs
"2026-01-01 00:00".in_time_zone.to_fs

# Test inquiry
[:cat, :dog].inquiry.any?(:cat, :ferret)
'production'.inquiry.upcase

# Test HashWithIndifferentAccess
{ a: 1 }.with_indifferent_access.size.to_s
{ a: 1 }.stringify_keys.keys.first.upcase
{ 'a' => { 'b' => 1 } }.deep_symbolize_keys.keys.first.to_proc

# Test inflections
'active_support'.camelize.downcase
'ActiveSupport'.underscore.upcase
'person'.pluralize.upcase
'people'.singularize(:en).upcase

# Test blank?/present?
1.present?.to_s
nil.blank?.to_s
'foo'.presence&.upcase

# Test HashWithIndifferentAccess methods returning typed values
hwia = { 'a' => 1, 'b' => 2 }.with_indifferent_access
hwia.fetch_values('a').first.to_s
hwia.fetch_values('z') { |_key| 0 }.sum
hwia.merge({ 'c' => 3 }).size
hwia.merge({ 'c' => 3 }) { |_key, old, new| old }.size
hwia.select { |_key, value| value > 1 }.size
hwia.reject { |_key, value| value > 1 }.size
hwia.transform_values { |value| value.to_s }.size
hwia.transform_keys { |key| key.to_sym }.size
hwia.transform_keys!(&:upcase).size

# Test Hash#deep_merge
{ a: { b: 1 } }.deep_merge({ a: { c: 2 } }).keys
{ a: { b: 1 } }.deep_merge!({ a: { c: 2 } }).keys

# Test Array#in_groups
[1, 2, 3].in_groups(2).first&.size
[1, 2, 3].in_groups(2, false).first&.sum
[1, 2, 3].in_groups(2, 0).first&.sum

# Test ActiveSupport::Testing::TimeHelpers returning the block's value
class TimeHelpersTest
  include ActiveSupport::Testing::TimeHelpers

  def test
    travel(1.day) { Time.now }.to_fs
    travel_to(Time.now) { 'traveled' }.upcase
    freeze_time { 42 }.succ
  end
end

# Test ActiveSupport::Rescuable
class RescuableTest
  include ActiveSupport::Rescuable

  def test
    rescue_with_handler(StandardError.new)&.message
  end
end

# Test methods whose block is optional
ActiveSupport::Notifications.instrument("test.active_support", { key: 1 })
{ a: 1 }.with_indifferent_access.update({ b: 2 })

# Test ActiveSupport::EnvironmentInquirer
env = ActiveSupport::EnvironmentInquirer.new("production")
env.production? && !env.local?

# ClassMethods of the concerns the generated classes include
ActiveSupport::CurrentAttributes.define_callbacks(:notify)
ActiveSupport::ExecutionWrapper.define_callbacks(:notify)

# Return types of core extensions
Date.today.readable_inspect.length
DateTime.now.readable_inspect.length
Date.today.compare_with_coercion(Time.now)&.positive?
(DateTime.now <=> Date.today)&.positive?
Time.now.compare_with_coercion(Time.now)&.positive?
Time.now.eql_with_coercion(Time.now) & true
String.as_json&.length
Object.new.duplicable? & Object.new.html_safe?
Class.new.subclasses.map(&:name)

class AlwaysSafe
  def html_safe?
    [true, false].sample || false
  end

  def duplicable?
    [true, false].sample || false
  end
end
