# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "holidays"

Holidays::WEEKS
Holidays::MONTH_LENGTHS
Holidays::DAY_SYMBOLS

holidays = Holidays.on(Date.civil(2022, 8, 11), :jp)
holidays[0][:date]
holidays[0][:name]
holidays[0][:regions]

holidays = Holidays.between(Date.civil(2022, 8, 10), Date.civil(2022, 8, 12), :jp)
holidays[0][:date]
holidays[0][:name]
holidays[0][:regions]
