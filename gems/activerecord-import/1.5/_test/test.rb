# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activerecord"
require "activerecord-import"

class Book < ActiveRecord::Base
end

# @type var books: Array[Book]

books = []
10.times do |i|
  books << Book.new
end
Book.import books    # or use import!

columns = [ :title, :author ]
values = [ ['Book1', 'George Orwell'], ['Book2', 'Bob Jones'] ]

# Importing without model validations
Book.import columns, values, validate: false

# Import with model validations
Book.import columns, values, validate: true

# when not specified :validate defaults to true
Book.import columns, values

values = [{ title: 'Book1', author: 'George Orwell' }, { title: 'Book2', author: 'Bob Jones'}]

# Importing without model validations
Book.import values, validate: false

# Import with model validations
Book.import values, validate: true

# when not specified :validate defaults to true
Book.import values
