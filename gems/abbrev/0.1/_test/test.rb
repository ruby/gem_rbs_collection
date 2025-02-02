# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "abbrev"

Abbrev.abbrev([])
Abbrev.abbrev(%w(abbrev))
Abbrev.abbrev(%w(abbrev), 'abb')
Abbrev.abbrev(%w(abbrev), /^abb/)
Abbrev.abbrev(%w(abbrev), nil)
