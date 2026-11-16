require "countries"

Countries::VERSION.upcase

ISO3166.configure do |config|
  config.locales = [:en, :de, :fr, :es]
  config.locales = ["en", "ja"]
  locales = config.locales #: Array[Symbol]
  locales.first&.to_s
end
ISO3166.configuration = ISO3166::Configuration.new
ISO3166.configuration.locales.map(&:to_sym)
ISO3166.reset

# Looking up countries
country = ISO3166::Country.new("US") #: ISO3166::Country?
if country
  country.alpha2.upcase
  country.alpha3.upcase
  country.number.upcase
  country.gec&.upcase
  country.ioc&.upcase
  country.un_locode&.upcase
  country.iso_short_name.upcase
  country.iso_short_name_lower_case.upcase
  country.iso_long_name&.upcase
  country.common_name&.upcase
  country.nationality&.upcase
  country.unofficial_names&.first&.upcase
  country.currency_code&.downcase
  country.country_code&.to_i
  country.address_format&.lines
  country.continent&.upcase
  country.region&.upcase
  country.subregion&.upcase
  country.world_region&.upcase
  country.distance_unit&.upcase
  country.start_of_week.upcase
  country.vehicle_registration_code&.upcase
  country.international_prefix&.upcase
  country.national_prefix&.upcase
  country.nanp_prefix&.upcase
  country.national_destination_code_lengths.sum
  country.national_number_lengths.sum
  country.languages_official.first&.upcase
  country.languages_spoken.first&.upcase
  country.postal_code.nil?
  country.postal_code_format&.upcase
  country.vat_rates&.keys
  country.geo.keys
  country.latitude&.round
  country.longitude&.round
  country.min_latitude&.round
  country.min_longitude&.round
  country.max_latitude&.round
  country.max_longitude&.round
  country.bounds&.keys
  country.data.fetch("alpha2")
  names = country.data["unofficial_names"] #: Array[String]
  names << "United States of America"
  country["alpha2"]
  country[:alpha3]

  country.valid?
  country == ISO3166::Country.new("JP")
  country.eql?(country)
  country.hash.zero?
  country <=> country
  country.to_s.upcase
  country.emoji_flag.length

  country.in_eu?
  country.in_g7?
  country.in_g20?
  country.in_eea?
  country.in_esm?
  country.in_eu_vat?
  country.in_un?
  country.gdpr_compliant?

  country.translation("de")&.upcase
  country.translation(:de)&.upcase
  country.translation&.upcase
  country.translated_names.first&.upcase
  country.translations[:fr]&.upcase
  country.translations["fr"]&.upcase
  country.translations.keys.first&.to_s
  country.local_names.first&.upcase
  country.local_name&.upcase
end

# Subdivisions
canada = ISO3166::Country["CA"]
if canada
  # @type var subdivisions: Hash[String, ISO3166::Subdivision]
  subdivisions = canada.subdivisions
  subdivisions["ON"]&.name&.upcase
  subdivisions.values.map(&:code)
  canada.subdivisions?
  canada.subdivision_types.first&.upcase
  canada.humanized_subdivision_types.first&.upcase
  canada.subdivisions_of_types(["province"]).keys
  canada.subdivision_names.first&.upcase
  canada.subdivision_names("fr").first&.upcase
  canada.subdivision_names_with_codes.each do |name, code|
    name.upcase
    code.upcase
  end
  canada.subdivision_names_with_codes(:en).first
  canada.subdivision_for_string?("Ontario")

  subdivision = canada.find_subdivision_by_name("Ontario")
  if subdivision
    subdivision.name.upcase
    subdivision.code&.upcase
    subdivision.unofficial_names&.first&.upcase
    subdivision.geo&.keys
    subdivision.translations[:en]&.upcase
    subdivision.comments&.upcase
    subdivision.type&.upcase
    subdivision["name"]
    subdivision.code_with_translations.keys
    subdivision.match?("Ontario")
  end
