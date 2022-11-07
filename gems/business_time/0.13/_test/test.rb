require "business_time"

# try these examples, using the current time:

1.business_hour.from_now
4.business_hours.from_now
8.business_hours.from_now

1.business_hour.ago
4.business_hours.ago
8.business_hours.ago

1.business_day.from_now
4.business_days.from_now
8.business_days.from_now

1.business_day.ago
4.business_days.ago
8.business_days.ago

Date.today.workday?
Date.parse("2015-12-09").workday?
Date.parse("2015-12-12").workday?

# And we can do it from any Date or Time object.

my_birthday = Date.parse("August 4th, 1969")
8.business_days.after(my_birthday)
8.business_days.before(my_birthday)

my_birthday = Time.parse("August 4th, 1969, 8:32 am")
8.business_days.after(my_birthday)
8.business_days.before(my_birthday)

# We can adjust the start and end time of our business hours

BusinessTime::Config.beginning_of_workday = "8:30 am"
BusinessTime::Config.end_of_workday = "5:30 pm"

# Or we can temporarily override the configured values

BusinessTime::Config.with(beginning_of_workday: "8 am", end_of_workday: "6 pm") do
  1.business_hour.from_now
end

# and we can add holidays that don't count as business days
# July 5 in 2010 is a monday that the U.S. takes off because our independence day falls on that Sunday.

three_day_weekend = Date.parse("July 5th, 2010")
BusinessTime::Config.holidays << three_day_weekend
friday_afternoon = Time.parse("July 2nd, 2010, 4:50 pm")
tuesday_morning = 1.business_hour.after(friday_afternoon)

# plus, we can change the work week:

# July 9th in 2010 is a Friday.
BusinessTime::Config.work_week = [:sun, :mon, :tue, :wed, :thu]
thursday_afternoon = Time.parse("July 8th, 2010, 4:50 pm")
sunday_morning = 1.business_hour.after(thursday_afternoon)

# As alternative we also can change the business hours for each work day:

BusinessTime::Config.work_hours = {
  mon: ["9:00","17:00"],
  fri: ["9:00","17:00"],
  sat: ["10:00","15:00"]
}
friday = Time.parse("December 24, 2010 15:00")
monday = Time.parse("December 27, 2010 11:00")
working_hours = friday.business_time_until(monday) # 9.hours

# You can also calculate business duration between two dates

friday = Date.parse("December 24, 2010")
monday = Date.parse("December 27, 2010")
friday.business_days_until(monday) #=> 1

# Or you can calculate business duration between two Time objects

ticket_reported = Time.parse("February 3, 2012, 10:40 am")
ticket_resolved = Time.parse("February 4, 2012, 10:50 am")
ticket_reported.business_time_until(ticket_resolved) #=> 8.hours + 10.minutes

# You can also determine if a given time is within business hours

Time.parse("February 3, 2012, 10:00 am").during_business_hours?

# Note that counterintuitively, durations might not be quite what you expect when involving weekends. Consider the following example:

ticket_reported = Time.parse("February 3, 2012, 10:40 am")
ticket_resolved = Time.parse("February 4, 2012, 10:40 am")
ticket_reported.business_time_until(ticket_resolved) # will equal 6 hours and 20 minutes!

# Why does this happen? Feb 4 2012 is a Saturday. That time will roll over to Monday, Feb 6th 2012, 9:00am. The business time between 10:40am friday and 9am monday is 6 hours and 20 minutes. From a quick inspection of the code, it looks like it should be 8 hours.
# Or you can calculate business dates between two dates

monday = Date.parse("December 20, 2010")
wednesday = Date.parse("December 22, 2010")
monday.business_dates_until(wednesday) #=> [Mon, 20 Dec 2010, Tue, 21 Dec 2010]

# You can get the first workday after a time or return itself if it is a workday

saturday = Time.parse("Sat Aug 9, 18:00:00, 2014")
monday = Time.parse("Mon Aug 11, 18:00:00, 2014")
Time.first_business_day(saturday) #=> "Mon Aug 11, 18:00:00, 2014"
Time.first_business_day(monday) #=> "Mon Aug 11, 18:00:00, 2014"

# similar to Time#first_business_day Time#previous_business_day only cares about
# workdays:
saturday = Time.parse("Sat Aug 9, 18:00:00, 2014")
monday = Time.parse("Mon Aug 11, 18:00:00, 2014")
Time.previous_business_day(saturday) #=> "Fri Aug 8, 18:00:00, 2014"
Time.previous_business_day(monday) #=> "Mon Aug 11, 18:00:00, 2014"
