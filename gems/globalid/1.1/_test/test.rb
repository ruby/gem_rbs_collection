# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "globalid"

GlobalID.app = 'blah'

class Person
  include GlobalID::Identification

  # @dynamic id, id=
  attr_accessor :id

  def self.find(id)
    new.tap { |obj| obj.id = id }
  end
end

person = Person.find(1)
person_gid = person.to_global_id
p person_gid.uri
p person_gid.to_s
p person_gid.model_id
