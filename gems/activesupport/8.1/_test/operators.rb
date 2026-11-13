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
