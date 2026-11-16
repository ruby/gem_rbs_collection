require "ostruct"

person = OpenStruct.new
person[:name] = "John Smith"
person["age"] = 70
# @type var name: untyped
name = person[:name]
# @type var age: Integer
age = person["age"]
puts name, age.succ

australia = OpenStruct.new(:country => "Australia", :capital => "Canberra")
from_strings = OpenStruct.new("country" => "Australia", "capital" => "Canberra")
from_hash = OpenStruct.new({ country: "Australia" })
from_nil = OpenStruct.new(nil)
from_ostruct = OpenStruct.new(australia)
from_struct = OpenStruct.new(Process.times)
OpenStruct.new(left: 1, right: 2)
puts from_strings, from_hash, from_nil, from_ostruct, from_struct

# @type var version: String
version = OpenStruct::VERSION

# @type var table: Hash[Symbol, untyped]
table = australia.to_h
# @type var upcased: Hash[String, String]
upcased = australia.to_h { |key, _value| [key.to_s, key.to_s.upcase] }
puts table, upcased

australia.each_pair { |pair| puts pair.size }
# @type var enum: Enumerator[[Symbol, untyped], OpenStruct]
enum = australia.each_pair
# @type var chained: OpenStruct
chained = australia.each_pair { |pair| puts pair.last }
puts enum.to_a.size, chained.inspect

nested = OpenStruct.new(address: OpenStruct.new("zip" => 12345))
zip = nested.dig(:address, "zip")
puts zip

first_pet = OpenStruct.new(name: "Rowdy", owner: "John Smith")
second_pet = OpenStruct.new(name: "Rowdy")
owner = first_pet.delete_field(:owner)
fallback = first_pet.delete_field("owner") { "nobody" }
puts owner, fallback
# @type var same: bool
same = first_pet == second_pet
# @type var same_value: bool
same_value = first_pet.eql?(second_pet)
puts same, same_value

# @type var inspected: String
inspected = first_pet.inspect
# @type var stringified: String
stringified = first_pet.to_s
puts inspected.length, stringified.length
puts version.length
