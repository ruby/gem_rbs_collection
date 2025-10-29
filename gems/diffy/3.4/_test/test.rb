# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "diffy"

str1 = "123"
str2 = "124"

Diffy::Diff.new(str1, str2).to_s

Diffy::Diff.new(str1, str2, context: 3).to_s

Diffy::Diff.new(str1, str2).to_s(:html)
