
require "faker"

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/alphanumeric.md
Faker::Alphanumeric.alpha(number: 10) + 'string'
Faker::Alphanumeric.alphanumeric(number: 10) + 'string'
Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3) + 'string'
Faker::Alphanumeric.alphanumeric(number: 10, min_alpha: 3, min_numeric: 3) + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/books/book.md
Faker::Book.title + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/company.md
Faker::Company.catch_phrase + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/educator.md
Faker::Educator.degree + 'string'
Faker::Educator.subject + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/internet.md
Faker::Internet.email + 'string'
Faker::Internet.email(name: 'Nancy') + 'string'
Faker::Internet.email(name: 'Janelle Santiago', separators: ['+']) + 'string'
Faker::Internet.email(domain: 'gmail.com')  + 'string'
Faker::Internet.email(name: 'sam smith', separators: ['-'], domain: 'test') + 'string'
Faker::Internet.url + 'string'
Faker::Internet.url + 'string'
Faker::Internet.url(host: 'faker') + 'string'
Faker::Internet.url(host: 'example.com') + 'string'
Faker::Internet.url(host: 'example.com', path: '/foobar.html') + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/job.md
Faker::Job.title + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/lorem.md
Faker::Lorem.sentence + 'string'
Faker::Lorem.sentence(word_count: 3) + 'string'
Faker::Lorem.sentence(word_count: 3, supplemental: true) + 'string'
Faker::Lorem.sentence(word_count: 3, supplemental: false, random_words_to_add: 4) + 'string'
Faker::Lorem.sentence(word_count: 3, supplemental: true, random_words_to_add: 4) + 'string'

Faker::Lorem.paragraph + 'string'
Faker::Lorem.paragraph(sentence_count: 2) + 'string'
Faker::Lorem.paragraph(sentence_count: 2, supplemental: true) + 'string'
Faker::Lorem.paragraph(sentence_count: 2, supplemental: false, random_sentences_to_add: 4) + 'string'
Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 4) + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/marketing.md
Faker::Marketing.buzzwords + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/name.md
Faker::Name.first_name + 'string'
Faker::Name.last_name + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/phone_number.md
Faker::PhoneNumber.cell_phone + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/university.md
Faker::University.name + 'string'
