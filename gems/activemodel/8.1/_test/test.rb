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

class Draft
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Dirty
  include ActiveModel::Serializers::JSON

  attribute :title, :string
end

draft = Draft.new(title: "Hello")
draft.changed?
draft.changed.first&.upcase
draft.changes.values.first&.last
draft.previous_changes.each_key(&:upcase)
draft.changed_attributes.keys.first&.upcase
draft.attribute_changed?(:title)
draft.changes_applied
draft.clear_changes_information
draft.attributes.each_key(&:upcase)
draft.attribute_names.first&.upcase
Draft.attribute_names.first&.upcase
draft.as_json.each_key(&:upcase)
draft.serializable_hash(only: :title).each_key(&:upcase)
draft.to_key&.first
draft.to_param&.upcase
draft.to_partial_path.upcase
draft.model_name.human.upcase
draft.model_name.param_key.upcase
draft.model_name.i18n_key.to_proc
Draft.model_name.route_key.upcase
ActiveModel::Naming.param_key(draft).upcase

errors = signup.errors
errors[:email].first&.upcase
errors.messages[:email]&.first&.upcase
errors.details[:email]&.first&.fetch(:error)
errors.to_hash.each_key(&:to_proc)
errors.full_messages.join(", ").upcase
errors.full_messages_for(:email).first&.upcase
errors.where(:email).first&.full_message&.upcase
errors.attribute_names.first&.to_proc
errors.group_by_attribute.each_value(&:size)
errors.include?(:email) && errors.added?(:email, :blank) && errors.of_kind?(:email)
errors.objects.first&.attribute
Signup.validators.first&.kind&.to_proc
Signup.validators_on(:email).first&.options&.fetch(:if)
Signup.attribute_method?(:email)
ActiveModel::Type.lookup(:string).cast("x")

# ClassMethods of the concerns the generated classes include
ActiveModel::Type::Value.serialize_cast_value_compatible?
