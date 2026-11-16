# It is type checked by `steep check` command.

require "maxminddb"

# These calls read database files that do not exist here, so they are type checked but never run.
# @type var use_databases: ^() -> void
use_databases = -> do
  db = MaxMindDB.new("./GeoLite2-City.mmdb")
  low_memory_db = MaxMindDB.new("./GeoLite2-City.mmdb", MaxMindDB::LOW_MEMORY_FILE_READER)
  default_reader_db = MaxMindDB.new("./GeoLite2-Country.mmdb", MaxMindDB::DEFAULT_FILE_READER)
  custom_reader_db = MaxMindDB.new("./GeoLite2-ASN.mmdb", ->(path) { File.binread(path) })

  # @type var client: MaxMindDB::Client
  client = low_memory_db

  db.local_ip_alias = "74.125.225.224"
  # @type var alias_ip: String?
  alias_ip = db.local_ip_alias

  # @type var metadata: Hash[String, untyped]
  metadata = db.metadata
  metadata["build_epoch"]

  # @type var ret: MaxMindDB::Result
  ret = db.lookup("74.125.225.224")
  ret = db.lookup("2001:4860:4860::8888")
  ret = db.lookup(1_249_763_808)
  ret = default_reader_db.lookup("127.0.0.1")
  ret = custom_reader_db.lookup("::1")
  ret = client.lookup("192.0.2.1")

  # @type var found: bool
  found = ret.found?
  ret["country"]

  if ret.found?
    # @type var country_name: String?
    country_name = ret.country.name
    # @type var localized_name: String?
    localized_name = ret.country.name("zh-CN")
    # @type var symbol_name: String?
    symbol_name = ret.city.name(:fr)
    ret.country.iso_code&.upcase
    ret.country.code&.upcase
    # @type var geoname_id: Integer?
    geoname_id = ret.country.geoname_id
    # @type var in_eu: bool?
    in_eu = ret.country.is_in_european_union

    ret.continent.name&.upcase
    ret.continent.code&.upcase
    ret.continent.geoname_id&.succ
    ret.registered_country.iso_code&.upcase
    ret.represented_country.iso_code&.upcase
    ret.city.geoname_id&.succ

    ret.location.latitude&.round(2)
    ret.location.longitude&.round(2)
    ret.location.metro_code&.succ
    ret.location.time_zone&.upcase
    ret.location.accuracy_radius&.succ

    ret.postal.code&.upcase

    # @type var subdivisions: MaxMindDB::Result::Subdivisions
    subdivisions = ret.subdivisions
    # @type var most_specific: MaxMindDB::Result::NamedLocation
    most_specific = subdivisions.most_specific
    most_specific.name("en")&.upcase
    subdivisions.map(&:geoname_id).compact.sum
    subdivisions.each { |subdivision| subdivision.iso_code&.upcase }

    ret.traits.is_anonymous_proxy
    ret.traits.is_satellite_provider

    ret.connection_type&.upcase
    ret.network&.upcase

    # @type var hash: Hash[String, untyped]
    hash = ret.to_hash
    hash.empty?
  end
end

MaxMindDB::VERSION.split(".")
