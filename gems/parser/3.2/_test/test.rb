# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "parser"

node = Parser::CurrentRuby.parse("2 + 2") or raise
node.loc
