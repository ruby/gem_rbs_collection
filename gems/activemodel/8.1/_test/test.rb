require "active_model"

class Person
  include ActiveModel::Attributes
  include ActiveModel::Validations

  # @dynamic name, name=
  attribute :name, :string
end

Person.attribute_types

ActiveModel::Error::CALLBACKS_OPTIONS
ActiveModel::Error::MESSAGE_OPTIONS

error = ActiveModel::Error.new(Person.new, :name, :too_short, count: 5)
error.attribute
error.type
error.options
error.message
error.details
error.detail
error.full_message
error.match?(:name)
error.strict_match?(:name, :too_short, count: 5)

Person.human_attribute_name("name")
Person.human_attribute_name(:name)
Person.human_attribute_name("name", default: "Name")

class NameValidator < ActiveModel::Validator
  def validate(record)
  end
end

class Signup
  include ActiveModel::Model
  include ActiveModel::Validations::Callbacks

  before_validation :strip_email
  after_validation :log_errors
  validates_with NameValidator

  def strip_email
  end

  def log_errors
    validates_with NameValidator
  end
end

signup = Signup.new
signup.errors.size + 1
signup.errors.empty?
signup.errors.uniq!
signup.errors.clear
ActiveModel::Name.new(Signup).to_str.upcase
ActiveModel::Name.new(Signup).match?(/Sign/)
Signup._validators.each_key(&:to_s)
Signup.param_delimiter.length
ActiveModel::Translation.raise_on_missing_translations = true
ActiveModel::Error.i18n_customize_full_message = true
Person.attribute_aliases.each_key(&:upcase)
