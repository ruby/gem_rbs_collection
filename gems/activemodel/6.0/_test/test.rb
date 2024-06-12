class Person
  include ActiveModel::Model
  include ActiveModel::Validations
  attr_accessor :name, :age, :email

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, if: -> { age >= 20 }
end

Person.new.send(:valid?)
