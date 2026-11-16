require "icalendar"
require "icalendar/tzinfo"
require "stringio"

cal = Icalendar::Calendar.new
cal.prodid = "-//Example//Calendar//EN"
cal.version = "2.0"
cal.calscale = "GREGORIAN"
cal.uid = "calendar-1"
cal.url = "https://example.com/calendar"
cal.last_modified = Time.now
cal.ip_name = ["Example"]
cal.description = "Example calendar"

# @type var prodid: Icalendar::Values::Text?
prodid = cal.prodid
prodid&.value&.upcase
cal.version&.to_s&.size
cal.calscale&.ical_params&.empty?
cal.uid&.to_s
cal.url&.to_s
cal.last_modified&.utc?
cal.ip_name.first&.to_s
cal.description.first&.to_s

event = cal.event do |e|
  e.dtstart = Icalendar::Values::Date.new("20050428")
  e.dtend = Icalendar::Values::Date.new("20050429")
  e.summary = "Meeting with the man."
  e.description = "Have a long lunch meeting and decide nothing..."
  e.ip_class = "PRIVATE"
end

# @type var summary: Icalendar::Values::Text?
summary = event.summary
summary&.value&.upcase
event.description&.to_s&.size
event.ip_class&.to_s
event.dtstart&.to_s
event.dtend&.to_s
event.dtstart&.ical_params&.empty?

event2 = Icalendar::Event.new
event2.dtstart = DateTime.civil(2006, 6, 23, 8, 30)
event2.summary = "A great event!"
added = cal.add_event(event2)
added.uid&.value&.upcase

event3 = cal.event
event3.dtstart = Date.new(2006, 6, 24)
event3.dtend = Time.now + 3600
event3.summary = Icalendar::Values::Text.new("With params", { "altrep" => "http://example.com", "language" => "SPANISH" })
event3.summary&.ical_params&.[]("language")
event3.summary&.ical_param("charset", "UTF-8")

event4 = Icalendar::Event.new
event4.dtstart = Icalendar::Values::DateOrDateTime.new("20140924")
event4.dtend = Icalendar::Values::DateOrDateTime.new("20140925").call
event4.dtstamp = Time.now
event4.uid = "event-4"
event4.dtstamp&.to_s
event4.uid&.to_s
event4.url = "https://example.com"
event4.url&.to_s
event4.duration = "+P0W1D0H0M"
event4.duration&.past?
event4.duration&.to_s
event4.created = Time.now
event4.created&.to_s
event4.last_modified = Time.now
event4.last_modified&.to_s
event4.recurrence_id = Time.now
event4.recurrence_id&.to_s
event4.location = "Room 1"
event4.location&.to_s
event4.status = "CONFIRMED"
event4.status&.to_s
event4.transp = "OPAQUE"
event4.transp&.to_s
event4.priority = 3
event4.priority&.value&.succ
event4.sequence = 1
event4.sequence&.value&.succ

event5 = Icalendar::Event.new
event5.organizer = Icalendar::Values::CalAddress.new("mailto:jsmith@example.com", cn: "John Smith")
event5.attendee = ["mailto:a@example.com", "mailto:b@example.com"]
event5.append_attendee("mailto:c@example.com")
event5.rrule = "FREQ=YEARLY;BYMONTH=3"
event5.append_rrule("FREQ=DAILY")
event5.categories = ["work", "meeting"]
event5.append_categories("extra")
event5.comment = "comment"
event5.append_comment("another")
event5.exdate = Time.now
event5.append_exdate(Time.now)
event5.rdate = [Time.now]
event5.append_rdate(Time.now)
event5.attach = "https://example.com/a.pdf"
event5.append_attach(Icalendar::Values::Uri.new("ftp://host.com/a.exe", "fmttype" => "application/binary"))
event5.organizer&.ical_params&.[]("cn")
event5.attendee.map { |a| a.to_s }
event5.rrule.map { |r| r.valid? }
event5.categories.size
event5.comment.map { |c| c.to_s }
event5.exdate.map { |d| d.to_s }
event5.rdate.map { |d| d.to_s }
event5.attach.map { |u| u.to_s }
event5.valid?
event5.valid?(true)

