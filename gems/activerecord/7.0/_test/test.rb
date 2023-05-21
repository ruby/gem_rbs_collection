# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "activerecord"

module Test
  class ApplicationRecord < ActiveRecord::Base
    primary_abstract_class
  end

  class User < ApplicationRecord
    enum status: { active: 0, inactive: 1 }, _suffix: true
    enum :role, { admin: 0, user: 1 }, _prefix: true
    enum :classify, %w[hoge fuga], _default: "hoge"
  end
end
