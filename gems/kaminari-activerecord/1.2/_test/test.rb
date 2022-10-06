# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "kaminari-activerecord"

class User < ActiveRecord::Base
  paginates_per 10
  max_paginates_per 100
  max_pages 1000
end

User.page(1)
User.default_per_page
User.max_per_page
User.max_pages
