# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "faker"

Faker::Address.street_name + 'string'
Faker::Address.secondary_address + 'string'
Faker::Address.building_number + 'string'
Faker::Address.community + 'string'
Faker::Address.mail_box + 'string'
Faker::Name.name + 'string'
Faker::Internet.email
Faker::Name.unique == Faker::Name
Faker::Name.unique.clear
Faker::UniqueGenerator.clear
Faker::Lorem.unique.exclude :string, [number: 6], %w[azerty wxcvbn]

Faker::Config.random = Random.new(42)
Faker::Company.bs + 'string'
Faker::Company.name + 'string'
Faker::Config.random = nil

Faker::Config.locale = 'es'
Faker::Config.locale = :es
