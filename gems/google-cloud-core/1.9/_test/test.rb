require "google/cloud"

# @type var version: String
version = Google::Cloud::Core::VERSION

# @type var gcloud: Google::Cloud
gcloud = Google::Cloud.new
gcloud = Google::Cloud.new("my-project", "keyfile.json", retries: 3, timeout: 10)

# @type var top: Google::Cloud::Config
top = Google::Cloud.configure
top = Google::Cloud.configure do |config|
  config[:project_id] = "my-project"
  config[:credentials] = { "type" => "service_account" }
end
top[:project_id]

# @type var config: Google::Cloud::Config
config = Google::Cloud::Config.create
config = Google::Cloud::Config.create(show_warnings: false) do |c|
  c.add_field! :opt0
  c.add_field! :opt1, 10
  c.add_field! :opt2, :one, enum: [:one, :two, :three]
  c.add_field! :opt3, "hi", match: [String, Symbol]
  c.add_field! :opt4, "hi", match: /^[a-z]+$/, allow_nil: true
  c.add_field! :opt5, 1, validator: ->(value) { Integer === value }
  c.add_field!("opt6", 2) { |value| Integer === value }
  c.add_field! :opt7, nil, { match: Object }
  c.add_config! :sub do |sub|
    sub.add_field! :flag, false
  end
end

# @type var chained: Google::Cloud::Config
chained = config.add_alias!(:opt1_alias, :opt1)
chained = config.add_config!(:attached, Google::Cloud::Config.create)
chained = config.reset!(:opt1)
chained = config.reset!
chained = config.delete!(:opt7)

# @type var is_config: bool
is_config = Google::Cloud::Config.config?(config)

# @type var assigned: Integer
assigned = config[:opt1] = 20
config["opt2"] = :two
config[:opt1]

# @type var flag: bool
flag = config.value_set?(:opt1)
flag = config.option?("opt1")
flag = config.field?(:opt1)
flag = config.respond_to?(:opt1)
flag = config.subconfig?(:sub)

# @type var target: Symbol?
target = config.alias?(:opt1_alias)

# @type var keys: Array[Symbol]
keys = config.fields!
keys = config.subconfigs!
keys = config.aliases!

# @type var text: String
text = config.to_s!
text = config.inspect

# @type var hash: Hash[Symbol, String | Hash[Symbol, untyped]]
hash = config.to_h!

config.delete!
