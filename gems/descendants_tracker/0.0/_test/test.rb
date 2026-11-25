# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "descendants_tracker"
require "descendants_tracker/version"

class Base
  extend DescendantsTracker
end

class Child < Base
end

descendants = Base.descendants
descendants.each { |klass| klass.name }
Child.descendants.empty?
DescendantsTracker::VERSION.upcase
