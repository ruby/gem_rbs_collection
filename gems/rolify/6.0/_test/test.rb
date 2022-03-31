# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rolify"

class User
  extend Rolify
  rolify :before_add => :before_add_method

  def before_add_method(role)
    # do something before it gets added
  end
end