event.alarm do |a|
  a.action = "EMAIL"
  a.description = "This is an event reminder"
  a.summary = "Alarm notification"
  a.attendee = %w[mailto:me@example.net mailto:me-too@example.net]
  a.append_attendee "mailto:me-three@example.net"
  a.trigger = "-PT15M"
  a.append_attach Icalendar::Values::Uri.new("ftp://host.com/novo-procs/felizano.exe", "fmttype" => "application/binary")
end
alarm = event.alarm
alarm.action = "AUDIO"
alarm.uid = "alarm-1"
alarm.duration = "PT5M"
alarm.repeat = 2
alarm.acknowledged = Time.now
alarm.attach = "Basso"
alarm.action&.to_s
alarm.trigger&.to_s
alarm.description&.to_s
alarm.summary&.to_s
alarm.attendee.map { |a| a.to_s }
alarm.uid&.to_s
alarm.duration&.to_s
alarm.repeat&.value&.succ
alarm.acknowledged&.to_s
alarm.attach.map { |u| u.to_s }
alarm.valid?
event.has_alarm?
event.alarms.map { |a| a.to_ical }
event.add_alarm(Icalendar::Alarm.new)

cal.timezone do |t|
  t.tzid = "America/Chicago"

  t.daylight do |d|
    d.tzoffsetfrom = "-0600"
    d.tzoffsetto = "-0500"
    d.tzname = "CDT"
    d.dtstart = "19700308T020000"
    d.rrule = "FREQ=YEARLY;BYMONTH=3;BYDAY=2SU"
  end

  t.standard do |s|
    s.tzoffsetfrom = "-0500"
    s.tzoffsetto = "-0600"
    s.tzname = "CST"
    s.dtstart = "19701101T020000"
    s.rrule = "FREQ=YEARLY;BYMONTH=11;BYDAY=1SU"
  end
end

timezone = cal.timezones.first
timezone&.tzid&.to_s
timezone&.daylights&.first&.tzoffsetfrom&.behind?
timezone&.daylights&.first&.tzoffsetto&.to_s
timezone&.daylights&.first&.dtstart&.to_s
timezone&.daylights&.first&.tzname&.map { |n| n.to_s }
timezone&.daylights&.first&.rrule&.map { |r| r.to_s }
timezone&.standards&.first&.tzoffsetfrom&.to_s
timezone&.standards&.first&.dtstart&.to_s
timezone&.standards&.first&.tzname&.map { |n| n.to_s }
timezone&.standards&.first&.rrule&.map { |r| r.to_s }
timezone&.valid?
cal.find_timezone("America/Chicago")&.to_ical
cal.has_timezone?

tz = TZInfo::Timezone.get("America/Chicago")
ical_timezone = tz.ical_timezone(DateTime.new(2008, 12, 29, 8, 0, 0))
cal.add_timezone(ical_timezone)
cal.add_timezone(tz.ical_timezone(Time.now, true))
start_time = DateTime.new(2008, 12, 29, 8, 0, 0)
cal.event do |e|
  e.dtstart = Icalendar::Values::DateTime.new(start_time, "tzid" => "America/Chicago")
  e.dtend = Icalendar::Values::DateTime.new(start_time + 1, tzid: "UTC")
  e.dtstart&.to_s
  e.dtstart&.ical_params&.[]("tzid")
end

cal.publish
cal.request
cal.reply
cal.add
cal.cancel
cal.refresh
cal.counter
cal.decline_counter.ip_method&.to_s
published = cal.publish.to_ical
published.lines

cal.events.map { |e| e.to_ical }
cal.find_event("some-uid")&.summary&.value
cal.has_event?
cal.valid?

cal_string = cal.to_ical
cals = Icalendar::Calendar.parse(cal_string)
parsed = cals.first
parsed&.events&.first&.dtstart&.ical_params&.[]("tzid")
Icalendar::Calendar.parse(StringIO.new(cal_string)).size
Icalendar::Calendar.parse(StringIO.new("BEGIN:VCALENDAR\r\nBEGIN:VEVENT\r\nSUMMARY:Single\r\nEND:VEVENT\r\nEND:VCALENDAR\r\n")).size
Icalendar::Event.parse(StringIO.new("BEGIN:VEVENT\r\nSUMMARY:Only event\r\nEND:VEVENT\r\n")).first&.summary&.to_s

