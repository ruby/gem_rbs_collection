require "letter_opener_web"
require "pathname"

LetterOpenerWeb.configure do |config|
  config.letters_location = Pathname.new("/var/letters").join("inbox")
end

LetterOpenerWeb.configure

config = LetterOpenerWeb.config
location = config.letters_location
location.basename
config.letters_location = Pathname.new("storage/letter_opener")

LetterOpenerWeb.reset!

version = LetterOpenerWeb::VERSION
version.upcase

LetterOpenerWeb::DeliveryMethod.superclass

engine_class = LetterOpenerWeb::Engine
engine_class.superclass

LetterOpenerWeb::LettersController.content_security_policy do |_policy|
  nil
end
LetterOpenerWeb::LettersController.after_action do
  request.content_security_policy_nonce_directives = %w[script-src]
end
