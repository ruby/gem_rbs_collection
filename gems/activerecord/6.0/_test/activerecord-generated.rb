class User < ActiveRecord::Base
  enum status: { active: 0, inactive: 1 }, _suffix: true
  enum role: { admin: 0, user: 1 }, _prefix: :user_role

  before_save -> (obj) { obj.something; self.something }
  around_save -> (obj, block) { block.call; obj.something }

  def something
  end
end

_user = User.new
