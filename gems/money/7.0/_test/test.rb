require "money"

money = Money.new(1000, "USD")
# @type var cents: Integer | BigDecimal
cents = money.cents
# @type var currency: Money::Currency
currency = money.currency
# @type var iso_code: String
iso_code = currency.iso_code

Money.new(1000, Money::Currency.new(:eur)).currency.iso_code.upcase
Money.new("10.5", :jpy, {}).amount.round
Money.new(Money.new(5, :usd), :usd).amount.floor
Money.from_cents(250, "EUR").fractional
Money.from_amount(12.5, "EUR").amount.floor
Money.empty(:usd).zero?
Money.us_dollar(100).currency.iso_code.upcase
Money.ca_dollar(100).currency.iso_code.upcase
Money.euro(100).currency.iso_code.upcase
Money.pound_sterling(100).currency.iso_code.upcase
iso_code.upcase

Money.default_currency = "EUR"
Money.default_currency = Money::Currency.new(:usd)
Money.default_currency = -> { :jpy }
Money.default_currency&.iso_code&.upcase
Money.default_currency = "USD"
Money.default_currency = nil
Money.default_currency = "USD"
Money.new(1000, nil).bank
Money.zero.zero?
Money.default_infinite_precision = true
Money.default_infinite_precision.!
Money.conversion_precision = 8
Money.conversion_precision.succ
Money.strict_eql_compare = false
Money.strict_eql_compare.!
Money.default_formatting_rules = { display_free: true }
Money.default_formatting_rules&.keys
Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.rounding_mode = :half_up
Money.rounding_mode.to_s
Money.locale_backend = :i18n
Money.locale_backend = nil
Money.locale_backend.nil?

bank = Money::Bank::VariableExchange.new
Money.default_bank = bank
Money.default_bank = -> { bank }
Money.add_rate("USD", "EUR", 0.9).floor
Money.default_bank.exchange_with(money, :eur).currency.iso_code.upcase
Money.default_bank.same_currency?(:usd, "EUR")
Money::Bank::VariableExchange.instance.add_rate(:usd, :eur, 0.9).floor
Money::Bank::VariableExchange.new { |n| n.round }.rounding_method&.call(1.5)&.floor
bank.add_rate(:usd, :eur, 0.9).floor
bank.set_rate(:usd, :eur, 0.9, {}).floor
bank.get_rate(:usd, :eur)&.floor
bank.rates.keys
bank.store
Money.with_bank(bank) { Money.new(100, :usd).exchange_to(:eur) }.cents
Money.with_rounding_mode(:half_even) { money.round }.cents
Money.add_rate(Money::Currency.new(:usd), Money::Currency.new(:eur), 1)

begin
  money.exchange_to(:eur)
rescue Money::Bank::UnknownRate, Money::Bank::DifferentCurrencyError => e
  e.message
rescue Money::Currency::UnknownCurrency, Money::Currency::NoCurrency => e
  e.message
rescue Money::UndefinedSmallestDenomination, Money::LocaleBackend::NotSupported => e
  e.message
end

Money::Currency.find(:usd)&.iso_code
Money::Currency.find_by_iso_numeric("840")&.name
Money::Currency.wrap(nil)
Money::Currency.wrap("usd").iso_code
Money::Currency.all.first&.name
Money::Currency.map(&:iso_code)
Money::Currency.each { |c| c.iso_code }
Money::Currency.register({ priority: 1, iso_code: "XYZ", name: "Xyz", subunit_to_unit: 100 })
Money::Currency.inherit("USD", { iso_code: "XUS", name: "Xus" })
Money::Currency.unregister("XYZ")
currency.id.to_s
currency.priority&.succ
currency.iso_numeric&.to_i
currency.name.upcase
currency.symbol&.upcase
currency.disambiguate_symbol&.upcase
currency.html_entity&.upcase
currency.subunit&.upcase
currency.subunit_to_unit.succ
currency.decimal_mark.upcase
currency.thousands_separator.upcase
currency.symbol_first.!
currency.smallest_denomination&.succ
currency.to_s.upcase
currency.to_str.upcase
currency.to_sym.to_proc
currency.to_currency.iso_code
currency.code.upcase
currency.symbol_first?
currency.iso?
currency.cents_based?
currency.exponent.succ
currency.decimal_places.succ
currency.separator.upcase
currency.delimiter.upcase
currency.inspect.upcase
currency.hash.succ
currency == Money::Currency.new(:usd)
currency.eql?(currency)
currency <=> Money::Currency.new(:usd)
currency.subunit_to_unit * 2

# @type var price: Money
price = Money.new(1999, :usd)
price.fractional.floor
price.amount.to_s
price.format.upcase
price.format(symbol: false, no_cents: true).upcase
price.to_s.upcase
price.to_d.floor
price.to_i.succ
price.to_f.floor
price.to_money.cents
price.to_money(:eur).cents
price.symbol.upcase
price.inspect.upcase
price.hash.succ
price.bank.same_currency?(:usd, :usd)
price.with_currency(:eur).cents
price.exchange_to(:eur).cents
price.exchange_to("EUR") { |amount| amount.round }.cents
price.as_us_dollar.cents
bank.add_rate(:usd, :cad, 1.25)
price.as_ca_dollar.cents
price.as_euro.cents
price.allocate([1, 2]).first&.cents
price.allocate(3).map(&:cents)
price.split(2).map(&:cents)
price.round.cents
price.round(:half_up, 1).cents
price.to_nearest_cash_value.cents
price.thousands_separator.upcase
price.decimal_mark.upcase

(-price).cents
(price + price).cents
(price + 0).cents
(price - price).cents
(price - 0).cents
(price * 2).cents
(price / 2).cents
(price / price).floor
price.div(2).cents
price.div(price).floor
# @type var quotient: Integer
quotient, remainder = price.divmod(price)
remainder.cents
# @type var parts: [Money, Money]
parts = price.divmod(3)
price.modulo(3).cents
(price % price).cents
price.remainder(3).cents
price.abs.cents
price.zero?
price.nonzero?&.cents
price.positive?
price.negative?
price <=> price
price == price
price.eql?(price)
price > price
price.between?(price, price)

Money.from_dollars(3, :usd).dollars.floor # steep:ignore DeprecatedReference
Money.new(150, :usd).round_to_nearest_cash_value.floor # steep:ignore DeprecatedReference

Money.disallow_currency_conversion!
