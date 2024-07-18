# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'roo'

file_name = './test.csv'
csv = Roo::CSV.new(file_name)

csv.sheets

csv.row(1)
csv.row(1, 'Info')
csv.row(1, 0)
# returns the first row of the spreadsheet.

csv.column(1)
csv.column(1, 'Info')
csv.column(1, 0)
# returns the first column of the spreadsheet.

csv.first_row
csv.first_row('Info')
csv.first_row(0)
csv.first_row(csv.sheets[0])
# => 1             # the number of the first row
csv.last_row
csv.last_row('Info')
csv.last_row(0)
csv.last_row(csv.sheets[0])
# => 42            # the number of the last row
csv.first_column
csv.first_column('Info')
csv.first_column(0)
csv.first_column(csv.sheets[0])
# => 1             # the number of the first column
csv.last_column
csv.last_column('Info')
csv.last_column(0)
csv.last_column(csv.sheets[0])
# => 10            # the number of the last column

csv.cell(1,1)
csv.cell('A',1)
csv.cell(1,'A')
csv.cell(1,1,'Info')
csv.cell(1,1,0)
# csv.a1

csv.set(1,1,'price')
csv.set('A',1,10)
csv.set(1,'A',0.1)
csv.set(1,1,0.2,'Info')
csv.set(1,1,'count',0)

csv.celltype(1,1)
csv.celltype('A',1)
csv.celltype(1,'A')
csv.celltype(1,1,'Info')
csv.celltype(1,1,0)

csv.empty?(1,1)
csv.empty?('A',1)
csv.empty?(1,'A')
csv.empty?(1,1,'Info')
csv.empty?(1,1,0)

csv.to_s

csv.filter_map {|row| row[0] }

csv.to_csv
csv.to_csv(separator: '/', sheet: 'Info')
csv.to_csv(separator: '/', sheet: 0)
csv.to_csv('test.csv')
csv.to_csv('test.csv', '/')
csv.to_csv('test.csv', '/', 'Info')
csv.to_csv('test.csv', '/', 0)
csv.to_csv('test.csv', separator: '/', sheet: 'Info')
csv.to_csv('test.csv', separator: '/', sheet: 0)
csv.to_matrix
csv.to_matrix(1)
csv.to_matrix(1,1)
csv.to_matrix(1,1,10)
csv.to_matrix(1,1,10,10)
csv.to_matrix(1,1,10,10,'Info')
csv.to_matrix(1,1,10,10,0)
csv.to_xml
csv.to_yaml
csv.to_yaml({ file: 'flightdata_2007-06-26', 'sheet' => 1, 2 => :number })
csv.to_yaml({},1)
csv.to_yaml({},1,1)
csv.to_yaml({},1,1,10)
csv.to_yaml({},1,1,10,10)
csv.to_yaml({},1,1,10,10,'Info')
csv.to_yaml({},1,1,10,10,0)

csv.headers

csv.header_line
csv.header_line = 2


csv.default_sheet

csv.default_sheet = csv.sheets.last || raise
csv.default_sheet = csv.sheets[2]
csv.default_sheet = 'Info'
csv.default_sheet = 1

csv.first_column_as_letter
csv.first_column_as_letter('Info')
csv.first_column_as_letter(1)

csv.last_column_as_letter
csv.last_column_as_letter('Info')
csv.last_column_as_letter(1)

csv.first_last_row_col_for_sheet('Info')
csv.first_last_row_col_for_sheet(1)

csv.collect_last_row_col_for_sheet('Info')
csv.collect_last_row_col_for_sheet(1)

csv.find(0)
csv.find(:all)
csv.find(:all, { conditions: { 'A' => 'foo', 1 => 'bar' } })

csv.reload

csv.info

csv.sheet('Info').row(1)
csv.sheet('Info', true)
csv.sheet(0).row(1)
csv.sheet(0, true)

csv.each_with_pagename.each_with_index do |(name, sheet), index|
  name.gsub!(/Info/, 'Information')
  p sheet.row(index)
end
csv.each_with_pagename do |name, sheet|
  name.gsub!(/Info/, 'Information')
  p sheet.row(1)
end

csv.each(id: 'ID', name: 'FULL_NAME', clean: true, header_search: true) do |cells|
  puts cells.inspect # => { id: 1, name: 'John Smith' }
end
csv.each('id' => 'ID', 'name' => 'FULL_NAME', header_search: true) do |cells|
  puts cells.inspect
end
csv.each(id: 'ID', name: 'FULL_NAME', clean: true, headers: true) do |cells|
  puts cells.inspect
end
csv.each('id' => 'ID', 'name' => 'FULL_NAME', headers: :first_row) do |cells|
  puts cells.inspect
end
csv.each(id: 'ID', name: 'FULL_NAME') do |cells|
  puts cells.inspect
end
csv.each(id: 'ID', name: 'FULL_NAME').map do |cells|
  { address: 'Tokyo', **cells }
end
csv.each {|row| row[0] }
csv.each.with_index do |row, index|
  row[index]
end

csv.parse(id: 'ID', name: 'FULL_NAME', clean: true, header_search: true) do |cells|
  cells.to_a # => { id: 1, name: 'John Smith' }
end
csv.parse('id' => 'ID', 'name' => 'FULL_NAME', header_search: true) do |cells|
  cells.to_a
end
csv.parse(id: 'ID', name: 'FULL_NAME', clean: true, headers: true) do |cells|
  cells.to_a
end
csv.parse('id' => 'ID', 'name' => 'FULL_NAME', headers: :first_row) do |cells|
  cells.to_a
end
csv.parse(id: 'ID', name: 'FULL_NAME') do |cells|
  cells.to_a
end
csv.parse(id: /UPC|SKU/, qty: /ATS*\sATP\s*QTY\z/)
# => [{:id => 727880013358, :qty => 12}, ...]
csv.row_with([/Header/, /Missing Header 1/, /Missing Header 2/])
csv.row_with([/Header/, /Missing Header 1/, /Missing Header 2/], true)

csv.close
