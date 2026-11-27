require "factory_bot"
require "active_support/time"

class Account
  def initialize
    @name = ""
    @email = nil
    @serial = nil
    @status = nil
    @sequence = nil
    @company = nil
  end

  def name
    @name
  end

  def name=(value)
    @name = value
  end

  def email
    @email
  end

  def email=(value)
    @email = value
  end

  def serial
    @serial
  end

  def serial=(value)
    @serial = value
  end

  def status
    @status
  end

  def status=(value)
    @status = value
  end

  def sequence
    @sequence
  end

  def sequence=(value)
    @sequence = value
  end

  def company
    @company
  end

  def company=(value)
    @company = value
  end

  def save!
    true
  end
end

FactoryBot.define do
  sequence(:token) { |n| "token#{n}" }
  sequence :code, 100

  trait :named do
    association :company
  end
  trait :blockless

  factory :proxy_arg, class: "Account" do |proxy|
    # @type var factory_proxy: FactoryBot::DefinitionProxy
    factory_proxy = proxy
    factory_proxy.skip_create
  end

  factory :company, class: "Account" do
    add_attribute(:name) { "Example Inc." }
  end

  factory :owner, class: "Account" do
    sequence(:email) { |n| "owner#{n}@example.com" }
    sequence :name, "a", aliases: [:label]
    sequence(:serial)
    association :company, factory: :company, strategy: :build

    transient do
      sequence(:rank)
    end

    trait :confirmed do
      association :company
    end

    traits_for_enum :status, [:active, :inactive]
    traits_for_enum "status", { pending: :pending }
    add_attribute(:sequence) { "GATTACA" }
    add_attribute("serial") { |evaluator| evaluator ? generate(:code) : 0 }
    add_attribute(:company) { association(:company, strategy: :build) || instance }

    trait :plain
    trait "archived" do
      add_attribute(:status) { :archived }
    end

    initialize_with { new }
    to_create { |instance, evaluator| [instance, evaluator] }
    skip_create

    before(:create) { |instance| instance }
    before("build") { |instance| instance }
    after(:build, :stub) do |instance, evaluator|
      instance
      evaluator
    end
    callback(:after_create) { |instance| instance }

    factory :admin_owner, aliases: [:boss], parent: :owner do
      skip_create
    end

    factory "child"
  end

  factory :empty, class: "Account" do
    initialize_with { new(**attributes.except(:name)) }
  end

  factory :seeded, class: "Account" do
    sequence("email", "a") { |n| "#{generate(:token)}-#{n}@example.com" }
    add_attribute(:name) { "seeded" }
    skip_create
  end
end

FactoryBot.modify do
  factory :owner do
    skip_create
  end
end

class AccountHelper
  include FactoryBot::Syntax::Methods

  def run
    # @type var account: Account
    account = create(:owner)
    account = create("owner", :confirmed, name: "Alice") { |instance| rename(instance) }
    account = build(:owner, { name: "Bob" })
    account = build_stubbed(:owner, :confirmed)

    # @type var attrs: Hash[Symbol, untyped]
    attrs = attributes_for(:owner, email: "x@example.com") { |h| h.keys }

    # @type var accounts: Array[Account]
    accounts = create_list(:owner, 3) { |instance, index| rename(instance, "n#{index}") }
    accounts = build_list(:owner, 2, :confirmed)
    accounts = build_stubbed_list(:owner, 2) { |instance| rename(instance) }
    accounts = create_pair(:owner, name: "pair") { |instance| rename(instance) }
    accounts = build_pair(:owner)
    accounts = build_stubbed_pair(:owner)

    # @type var attr_list: Array[Hash[Symbol, untyped]]
    attr_list = attributes_for_list(:owner, 2) { |h, index| h[:index] = index }
    attr_list = attributes_for_pair(:owner) { |h| h.size }

    # @type var token: String
    token = generate(:token)
    token = generate(:owner, :email)
    tokens = generate_list(:token, 3)
    tokens = generate_list(:owner, :email, 2, scope: account)
    tokens.size
    attrs.size
    attr_list.size
    accounts.size
  end

  def rename(instance, name = "renamed")
    # @type var account: Account
    account = instance
    account.name = name
  end
end

AccountHelper.new.run

FactoryBot.create(:owner)
FactoryBot.build(:owner)
FactoryBot.build_stubbed(:owner)
FactoryBot.attributes_for(:owner)
FactoryBot.create_list(:owner, 2)
FactoryBot.create_pair(:owner)
FactoryBot.generate(:token)
FactoryBot.define { factory(:another, class: "Account") { skip_create } }

