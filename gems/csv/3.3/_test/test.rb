# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "csv"

csv = CSV.new("header1,header2\nrow1_1,row1_2")
csv.headers

csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true)
csv.headers
csv.read
csv.headers

[1, 2, 3].to_csv
[1, 2, 3].to_csv(col_sep: '\t')

"1,2,3".parse_csv
"1,2,3".parse_csv(col_sep: '\t')
