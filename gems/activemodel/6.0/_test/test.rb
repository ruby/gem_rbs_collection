class Person
  include ActiveModel::Model
  include ActiveModel::Validations
  attr_accessor :name, :age, :email

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, if: [:foo?, -> { age >= 20 }]

  def foo? = true
end

Person.new.send(:valid?)