# @type var registry: FactoryBot::Registry
registry = FactoryBot.factories
# @type var factory: FactoryBot::Factory
factory = registry.find(:owner)
factory = registry[:owner]
factory.name.to_s
# @type var registered: bool
registered = registry.registered?(:owner)
registered = registry.any?
# @type var registry_name: String
registry_name = registry.name
registry_name.upcase
registry.count
registry.map { |f| f.name }.size
registry.each { |f| f.name }
# @type var factory_enum: Enumerator[FactoryBot::Factory, void]
factory_enum = registry.each
factory_enum.next.name
registry.reject { |f| f.name == :empty }.size

FactoryBot.definition_file_paths = FactoryBot.definition_file_paths + ["spec/support/factories"]
FactoryBot.lint
FactoryBot.lint(FactoryBot.factories, strategy: :build, traits: true, verbose: true)
FactoryBot.lint(FactoryBot.factories.reject { |f| f.name == :empty }, { traits: true })

FactoryBot.rewind_sequences
FactoryBot.rewind_sequence(:owner, :email)
FactoryBot.rewind_sequence("owner/email")
FactoryBot.set_sequence(:token, 10)
FactoryBot.set_sequence(:owner, :email, 5)

FactoryBot.use_parent_strategy = false
FactoryBot.use_parent_strategy ? 1 : 0
FactoryBot.automatically_define_enum_traits = false
FactoryBot.automatically_define_enum_traits ? 1 : 0
FactoryBot.sequence_setting_timeout = 5
FactoryBot.sequence_setting_timeout + 1
FactoryBot.build_stubbed_starting_id = 1000

FactoryBot::VERSION.upcase

begin
  FactoryBot.lint
rescue FactoryBot::InvalidFactoryError => e
  e.message
rescue FactoryBot::DuplicateDefinitionError, FactoryBot::AssociationDefinitionError, FactoryBot::MethodDefinitionError
  nil
end

FactoryBot.sequence_setting_timeout = 1.5
# @type var timeout: Numeric
timeout = FactoryBot.sequence_setting_timeout
timeout.positive?

FactoryBot.rewind_sequence([:owner, :email])
FactoryBot.set_sequence([:owner, :email], 3)

# @type var names: Array[Symbol | String]
names = factory.names
# @type var human_names: Array[String]
human_names = factory.human_names
# @type var build_class: Class
build_class = factory.build_class
names.size
human_names.size
build_class.name

# @type var aliases: Array[[Regexp, String]]
aliases = FactoryBot.aliases
aliases << [/(.+)_name/, '\1']
FactoryBot.aliases = aliases
# @type var alias_names: Array[Symbol]
alias_names = FactoryBot.aliases_for(:company_id)
alias_names.size
FactoryBot.aliases_for("company").size

class JsonStrategy
  def initialize
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  def association(runner)
    runner.run
  end

  def result(evaluation)
    evaluation.notify(:after_build, nil)
    attributes = evaluation.hash
    evaluation.object
    attributes.to_s
  end

  def to_sym
    :json
  end
end

FactoryBot.register_strategy(:json, JsonStrategy)

# @type var strategy_class: Class
strategy_class = FactoryBot.strategy_by_name(:json)
strategy_class = FactoryBot::Strategy.lookup_strategy(:build)
strategy_class = FactoryBot::Strategy.lookup_strategy(JsonStrategy)
strategy_class.name

# @type var runner: FactoryBot::FactoryRunner
runner = FactoryBot::FactoryRunner.new(:owner, :build, [:confirmed, { name: "Run" }])
runner.run
runner.run(:attributes_for) { |result| result }
# @type var attributes_for_association: nil
attributes_for_association = FactoryBot::Strategy::AttributesFor.new.association(runner)
attributes_for_association = FactoryBot::Strategy::Null.new.association(runner)
runner.run(FactoryBot::Strategy::Build)

# @type var strategy_name: Symbol
strategy_name = FactoryBot::Strategy::Build.new.to_sym
strategy_name = FactoryBot::Strategy::Create.new.to_sym
strategy_name = FactoryBot::Strategy::AttributesFor.new.to_sym
strategy_name = FactoryBot::Strategy::Stub.new.to_sym
strategy_name = FactoryBot::Strategy::Null.new.to_sym
strategy_name.size
FactoryBot::Strategy::Stub.next_id = 2000

FactoryBot.find_definitions
FactoryBot.reload
registry.clear
