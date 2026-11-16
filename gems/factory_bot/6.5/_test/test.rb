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
    add_attribute(:sequence) { "GATTACA" }

    initialize_with { Account.new }
    to_create { |instance| instance }
    skip_create

    before(:create) { |instance| instance }
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

  factory :empty, class: "Account"
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
registry.registered?(:owner)
registry.any?
registry.count
registry.name.upcase
registry.map { |f| f.name }.size
registry.each { |f| f.name }
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

FactoryBot.find_definitions
FactoryBot.reload
registry.clear
