
require "faker"

Faker::Lorem.sentence(exclude_words: 'error') + 'string'
Faker::Lorem.sentence(exclude_words: 'id, error') + 'string'
Faker::Lorem.sentence(exclude_words: ['id', 'error']) + 'string'
Faker::Lorem.paragraph(exclude_words: 'error') + 'string'
Faker::Lorem.paragraph(exclude_words: 'id, error') + 'string'
Faker::Lorem.paragraph(exclude_words: ['id', 'error']) + 'string'
Faker::Lorem.words(number: 4, exclude_words: 'id, error') + ['array', 'of', 'strings']
Faker::Lorem.words(number: 4, exclude_words: ['id', 'error']) + ['array', 'of', 'strings']
# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/lorem.md
Faker::Lorem.word + 'string'
Faker::Lorem.word(exclude_words: 'error') + 'string'
Faker::Lorem.word(exclude_words: 'id, error') + 'string'
Faker::Lorem.word(exclude_words: ['id', 'error']) + 'string'
Faker::Lorem.words + ['array', 'of', 'strings']
Faker::Lorem.words(number: 4, exclude_words: 'error') + ['array', 'of', 'strings']

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/theater.md
Faker::Theater.play + 'string'

# https://github.com/faker-ruby/faker/blob/v3.4.2/doc/default/vehicle.md
Faker::Vehicle.manufacturer + 'string'
