# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'scanf'

# String#scanf and IO#scanf take a single argument, the format string
"123ac".scanf("%d%s")
File.open('test.rb', "rb").scanf("%d%s")

# Kernel#scanf reads from STDIN
scanf("%d%s")
