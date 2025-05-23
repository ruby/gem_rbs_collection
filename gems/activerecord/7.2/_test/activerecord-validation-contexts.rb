model = ActiveRecord::Base.new

model.save
model.save(context: :sample_context)
model.save(context: [:update, :sample_context], touch: false)
model.save(validate: false, touch: true)

model.save!
model.save!(context: :sample_context)
model.save!(context: [:update, :sample_context], touch: false)
model.save!(validate: false, touch: true)

model.valid?
model.valid?(:sample_context)
model.valid?([:update, :sample_context])

model.validate
model.validate(:sample_context)
model.validate([:update, :sample_context])

model.invalid?
model.invalid?(:sample_context)
model.invalid?([:update, :sample_context])
