# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "csv"
require "tmpdir"

csv = CSV.new("header1,header2\nrow1_1,row1_2")
csv.headers

csv = CSV.new("header1,header2\nrow1_1,row1_2", headers: true)
csv.headers
csv.read
csv.headers

[1, 2, 3].to_csv
[1, 2, 3].to_csv(col_sep: '\t')

Dir.mktmpdir do |tmpdir|
  path1 = File.join(tmpdir, "example1.csv")
  File.write(path1, "a,b,c\n1,2,3\n")
  CSV.open(path1) { |csv| csv }
  CSV.open(path1)
  File.open(path1) do |io|
    CSV.open(io) { |csv| csv }
  end
  File.open(path1) do |io|
    CSV.open(io)
  end

  path2 = File.join(tmpdir, "example2.csv")
  File.write(path2, "a,b,c\n1,2,3\n")
  CSV.open(path2, invalid: :replace, undef: :replace) { |csv| csv }
  CSV.open(path2, invalid: :replace, undef: :replace)
  File.open(path2) do |io|
    CSV.open(io, invalid: :replace, undef: :replace) { |csv| csv }
  end
  File.open(path2) do |io|
    CSV.open(io, invalid: :replace, undef: :replace)
  end

  path3 = File.join(tmpdir, "example3.csv")
  File.write(path3, "a,b,c\n1,2,3\n")
  CSV.open(path3, headers: :first_row) { |csv| csv }
  CSV.open(path3, headers: :first_row)
  File.open(path3) do |io|
    CSV.open(io, headers: :first_row) { |csv| csv }
  end
  File.open(path3) do |io|
    CSV.open(io, headers: :first_row)
  end

  path4 = File.join(tmpdir, "example4.csv")
  CSV.open(path4, "w") { |csv| csv << ["a", "b", "c"] }
  CSV.open(path4, "w")
  File.open(path4, "w") do |io|
    CSV.open(io) { |csv| csv << ["a", "b", "c"] }
  end
  File.open(path4, "w") do |io|
    CSV.open(io, "w")
  end

  path5 = File.join(tmpdir, "example5.csv")
  CSV.open(path5, "w", invalid: :replace, undef: :replace)
  File.open(path5, "w") do |io|
    CSV.open(io, "w", invalid: :replace, undef: :replace) { |csv| csv << ["a", "b", "c"] }
  end
  File.open(path5, "w") do |io|
    CSV.open(io, "w", invalid: :replace, undef: :replace)
  end

  path6 = File.join(tmpdir, "example6.csv")
  CSV.open(path6, "w", headers: :first_row)
  File.open(path6, "w") do |io|
    CSV.open(io, "w", headers: :first_row) { |csv| csv << ["a", "b", "c"] }
  end
  File.open(path6, "w") do |io|
    CSV.open(io, "w", headers: :first_row)
  end
end

"1,2,3".parse_csv
"1,2,3".parse_csv(col_sep: '\t')
