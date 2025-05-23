class FunQuery
  def self.call(*args)
  end
end

class User < ActiveRecord::Base
  # @dynamic age

  enum status: { active: 0, inactive: 1 }, _suffix: true
  enum role: { admin: 0, user: 1 }, _prefix: :user_role

  # @dynamic articles
  has_many :articles

  validates :name, presence: true, if: -> { something }
  validates :age, presence: true, if: ->(user) { user.something }

  scope :name_like, ->(name) { where(arel_table[:name].matches("%#{sanitize_sql_like(name)}%")) }
  scope :matured, -> { where(arel_table[:age].gteq(18)) }
  scope :nowait, -> { lock("FOR UPDATE NOWAIT") }
  scope :fun, FunQuery

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
User.preload(:address, friends: [:address, { followers: :users }]) # steep:ignore FallbackAny
User.in_order_of(:id, [1, 5, 3])
User.offset(5).limit(10)
User.count
User.create_with(name: 'name', age: 1)
User.create_with(nil)
User.find_by_sql("SELECT * FROM users")

User.sum(:age)
User.sum(&:age).times
User.sum { |user| user.age }.times
User.sum(0.0) { |user| user.age.to_f }.next_float
User.all.sum(:age)
User.all.sum(&:age).times
User.all.sum { |user| user.age }.times
User.all.sum(0.0) { |user| user.age.to_f }.next_float

t = User.arel_table
User.limit(10).select(:id, "name", t[:age].as("years"), t[:email])
