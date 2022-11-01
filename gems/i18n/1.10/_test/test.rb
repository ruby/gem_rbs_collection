# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "i18n"

I18n.load_path << Dir[File.expand_path("config/locales") + "/*.yml"]
I18n.config.available_locales = [:en, :ja]
I18n.default_locale = :en

I18n.reload!

puts I18n.default_locale #=> en

pp I18n.available_locales #=>[:en, :ja]

puts I18n.t(:test) #=> This is test!
puts I18n.t('test') #=> This is test!
puts I18n.t(:test, locale: :ja) #=> テストです。

I18n.with_locale(:ja) do
  puts I18n.t(:test) #=> テストです。
end

puts I18n.translate(:test) #=> This is test!

I18n.locale = :ja
puts I18n.t(:test) #=> テストです。

puts I18n.backend

# TODO: comment-in the following test when the `I18n.backend` type is improved
# puts I18n.backend.translate(:en, 'test') #=> This is test!
