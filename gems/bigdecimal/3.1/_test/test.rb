# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "bigdecimal"
require "bigdecimal/util"

BigDecimal("1.23")

BigDecimal("1.23") + BigDecimal("1.23")
BigDecimal("1.23") - BigDecimal("1.23")
BigDecimal("1.23") * BigDecimal("1.23")
BigDecimal("1.23") / BigDecimal("1.23")

BigDecimal("1.23").to_d
BigDecimal("1.23").to_f
BigDecimal("1.23").to_i
BigDecimal("1.23").to_r

123.to_d
12.3.to_d
12r.to_d(3)
0i.to_d
