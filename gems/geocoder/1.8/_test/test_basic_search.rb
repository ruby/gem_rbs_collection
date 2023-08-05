#Taken from https://github.com/alexreisner/geocoder/tree/v1.8.0

require "geocoder"

results = Geocoder.search("Paris")
results.first.coordinates

results = Geocoder.search([48.856614, 2.3522219])
results.first.address

results = Geocoder.search("172.56.21.89")
results.first.coordinates
results.first.country
