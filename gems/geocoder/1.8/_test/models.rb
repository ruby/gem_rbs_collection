require "active_record"

class Venue < ActiveRecord::Base
  geocoded_by :address
end

obj = Venue.new
obj.distance_to([43.9,-98.6])  # distance from obj to point
obj.bearing_to([43.9,-98.6])   # bearing from obj to point

obj2 = Venue.new
obj.bearing_from(obj2)         # bearing from obj2 to obj
