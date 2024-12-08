require "active_model"

class Person
  include ActiveModel::Model
  include ActiveModel::Validations

  # @dynamic name, name=, email, email=
  attr_accessor :name, :email

  validate :should_be_satisfied_special_email_rule

  def should_be_satisfied_special_email_rule
    return unless email

    if Time.current >= Time.zone.local(2024, 10)
      errors.add(:email, -> (_person, _options) { "must be satisfied at least 3 rules after #{Time.zone.local(2024, 10)}" }) if [/a-z/, /A-Z/, /0-9/, /[+]/].count {|rule| email.match?(rule) } > 3
    else
      errors.add(:email, 'must be satisfied at least 2 rules') if [/a-z/, /A-Z/, /0-9/].count {|rule| email.match?(rule) } > 2
    end
  end
end

ActiveModel::Error::CALLBACKS_OPTIONS
ActiveModel::Error::MESSAGE_OPTIONS

person = Person.new(name: 'John Doe')
person.valid?

error = ActiveModel::Error.new(person, :name, :too_short, count: 10)
error.attribute
error.type
error.options
error.message
error.details
error.detail
error.full_message
error.match?(:name)
error.strict_match?(:name, :too_short, count: 5)
