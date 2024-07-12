# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "tzinfo"

TZInfo::DataSource.set(:ruby)
TZInfo::DataSource.set(:zoneinfo)
TZInfo::DataSource.set(:zoneinfo, 'zoneinfo_dir')
TZInfo::DataSource.set(:zoneinfo, 'zoneinfo_dir', 'iso3166_tab_file')

TZInfo::Country.all.sort{|a,b| a <=> b }

# @type var identifiers: Array[String]
identifiers = TZInfo::Timezone.all_identifiers
# @type var tz: TZInfo::Timezone
tz = TZInfo::Timezone.get('America/New_York')
# @type var t: TZInfo::TimeWithOffset
t = tz.to_local(Time.utc(2018, 2, 1, 12, 30, 0))
t = tz.local_time(2018, 2, 1, 7, 30, 0)
t = tz.local_time(2018, 2, 1, 7, 30, 0).utc
t = tz.to_local(Time.utc(2018, 2, 1, 12, 30, 0))
t.utc_offset
t.dst?
t.zone
# @type var t_raw: ::Time
t_raw = tz.local_to_utc(Time.utc(2018, 2, 1, 7, 30, 0))
# @type var s: String
s = tz.to_local(Time.utc(2018, 2, 1, 12, 30, 0)).strftime('%Y-%m-%d %H:%M:%S %z %Z')
# @type var period: TZInfo::TimezonePeriod
period = tz.period_for(Time.utc(2018, 7, 1, 12, 30, 0))
period.base_utc_offset
period.std_offset
period.observed_utc_offset
period.abbreviation
period.dst?
period.local_starts_at&.to_time
period.local_ends_at&.to_time
# @type var transitions: Array[TZInfo::TimezoneTransition]
transitions = tz.transitions_up_to(Time.utc(2019, 1, 1), Time.utc(2017, 1, 1))
transitions.map do |t|
  [t.local_end_at.to_time, t.offset.observed_utc_offset, t.offset.abbreviation]
end
# @type var offsets: Array[TZInfo::TimezoneOffset]
offsets = tz.offsets_up_to(Time.utc(2019, 1, 1))
offsets.map {|o| [o.observed_utc_offset, o.abbreviation] }

t = tz.to_local(Time.utc(2018, 7, 1, 12, 30, 0))
# @type var dt: TZInfo::DateTimeWithOffset
dt = tz.to_local(DateTime.new(2018, 7, 1, 12, 30, 0))
dt = tz.local_datetime(2018, 2, 1, 7, 30, 0)
# @type var ts: TZInfo::TimestampWithOffset
ts = tz.to_local(TZInfo::Timestamp.create(2018, 7, 1, 12, 30, 0, 0, :utc))
ts = tz.local_timestamp(2018, 2, 1, 7, 30, 0)

t = tz.local_time(2018, 11, 4, 1, 30, 0, 0, true)
t = tz.local_time(2018, 11, 4, 1, 30, 0, 0) {|p| p.first }
TZInfo::Timezone.default_dst = true

TZInfo::Country.all_codes
# @type var c: TZInfo::Country
c = TZInfo::Country.get('US')
c.name
c.zone_identifiers

c.zone_info.each do |zi|
  zi.identifier
  zi.latitude.to_f.round(5)
  zi.longitude.to_f.round(5)
  zi.description
end
