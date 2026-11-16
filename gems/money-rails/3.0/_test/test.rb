require "money-rails"

MoneyRails.configure do |config|
  config.default_currency = :usd
  config.rounding_mode = BigDecimal::ROUND_HALF_UP
  config.no_cents_if_whole = false
  config.include_validations = true
  config.raise_error_on_money_parsing = true
  config.preserve_user_input = false
  config.symbol = true
  config.sign_before_symbol = false
  config.default_format = { no_cents_if_whole: nil, symbol: nil }
  config.amount_column = { postfix: "_cents", type: :integer, null: false, default: 0, present: true }
  config.currency_column = { postfix: "_currency", type: :string, null: false, default: "USD", present: true }
  config.register_currency = { priority: 1, iso_code: "EU4", name: "Euro with subunit of 4 digits", symbol: "E", subunit_to_unit: 10000 }
  config.default_bank = Money::Bank::VariableExchange.new
  config.add_rate "USD", "CAD", 1.24515
  config.locale_backend = :i18n
end

MoneyRails.configure do |config|
  config.default_currency = -> { :eur }
end

MoneyRails.default_currency = "EUR"
MoneyRails.rounding_mode = BigDecimal::ROUND_UP
MoneyRails.add_rate :usd, :eur, 0.9

# @type var currency: Money::Currency?
currency = MoneyRails.default_currency
currency&.iso_code

# @type var validations: bool
validations = MoneyRails.include_validations
# @type var amount_column: Hash[Symbol, untyped]
amount_column = MoneyRails.amount_column
# @type var currency_column: Hash[Symbol, untyped]
currency_column = MoneyRails.currency_column
# @type var cents_if_whole: bool?
cents_if_whole = MoneyRails.no_cents_if_whole
# @type var symbol: (bool | String)?
symbol = MoneyRails.symbol
# @type var before_symbol: bool?
before_symbol = MoneyRails.sign_before_symbol
# @type var default_format: Hash[Symbol, untyped]?
default_format = MoneyRails.default_format
# @type var raise_on_parse: bool
raise_on_parse = MoneyRails.raise_error_on_money_parsing
# @type var preserve_input: bool
preserve_input = MoneyRails.preserve_user_input
# @type var bank: Money::Bank::Base
bank = MoneyRails.default_bank
bank.same_currency?(:usd, :eur)
# @type var backend: Money::LocaleBackend::Base?
backend = MoneyRails.locale_backend
backend.nil?

class DeliveryFee
  def call(_product)
    :gbp
  end
end

module OptionalPrice
  def self.call(_product)
    "EUR"
  end
end

class Product < ActiveRecord::Base
  register_currency :eur

  monetize :price_cents
  monetize :discount_subunit, as: "discount"
  monetize :bonus_cents, with_currency: :gbp
  monetize :tax_cents, with_currency: ->(_product) { :gbp }
  monetize :delivery_fee_cents, with_currency: DeliveryFee.new
  monetize :optional_price_cents, with_currency: OptionalPrice, allow_nil: true
  monetize :amount_cents, :refund_cents, with_model_currency: :currency
  monetize :fee_cents, disable_validation: true, allow_nil: true
  monetize :range_cents,
    subunit_numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 },
    numericality: { greater_than_or_equal_to: 0, message: "is out of range" }
  monetize :plain_cents, numericality: false, subunit_numericality: false
end

attributes = Product.monetized_attributes
# @type var subunit: String?
subunit = attributes["price"]

class Order < ActiveRecord::Base
  register_currency "usd"
  register_currency Money::Currency.new("JPY")
end

class AddPriceToProducts < ActiveRecord::Migration[8.1]
  def change
    add_monetize :products, :price
    add_monetize :products, :cost, currency: { present: false }
    add_money :products, :tax
    remove_monetize :products, :old_price
    remove_money :products, :old_tax

    create_table :orders do |t|
      define_order_columns(t)
    end

    change_table :orders do |t|
      change_order_columns(t)
    end
  end

  def define_order_columns(table)
    table.monetize :total
    table.money :shipping, amount: { null: true }
    table.remove_monetize :legacy
    table.remove_money :legacy_shipping
  end

  def change_order_columns(table)
    table.monetize :subtotal, currency: { present: false }
  end
end

module PriceHelper
  include MoneyRails::ActionViewExtension

  def format_price(money, number)
    # @type var symbol_html: String
    symbol_html = currency_symbol
    symbol_html = currency_symbol(:eur)
    symbol_html = currency_symbol(Money::Currency.new("USD"))

    # @type var humanized: String
    humanized = humanized_money(money)
    humanized = humanized_money(money, symbol: true, no_cents_if_whole: false)
    humanized = humanized_money(number)
    humanized = humanized_money(nil)
    # @type var with_symbol: String
    with_symbol = humanized_money_with_symbol(money)
    with_symbol = humanized_money_with_symbol(money, disambiguate: true)
    # @type var no_cents: String
    no_cents = money_without_cents(money)
    no_cents = money_without_cents("1.5", symbol: true)
    # @type var no_cents_symbol: String
    no_cents_symbol = money_without_cents_and_with_symbol(money)
    # @type var only_cents: String
    only_cents = money_only_cents(money)
    only_cents = money_only_cents(number)

    [symbol_html, humanized, with_symbol, no_cents, no_cents_symbol, only_cents].map(&:upcase).join
  end
end

# @type var money_hash: { cents: Integer, currency_iso: String }
money_hash = Money.new(100, "EUR").to_hash
money_hash[:currency_iso].upcase

MoneyRails::VERSION.upcase

begin
  raise MoneyRails::Error, "invalid money"
rescue MoneyRails::ActiveRecord::Monetizable::ReadOnlyCurrencyException => e
  e.message.upcase
rescue MoneyRails::Error => e
  e.message.upcase
end
