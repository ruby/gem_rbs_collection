# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "timecop"
require "date"

# @type var time: Time
time = Timecop.freeze
time = Timecop.freeze(Time.local(2008, 10, 5))
time = Timecop.freeze(Date.new(2008, 10, 5))
time = Timecop.freeze(DateTime.new(2008, 10, 5, 12, 0, 0))
time = Timecop.freeze("2008-10-05 12:00:00")
time = Timecop.freeze(60 * 60)
time = Timecop.freeze(1.5)
time = Timecop.freeze(2008, 10, 5)
time = Timecop.freeze(2008, 10, 5, 12, 30, 15)
time = Timecop.travel(Time.local(2008, 10, 5))
time = Timecop.travel(2008, 10, 5, 12)
time = Timecop.scale(2)
time = Timecop.scale(3600, Time.local(2008, 10, 5))
time = Timecop.scale(2, 2008, 10, 5)
time = Timecop.return_to_baseline

# @type var year: Integer
year = Timecop.freeze(Time.local(2008, 10, 5)) { |t| t.year }
year = Timecop.freeze(2008, 10, 5) { Time.now.year }
year = Timecop.travel(Date.new(2008, 10, 5)) { |t| t.year }
year = Timecop.scale(2, Time.local(2008, 10, 5)) { |t| t.year }
year = Timecop.return { Time.now.year }
year = Timecop.unfreeze { Time.now.year }

# @type var returned: nil
returned = Timecop.return
returned = Timecop.unfreeze

Timecop.baseline = Time.local(2008, 10, 5)
Timecop.baseline = Date.new(2008, 10, 5)
Timecop.baseline = "2008-10-05 12:00:00"
Timecop.baseline = 60
baseline = Timecop.baseline
baseline.year if baseline.is_a?(Time)
Timecop.baseline = nil

# @type var flag: bool
flag = Timecop.frozen?
flag = Timecop.travelled?
flag = Timecop.scaled?
flag = Timecop.safe_mode?
flag = Timecop.thread_safe
flag = Timecop.mock_process_clock?

Timecop.safe_mode = true
begin
  Timecop.freeze
rescue Timecop::SafeModeException => e
  e.message
end
Timecop.safe_mode = false
Timecop.thread_safe = false
Timecop.mock_process_clock = false

# @type var real_time: Time
real_time = Time.now_without_mock_time
# @type var real_date: Date
real_date = Date.today_without_mock_date
# @type var real_datetime: DateTime
real_datetime = DateTime.now_without_mock_time
# @type var real_parsed: Date
real_parsed = Date.parse_without_mock_date("2008-10-05")
Date.strptime_without_mock_date("2008-10-05", "%Y-%m-%d")
DateTime.parse_without_mock_date("2008-10-05T12:00:00")
Time.new_without_mock_time(2008, 10, 5)
Process.clock_gettime_without_mock(Process::CLOCK_MONOTONIC)
Timecop.freeze(1.5) { Time.now }

Timecop::VERSION.upcase
Timecop.return

[time, year, returned, flag, real_time, real_date, real_datetime]
Timecop.scale(nil)
