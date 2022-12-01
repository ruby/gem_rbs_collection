# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activerecord"

module Test
  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class
  end
end