strict_parser = Icalendar::Parser.new(StringIO.new(cal_string), true)
strict_parser.parse.first&.to_ical
Icalendar::Parser.new(cal_string).parse.size

custom = Icalendar::Event.new
custom.custom_property("x_foo").size
custom.append_custom_property("x_foo", "bar")
custom.property("summary")
custom.name
custom.ical_name
custom.parent
custom.new_uid
Icalendar::VERSION

Icalendar::Values::Date::FORMAT
Icalendar::Values::DateTime::FORMAT
begin
  Icalendar::Values::Date.new("not a date")
rescue Icalendar::Values::Date::FormatError => e
  e.message
end
begin
  Icalendar::Values::DateTime.new("not a date")
rescue Icalendar::Values::DateTime::FormatError => e
  e.message
end

date_a = Icalendar::Values::Date.new(Date.new(2024, 1, 2))
datetime_a = Icalendar::Values::DateTime.new("20240102T030405Z")
date_a < Date.new(2024, 1, 3)
date_a <= Time.now
date_a > Date.today
date_a >= Time.now
date_a.between?(Date.new(2024, 1, 1), Date.new(2024, 1, 3))
datetime_a < Time.now
datetime_a <= Time.now
datetime_a > Time.now - 3600
datetime_a >= Time.now
datetime_a.between?(Time.now - 3600, Time.now)
(date_a <=> Icalendar::Values::Date.new(Date.new(2024, 1, 3))).to_s
upcoming = event.dtstart
if upcoming
  upcoming < Time.now
  upcoming > Time.now
end
event5.exdate.map { |d| d.is_a?(Icalendar::Values::Helpers::Array) || d.is_a?(Icalendar::Values::Period) }

text = Icalendar::Values::Text.new("hello", { "language" => "EN" }, { "key" => 1 })
text.value.upcase
text.to_s.upcase
text.context.has_key?("key")
text.ical_params = { "cn" => "x" }
text.context = { "key" => 2 }
text.ical_params["CN"] = "y"
text.ical_params["cn"] = ["y"]
text.ical_params.empty?
text.ical_params = { cn: "z" }

date = Icalendar::Values::Date.new(Date.new(2024, 1, 2))
date.value.year
date.to_s.upcase
Icalendar::Values::DateTime.new("20240102T030405Z").to_s.upcase
Icalendar::Values::Duration.new("-PT15M").past?
Icalendar::Values::Uri.new("https://example.com").value.to_s
cal_address = Icalendar::Values::CalAddress.new("mailto:me@example.com", cn: "Me")
cal_address.value.to_s
Icalendar::Values::Integer.new("3").value.succ
Icalendar::Values::Recur.new("FREQ=DAILY").valid?
Icalendar::Values::Recur.new("FREQ=DAILY").to_s.upcase
Icalendar::Values::UtcOffset.new("-0500").to_s.upcase
Icalendar::Values::UtcOffset.new("-0500").to_s.upcase

parsed_cal = Icalendar::Calendar.parse("BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n").first
parsed_event = parsed_cal&.events&.first
if parsed_event
  start = parsed_event.dtstart
  start.is_a?(Icalendar::Values::Date)
  start.to_s.strip
  start.kind_of?(Icalendar::Values::DateTime)
  parsed_event.attendee.filter_map do |attendee|
    attendee.value.is_a?(URI::MailTo)
    # @type var common_name: String | Array[String] | nil
    common_name = attendee.ical_params["cn"]
    common_name.is_a?(Array) ? common_name.first : common_name
  end
  parsed_event.organizer&.value
  parsed_event.rrule.empty?
end

parser = Icalendar::Parser.new(StringIO.new("BEGIN:VCALENDAR\r\nEND:VCALENDAR\r\n"))
parser.strict
parser.verbose
parser.source.read

custom_event = cal.add_custom_component("x_custom", Icalendar::Event.new)
custom_event.to_ical
cal.custom_component("x_custom").size
cal.add_timezone(Icalendar::Timezone.new)
tz_component = Icalendar::Timezone.new
tz_component.add_daylight(Icalendar::Timezone::Daylight.new)
tz_component.add_standard(Icalendar::Timezone::Standard.new)
tz_component.daylights.size
tz_component.standards.size
