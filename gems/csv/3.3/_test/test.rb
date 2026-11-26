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

CSV.open("example.csv") { |csv| csv.read }
csv = CSV.open("example.csv")
csv.read
CSV.open("example.csv", invalid: :replace, undef: :replace, headers: :first_row) do |csv|
  csv.read
  csv.headers
end

CSV.open("example.csv", "w") { |csv| csv << ["a", "b", "c"] }
csv = CSV.open("example.csv", "w")
csv << ["a", "b", "c"]

"1,2,3".parse_csv
"1,2,3".parse_csv(col_sep: '\t')

# Row type depends on `headers:` option
csv = CSV.new("a,b\n1,2", headers: true)
# @type var row: CSV::Row?
row = csv.shift
# @type var table: CSV::Table[CSV::Row]
table = csv.read
csv.each { |r| r.fields }

csv = CSV.new("a,b\n1,2")
# @type var array_row: Array[String?]?
array_row = csv.gets
# @type var array_rows: Array[Array[String?]]
array_rows = csv.readlines
csv.each { |r| r.join }

CSV.open("example.csv", headers: true) { |csv| csv.shift&.fields }
CSV.open("example.csv") { |csv| csv.shift&.join }

# @type var table: CSV::Table[CSV::Row]
table = CSV.parse("a,b\n1,2", headers: true)
CSV.parse("a,b\n1,2", headers: true) { |r| r.fields }
# @type var array_rows: Array[Array[String?]]
array_rows = CSV.parse("a,b\n1,2")
CSV.parse("a,b\n1,2") { |r| r.join }

# Bare `CSV` accepts both modes
# @type var take_any_csv: ^(CSV) -> void
take_any_csv = ->(csv) { csv.shift }
take_any_csv.(CSV.new("a,b", headers: true))
take_any_csv.(CSV.new("a,b"))

# @type var take_csv_with_headers: ^(CSV::with_headers) -> CSV::Row?
take_csv_with_headers = ->(csv) { csv.shift }
take_csv_with_headers.(CSV.new("a,b", headers: true))

# Not statically known
csv = CSV.new("a,b", headers: [true, false].sample)
# @type var any_row: Array[String?] | CSV::Row | nil
any_row = csv.shift
