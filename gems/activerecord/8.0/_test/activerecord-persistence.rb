# save! and update! return true or raise an error
model = ActiveRecord::Base.new
# @type var saved: true
saved = model.save!
saved = model.save!(context: :sample_context, validate: false, touch: false)
# @type var updated: true
updated = model.update!(name: "new name")
[saved, updated].all?
