require "flipper"
require "flipper/adapters/active_record"

Flipper.configure do |config|
  config.adapter { Flipper::Adapters::ActiveRecord.new }
end

adapter = Flipper::Adapters::ActiveRecord.new
adapter.name.to_s

custom = Flipper::Adapters::ActiveRecord.new(
  name: :custom,
  feature_class: Flipper::Adapters::ActiveRecord::Feature,
  gate_class: Flipper::Adapters::ActiveRecord::Gate
)
custom.name.to_s

# @type var options: Hash[Symbol, untyped]
options = { name: :from_hash }
Flipper::Adapters::ActiveRecord.new(options).name.to_s

adapter.default_config

Flipper::Adapters::ActiveRecord::Feature.table_name.upcase
Flipper::Adapters::ActiveRecord::Gate.table_name.upcase

Flipper::Adapters::ActiveRecord::Feature.find_or_create_by(key: "search").persisted? ? 1 : 2
Flipper::Adapters::ActiveRecord::Gate.find_or_create_by(feature_key: "search", key: "actors").persisted? ? 1 : 2
