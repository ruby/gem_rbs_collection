# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "nkf"

NKF.guess("str")
NKF.nkf("-w", "str")
