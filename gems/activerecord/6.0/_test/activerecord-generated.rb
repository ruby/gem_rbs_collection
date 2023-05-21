class User < ActiveRecord::Base
  enum status: { active: 0, inactive: 1 }, _suffix: true
end

user = User.new
