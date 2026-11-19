require 'active_support/all'

# Duration and Duration::Scalar arithmetic
duration = 2.minutes
scalar = ActiveSupport::Duration::Scalar.new(3)
# @type var total: ActiveSupport::Duration
total = duration + 1.minute
total = duration + 60
total = duration - 30
total = duration * 2
total = duration / 2
total = duration % 1.minute
total = scalar + duration
total = scalar * duration
total = scalar % duration
# @type var scaled: ActiveSupport::Duration::Scalar
scaled = scalar + 1
scaled = scalar - 1
scaled = scalar * 2
scaled = scalar / 2
scaled = scalar % 2
# @type var ratio: Numeric
ratio = duration / 1.minute
ratio = scalar / duration
(duration + 60).parts
(duration - 30).parts
(duration * 2).parts
(duration / 2).parts
(duration % 60).parts
(scalar + 1).value
(scalar - duration).parts
duration.coerce(1).first.value
scalar.coerce(1).first.value

# SafeBuffer operators keep the buffer
buffer = ActiveSupport::SafeBuffer.new("<b>%s</b>")
# @type var safe: ActiveSupport::SafeBuffer
safe = buffer + "x"
safe = buffer * 2
safe = buffer % ["x"]
(buffer + "x").html_safe?
(buffer * 2).html_safe?
(buffer % ["x"]).html_safe?
buffer[0]&.upcase

# HashWithIndifferentAccess reads and writes the value type
counts = ActiveSupport::HashWithIndifferentAccess[a: 1]
counts.keys
# @type var scores: ActiveSupport::HashWithIndifferentAccess[String, Integer]
scores = ActiveSupport::HashWithIndifferentAccess.new
scores.[]=(:alice, 1).succ
scores[:alice].succ

# Date plus or minus a Duration can return a Time or TimeWithZone
# @type var moment: Date | Time | ActiveSupport::TimeWithZone
moment = Date.today + 1.hour
moment = Date.today - 1.day
moment.to_date

# Calendar Durations keep a Date
# @type var later_date: Date
later_date = Date.today + 1.day
later_date = Date.today - 2.weeks
later_date = Date.today + 1.month + 1.year
later_date = Date.today + (1.day + 1.fortnight)
later_date = Date.today - -(1.day * 2)
later_date = Date.today + ActiveSupport::Duration.days(1)
later_date.to_date

# Clock Durations turn a Date into a Time or TimeWithZone
# @type var later_time: Time | ActiveSupport::TimeWithZone
later_time = Date.today + 1.hour
later_time = Date.today - 30.minutes
later_time = Date.today + (1.hour + 1.second)
later_time = Date.today + ActiveSupport::Duration.seconds(1)
later_time.hour

# Mixed or unknown Durations keep the wide type
# @type var mixed: ActiveSupport::Duration[:calendar | :clock]
mixed = 1.day + 1.hour
mixed = 1.day + 60
# @type var later: Date | Time | ActiveSupport::TimeWithZone
later = Date.today + mixed
later = Date.today - (1.day + 1.hour)
later = Date.today + ActiveSupport::Duration.build(3600)
later = Date.today + ActiveSupport::Duration.parse("PT1H")
later = Date.today + ActiveSupport::Duration.new(3600, { hours: 1 })
later.to_date

# DateTime and Time keep their class for any Duration
# @type var date_time: DateTime
date_time = DateTime.now + 1.hour
date_time = DateTime.now - 1.day
date_time = DateTime.now + mixed
date_time.hour
# @type var time: Time
time = Time.now + 1.day
time = Time.now - 1.hour
time = Time.now + mixed
time.hour
