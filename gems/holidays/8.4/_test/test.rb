# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "holidays"


Holidays.on(Date.civil(2022, 8, 11), :jp)

Holidays.between(Date.civil(2022, 8, 10), Date.civil(2022, 8, 12), :jp)
