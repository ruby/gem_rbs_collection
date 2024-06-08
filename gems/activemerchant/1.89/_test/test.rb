# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activemerchant"

ActiveMerchant::Billing::CreditCard.brand?("4111111111111111")&.upcase

ActiveMerchant::Billing::CreditCard.new
credit_card = ActiveMerchant::Billing::CreditCard.new(
  :first_name         => 'Bob',
  :last_name          => 'Bobsen',
  :number             => '4242424242424242',
  :month              => '8',
  :year               => Time.now.year+1,
  :verification_value => '000'
)
credit_card.validate.empty?

ActiveMerchant::Billing::CreditCard.card_companies.sample&.capitalize
