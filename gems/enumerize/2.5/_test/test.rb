require 'enumerize'

class User
  extend Enumerize

  enumerize :role, in: %i(user admin)
end
