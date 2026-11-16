require "groupdate"
require "active_record"

Groupdate.time_zone = "Pacific Time (US & Canada)"
Groupdate.time_zone = ActiveSupport::TimeZone["UTC"]
Groupdate.time_zone = false
Groupdate.time_zone = nil
Groupdate.week_start = :monday
Groupdate.day_start = 2
zone = Groupdate.time_zone #: String | ActiveSupport::TimeZone | false | nil
start = Groupdate.week_start #: Symbol | String
start_hour = Groupdate.day_start #: Numeric
zone.nil?
start.to_s
start_hour.zero?

Groupdate::PERIODS.first&.to_s
Groupdate::METHODS.first&.to_s
Groupdate::VERSION.upcase
error = Groupdate::Error.new("invalid") #: RuntimeError
error.message

# ActiveRecord: model class methods
# @type var daily: User::ActiveRecord_Relation
daily = User.group_by_day(:created_at)
daily.count
daily = User.group_by_day(:created_at, range: (Time.now - 1_209_600)..Time.now, time_zone: "UTC", format: "%b %d")
daily = User.group_by_day(:created_at, range: (Time.now - 2_592_000).., series: false, default_value: 0)
daily = User.group_by_day(:created_at, expand_range: true, reverse: true, day_start: 2, locale: :en)
daily = User.group_by_day(:created_at, carry_forward: true, last: 7, current: false)
daily = User.group_by_day("users.created_at", time_zone: false, format: ->(_time) { "label" })
daily = User.group_by_day(:created_at, time_zone: ActiveSupport::TimeZone["UTC"])
# @type var weekly: User::ActiveRecord_Relation
weekly = User.group_by_week(:created_at, week_start: :monday, day_start: 3)
weekly = User.group_by_month(:created_at, last: 6)
weekly = User.group_by_quarter(:created_at)
weekly = User.group_by_year(:created_at)
weekly = User.group_by_hour(:created_at)
weekly = User.group_by_minute(:created_at, n: 10)
weekly = User.group_by_second(:created_at, n: 30)
weekly = User.group_by_day_of_week(:created_at, week_start: "mon", format: "%a")
weekly = User.group_by_hour_of_day(:created_at, format: "%-l %P")
weekly = User.group_by_minute_of_hour(:created_at)
weekly = User.group_by_day_of_month(:created_at)
weekly = User.group_by_day_of_year(:created_at)
weekly = User.group_by_month_of_year(:created_at)
weekly = User.group_by_period(:day, :created_at)
weekly = User.group_by_period("week", :created_at, permit: ["day", "week"], week_start: :sunday, time_zone: "UTC")
weekly = User.where(name: "a").group_by_day(:created_at).order(:name)

# ActiveRecord: relations
# @type var scoped: User::ActiveRecord_Relation
scoped = User.where(name: "a").group_by_month(:created_at, format: "%b %Y")
scoped = scoped.group_by_week(:created_at, last: 8)
scoped = scoped.group_by_period(:month, :created_at, range: (Time.now - 31_536_000)..Time.now)
scoped.distinct.count(:id)

# ActiveRecord: grouping loaded records with a block
by_day = User.where(name: "a").group_by_day { |user| user.created_at } #: Hash[ActiveSupport::TimeWithZone, Array[User]]
by_day.each { |time, users| time.year + users.size }
by_formatted = User.all.group_by_month(format: "%Y-%m") { |user| user.created_at } #: Hash[String, Array[User]]
by_formatted.keys.first&.upcase
by_hour = User.all.group_by_hour_of_day { |user| user.created_at } #: Hash[Integer, Array[User]]
by_hour.keys.first&.succ
User.all.group_by_period(:day) { |user| user.created_at }

# Enumerable
times = [Time.now, Time.now - 86_400]
# @type var grouped: Hash[ActiveSupport::TimeWithZone, Array[Time]]
grouped = times.group_by_day { |time| time }
grouped = times.group_by_day(time_zone: "Pacific Time (US & Canada)") { |time| time }
grouped = times.group_by_day(series: true, range: (Time.now - 172_800)..Time.now, expand_range: true, reverse: true, locale: :en, day_start: 1) { |time| time }
grouped = times.group_by_week(week_start: :monday) { |time| time.to_time }
grouped = times.group_by_month { |time| time }
grouped = times.group_by_quarter { |time| time }
grouped = times.group_by_year { |time| time }
grouped = times.group_by_hour { |time| time }
grouped = times.group_by_minute(n: 15) { |time| time }
grouped = times.group_by_second(n: 15) { |time| time }
counts = times.group_by_day { |time| time }.to_h { |time, group| [time, group.count] } #: Hash[ActiveSupport::TimeWithZone, Integer]
counts.values.sum
# @type var formatted: Hash[String, Array[Time]]
formatted = times.group_by_day(format: "%Y-%m-%d") { |time| time }
formatted.keys.first&.upcase
# @type var custom: Hash[untyped, Array[Time]]
custom = times.group_by_day(format: proc { |_time| "label" }) { |time| time }
# @type var of_periods: Hash[Integer, Array[Time]]
of_periods = times.group_by_day_of_week(week_start: :monday) { |time| time }
of_periods = times.group_by_hour_of_day(day_start: 2) { |time| time }
of_periods = times.group_by_minute_of_hour { |time| time }
of_periods = times.group_by_day_of_month { |time| time }
of_periods = times.group_by_day_of_year { |time| time }
of_periods = times.group_by_month_of_year { |time| time }
periods = times.group_by_period(:day, time_zone: "UTC") { |time| time } #: Hash[untyped, Array[Time]]
periods = times.group_by_period("week", permit: ["day", "week"], week_start: :monday) { |time| time }
periods.keys
