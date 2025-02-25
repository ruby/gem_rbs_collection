Stripe.api_key = 'sk_test_12345'
Stripe.api_version = '2017-06-05'

customer = Stripe::Customer.retrieve('cus_12345')
customer.id

# address
address = customer.address
address.city if address

# charge
charge = Stripe::Charge.retrieve('ch_12345')
a = charge.amount + 1

# refund
refund = Stripe::Refund.create(charge: charge.id)
refund.status

# source
customer.sources.each do |source|
  source.id
end

# payment method
list = Stripe::Customer.list_payment_methods('cus_12345')
list.auto_paging_each do |payment_method|
  payment_method.type.upcase
end
list.each do |payment_method|
  payment_method.detach
end
if list.has_more
  list.next_page.each {}
end

# price
Stripe::Price.list('price_12345').auto_paging_each do |price|
  price.active
end
