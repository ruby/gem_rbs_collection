class Person
  include ActiveModel::Model
  include ActiveModel::Validations
  attr_accessor :name, :age, :email

  validates :name, presence: true, length: { maximum: 100 }
  validates :email, presence: true, if: [:foo?, -> { age >= 20 }]
  validate :should_be_satisfied_special_email_rule

  def foo? = true

  def should_be_satisfied_special_email_rule
    if Time.current >= Time.zone.local(2024, 10)
      errors.add(:email, -> (_person, _options) { "must be satisfied at least 3 rules after #{Time.zone.local(2024, 10)}" }) if [/a-z/, /A-Z/, /0-9/, /[+]/].count {|rule| email.match?(rule) } > 3
    else
      errors.add(:email, 'must be satisfied at least 2 rules') if [/a-z/, /A-Z/, /0-9/].count {|rule| email.match?(rule) } > 2
    end
  end
end

person = Person.new(name: 'John Doe')
person.valid?