end

# Finders
ISO3166::Country["jp"]&.alpha3
ISO3166::Country[:jp]&.alpha3
ISO3166::Country.search("jp")&.alpha3
ISO3166::Country.search(:jp)&.alpha3
ISO3166::Country.new(:jp)&.alpha3
ISO3166::Country.new({ "alpha2" => "ZZ" })&.alpha2
ISO3166::Country.find_country_by_alpha2("FR")&.alpha3
ISO3166::Country.find_country_by_alpha3("FRA")&.alpha2
ISO3166::Country.find_country_by_number("250")&.alpha2
ISO3166::Country.find_country_by_iso_short_name("italy")&.alpha2
ISO3166::Country.find_country_by_iso_long_name("Italian Republic")&.alpha2
ISO3166::Country.find_country_by_any_name("united states")&.alpha2
ISO3166::Country.find_country_by_any_name(/france/)&.alpha2
ISO3166::Country.find_country_by_country_code("81")&.alpha2
ISO3166::Country.find_country_by_currency_code("JPY")&.alpha2
ISO3166::Country.find_all_countries_by_alpha2("FR").first&.alpha2
ISO3166::Country.find_all_countries_by_alpha3("FRA").first&.alpha2
ISO3166::Country.find_all_countries_by_number("250").first&.alpha2
ISO3166::Country.find_all_countries_by_iso_short_name("italy").first&.alpha2
ISO3166::Country.find_all_countries_by_iso_long_name("Italian Republic").first&.alpha2
ISO3166::Country.find_all_countries_by_any_name("korea").map(&:alpha2)
ISO3166::Country.find_all_countries_by_country_code("1").map(&:alpha2)
ISO3166::Country.find_all_countries_by_currency_code("EUR").map(&:alpha2)
ISO3166::Country.find_all_countries_by_region("Americas").map(&:alpha2)
ISO3166::Country.find_all_countries_by_subregion("Northern America").map(&:alpha2)
ISO3166::Country.find_all_countries_by_continent("Europe").map(&:alpha2)
ISO3166::Country.find_all_by(:translated_names, "França").keys
ISO3166::Country.find_all_by("alpha2", "FR").values.first&.keys

# Listing
ISO3166::Country.codes.include?("US")
ISO3166::Country.all.map(&:alpha2)
ISO3166::Country.all.to_h { |item| [item.alpha2, item.common_name] }
ISO3166::Country.all { |alpha2, data| [alpha2.upcase, data.keys] }
ISO3166::Country.all_names_with_codes.each do |name, code|
  name.upcase
  code.upcase
end
ISO3166::Country.all_names_with_codes("de").first
ISO3166::Country.all_translated.first&.upcase
ISO3166::Country.all_translated(:de).first&.upcase
ISO3166::Country.translations["DE"]&.upcase
ISO3166::Country.translations("de").keys
ISO3166::Country.pluck(:alpha2, :iso_short_name).first
ISO3166::Country.pluck("alpha2").first
ISO3166::Country.collect_countries_with("VR", :subdivisions, :common_name)
ISO3166::Country.collect_countries_with("Europe", :continent)
ISO3166::Country.collect_likely_countries_by_subdivision_name("Ontario", :common_name)
ISO3166::Country.collect_likely_countries_by_subdivision_name("Ontario")
ISO3166::Country.from_alpha2_to_alpha3("US")&.upcase
ISO3166::Country.from_alpha3_to_alpha2("USA")&.upcase

# Custom data
registered = ISO3166::Data.register(
  alpha2: "QZ",
  alpha3: "QZZ",
  continent: "Oceania",
  translations: { "en" => "Atlantis", "ja" => "アトランティス" }
)
registered.keys
ISO3166::Data.unregister("QZ")&.keys
ISO3166::Data.unregister(:qz)
ISO3166::Data.cache.keys
ISO3166::Data.codes.first&.upcase
ISO3166::Data.reset
