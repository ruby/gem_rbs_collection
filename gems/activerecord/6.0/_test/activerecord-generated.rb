class User < ActiveRecord::Base
  enum status: { active: 0, inactive: 1 }, _suffix: true
  enum role: { admin: 0, user: 1 }, _prefix: :user_role

  # @dynamic articles
  has_many :articles

  validates :name, presence: true, if: -> { something }
  validates :age, presence: true, if: ->(user) { user.something }

  scope :matured, -> { where(arel_table[:age].gteq(18)) }

  before_save -> (obj) { obj.something; self.something }
  around_save -> (obj, block) { block.call; obj.something }

  def something
  end
end

class Article < ActiveRecord::Base
end

user = User.new
user.articles.build(Hash.new)
user.articles.build(ActionController::Parameters.new)

User.eager_load(:address, friends: [:address, :followers])
User.includes(:address, :friends).to_a
User.preload(:address, friends: [:address, :followers])
User.in_order_of(:id, [1, 5, 3])
