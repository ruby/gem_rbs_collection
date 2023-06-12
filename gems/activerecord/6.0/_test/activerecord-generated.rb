class User < ActiveRecord::Base
  enum status: { active: 0, inactive: 1 }, _suffix: true
  enum role: { admin: 0, user: 1 }, _prefix: :user_role
end

user = User.new
