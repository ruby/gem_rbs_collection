# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "memoist"

class Person
  extend Memoist

  def social_security
    "123"
  end
  memoize :social_security

  def taxes_due(income)
    income * 0.40
  end

  def name
    "Josh"
  end
end

name = Person.memoize(:taxes_due)
name&.to_proc
names = Person.memoize(:name, "social_security", identifier: :again)
names&.each { |n| n.to_s }
Person.memoize(:name, identifier: "other")

person = Person.new
person.memoize_all.each do |struct|
  struct.memoized_method.to_s
  struct.ivar.upcase
  struct.arity + 1
end
person.unmemoize_all
person.prime_cache
person.prime_cache(:social_security, "taxes_due")
person.flush_cache
person.flush_cache(:social_security)

Person.all_memoized_structs.map(&:ivar)
Person.clear_structs

Memoist::VERSION.split(".")
