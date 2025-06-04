class TestCallbackObject < ActiveRecord::Base
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
  RAILS_60_DOCS_EXAMPLE = [:local_condition1, ->(my_rec) { my_rec.local_condition3 }]

  validate :custom_validation, on: :update, unless: RAILS_60_DOCS_EXAMPLE

  def custom_validation
    if self.class.name != 'TestCallbackObject'
      errors.add(:base, 'testing only')
    end
  end
end
