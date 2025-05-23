class TestCallbackObject < ActiveRecord::Base
  before_validation ::Callbacks::ClassCallback
  after_validation ::Callbacks::ClassCallback
  before_save ::Callbacks::ClassCallback
  before_create ::Callbacks::ClassCallback
  after_create ::Callbacks::ClassCallback
  after_save ::Callbacks::ClassCallback
  around_create ::Callbacks::ClassCallback
  around_save ::Callbacks::ClassCallback
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

