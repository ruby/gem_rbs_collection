require "active_model"

module TestValidations
  class Person
    include ActiveModel::Validations

    # @dynamic name, name=
    attr_accessor :name

    validates :name, presence: true
  end

  person1 = Person.new
  person1.valid?

  person2 = Person.new
  person2.name = "foo"
  person2.valid?

  person2.errors.each do |error|
    person1.errors.import(error)
  end
end
