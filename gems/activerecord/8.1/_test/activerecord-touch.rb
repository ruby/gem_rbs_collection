model = ActiveRecord::Base.new

model.touch
model.touch(:updated_at)
model.touch(:started_at, "ended_at", time: Time.now)
