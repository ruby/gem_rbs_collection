require "holiday_jp"

holidays = HolidayJp.between(Date.new(2010, 9, 14), Date.new(2010, 9, 21)) # => [#<HolidayJp::Holiday>]
holidays[0].name # => 敬老の日
holidays[0].date # => Mon, 20 Sep 2010
HolidayJp.holiday?(Date.new(2016, 8 ,11)) # => true
