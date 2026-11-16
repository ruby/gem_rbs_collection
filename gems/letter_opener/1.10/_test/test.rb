require "letter_opener"
require "mail"

delivery_method = LetterOpener::DeliveryMethod.new(location: "/tmp/letters")
delivery_method.deliver!(Mail.new(from: "a@example.com", to: "b@example.com", subject: "hi", body: "hello"))

settings = delivery_method.settings
settings = settings.merge(location: "/tmp/other")
delivery_method.settings = settings

begin
  LetterOpener::DeliveryMethod.new
rescue LetterOpener::DeliveryMethod::InvalidOption => e
  message = e.message
  message.upcase
end
