require "stripe"

Stripe.api_key = "sk_test_12345"
Stripe.api_version = "2025-09-30.clover"
Stripe.max_network_retries = 2

customer = Stripe::Customer.retrieve("cus_12345")
customer.id.upcase
customer.email&.upcase
customer.address&.city
customer.invoice_settings&.default_payment_method

# Map-like fields come back as StripeObject with Symbol keys, not Hash.
metadata = customer.metadata
if metadata
  metadata["plan"]
  metadata[:plan]
  metadata.keys.map(&:to_s)
  metadata.to_hash.each { |key, _value| key.to_s }
end
Stripe::Price.retrieve("price_123").currency_options&.each { |currency, _options| currency.to_s }

Stripe::Customer.create({ email: "a@example.com" }, { api_key: "sk_test_other" })
Stripe::Customer.create({ email: "a@example.com" }, "sk_test_other")

Stripe::Customer.list({ limit: 3 }).auto_paging_each do |c|
  c.email&.upcase
end
Stripe::Customer.list_payment_methods("cus_12345").each do |payment_method|
  payment_method.type.upcase
end
Stripe::Customer.search({ query: "email:'a@example.com'" }).data.first&.id
Stripe::Customer.retrieve("cus_12345").tax_ids&.each { |tax_id| tax_id.value }

list = Stripe::Price.list
list.next_page.each { |price| price.active } if list.has_more

charge = Stripe::Charge.retrieve("ch_12345")
charge.amount + 1
Stripe::Refund.create({ charge: charge.id }).status

client = Stripe::StripeClient.new("sk_test_12345", stripe_version: "2025-09-30.clover")
client.v1.customers.retrieve("cus_12345").balance&.+(1)
client.v1.customers.list.each { |c| c.id }
client.v1.setup_attempts.list({ setup_intent: "seti_123" }).each { |attempt| attempt.status }
client.v2.core.events.list.each { |event| event.id }

begin
  Stripe::Charge.create({ amount: 100, currency: "usd" })
rescue Stripe::CardError => e
  e.code&.length
  e.param
  e.http_status
rescue Stripe::StripeError => e
  e.message
end

# Snapshot events, as in https://docs.stripe.com/webhooks
event = Stripe::Webhook.construct_event("{}", "t=1,v1=sig", "whsec_123")
case event.type
when "payment_intent.succeeded"
  # @type var payment_intent: Stripe::PaymentIntent
  payment_intent = event.data.object
  payment_intent.amount + 1
when "customer.created"
  # @type var created: Stripe::Customer
  created = event.data.object
  client.v1.customers.retrieve(created.id, {}, { api_key: "sk_test_other" })
end

# Thin events, as in examples/event_notification_webhook_handler.rb
event_notification = client.parse_event_notification("{}", "t=1,v1=sig", "whsec_123")
if event_notification.instance_of?(Stripe::Events::V1BillingMeterErrorReportTriggeredEventNotification)
  event_notification.related_object.id
  # @type var meter: Stripe::Billing::Meter
  meter = event_notification.fetch_related_object
  meter.display_name.upcase
  # @type var full_event: Stripe::Events::V1BillingMeterErrorReportTriggeredEvent
  full_event = event_notification.fetch_event
  full_event.id
elsif event_notification.instance_of?(Stripe::Events::UnknownEventNotification)
  event_notification.type == "some.new.event"
end

handler = client.notification_handler("whsec_123") do |notification, _client, details|
  details.is_known_event_type
  notification.id
end
handler.on_v1_customer_created do |notification, _client|
  notification.related_object.url
end
handler.on_v1_balance_available do |notification, _client|
  notification.related_object.url
end
