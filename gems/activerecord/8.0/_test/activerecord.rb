class TestCallbackObject < ActiveRecord::Base
  before_validation ::Callbacks::ClassCallback
  after_validation ::Callbacks::ClassCallback
  before_save ::Callbacks::ClassCallback
  before_create ::Callbacks::ClassCallback
  after_create ::Callbacks::ClassCallback
  after_save ::Callbacks::ClassCallback
  around_create ::Callbacks::ClassCallback
  around_save ::Callbacks::ClassCallback

  def local_condition1
    [true, false].sample
  end

  def local_condition2
    [true, false].sample
  end

  def local_condition3
    [true, false].sample
  end

  # https://guides.rubyonrails.org/v6.0/active_record_validations.html#combining-validation-conditions
  RAILS_60_DOCS_EXAMPLE = [:local_condition1, ->(my_rec) { my_rec.local_condition3 }] #: [Symbol, ^(TestCallbackObject) [self: TestCallbackObject] -> bool]

  validate :custom_validation, on: :update, unless: RAILS_60_DOCS_EXAMPLE

  def custom_validation
    if self.class.name != 'TestCallbackObject'
      errors.add(:base, 'testing only')
    end
  end
end

module Callbacks
  class ClassCallback
    def self.before_validation(model_obj)
      puts("class before_validation: #{model_obj}")
    end

    def self.after_validation(model_obj)
      puts("class after_validation: #{model_obj}")
    end

    def self.before_save(model_obj)
      puts("class before_save: #{model_obj}")
    end

    def self.before_create(model_obj)
      puts("class before_create: #{model_obj}")
    end

    def self.after_create(model_obj)
      puts("class after_create: #{model_obj}")
    end

    def self.after_save(model_obj)
      puts("class after_save: #{model_obj}")
    end

    def self.around_create(model_obj)
      puts("class around_create: #{model_obj}")
      yield
    end

    def self.around_save(model_obj)
      puts("class around_save: #{model_obj}")
      yield
    end
  end
end

