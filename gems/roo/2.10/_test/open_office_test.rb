# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'roo'

file_name = './test.open_office'
open_office = Roo::OpenOffice.new(file_name)

open_office.sheets

open_office.row(1)
open_office.row(1, 'Info')
open_office.row(1, 0)
# returns the first row of the spreadsheet.

open_office.column(1)
open_office.column(1, 'Info')
open_office.column(1, 0)
# returns the first column of the spreadsheet.

open_office.first_row
open_office.first_row('Info')
open_office.first_row(0)
open_office.first_row(open_office.sheets[0])
# => 1             # the number of the first row
open_office.last_row
open_office.last_row('Info')
open_office.last_row(0)
open_office.last_row(open_office.sheets[0])
# => 42            # the number of the last row
open_office.first_column
open_office.first_column('Info')
open_office.first_column(0)
open_office.first_column(open_office.sheets[0])
# => 1             # the number of the first column
open_office.last_column
open_office.last_column('Info')
open_office.last_column(0)
open_office.last_column(open_office.sheets[0])
# => 10            # the number of the last column

open_office.cell(1,1)
open_office.cell('A',1)
open_office.cell(1,'A')
open_office.cell(1,1,'Info')
open_office.cell(1,1,0)
# open_office.a1

open_office.set(1,1,'price')
open_office.set('A',1,10)
open_office.set(1,'A',0.1)
open_office.set(1,1,0.2,'Info')
open_office.set(1,1,'count',0)

open_office.formula(1,1)
open_office.formula('A',1)
open_office.formula(1,'A')
open_office.formula(1,1,'Info')
open_office.formula(1,1,0)

open_office.formula?(1,1)
open_office.formula?('A',1)
open_office.formula?(1,'A')
open_office.formula?(1,1,'Info')
open_office.formula?(1,1,0)

open_office.formulas
open_office.formulas('Info')
open_office.formulas(1)

open_office.font(1,1)
open_office.font('A',1)
open_office.font(1,'A')
open_office.font(1,1,'Info')
open_office.font(1,1,0)

open_office.celltype(1,1)
open_office.celltype('A',1)
open_office.celltype(1,'A')
open_office.celltype(1,1,'Info')
open_office.celltype(1,1,0)

open_office.officeversion

open_office.empty?(1,1)
open_office.empty?('A',1)
open_office.empty?(1,'A')
open_office.empty?(1,1,'Info')
open_office.empty?(1,1,0)

open_office.to_s
open_office.to_s('Info')
open_office.to_s(0)

open_office.label('Info')

open_office.labels
open_office.labels('Info')
open_office.labels(0)

open_office.comment(1,1)
open_office.comment('A',1)
open_office.comment(1,'A')
open_office.comment(1,1,'Info')
open_office.comment(1,1,0)

open_office.comments
open_office.comments('Info')
open_office.comments(0)

open_office.filter_map {|row| row[0] }

open_office.to_csv
open_office.to_csv(separator: '/', sheet: 'Info')
open_office.to_csv(separator: '/', sheet: 0)
open_office.to_csv('test.csv')
open_office.to_csv('test.csv', '/')
open_office.to_csv('test.csv', '/', 'Info')
open_office.to_csv('test.csv', '/', 0)
open_office.to_csv('test.csv', separator: '/', sheet: 'Info')
open_office.to_csv('test.csv', separator: '/', sheet: 0)
open_office.to_matrix
open_office.to_matrix(1)
open_office.to_matrix(1,1)
open_office.to_matrix(1,1,10)
open_office.to_matrix(1,1,10,10)
open_office.to_matrix(1,1,10,10,'Info')
open_office.to_matrix(1,1,10,10,0)
open_office.to_xml
open_office.to_yaml
open_office.to_yaml({ file: 'flightdata_2007-06-26', 'sheet' => 1, 2 => :number })
open_office.to_yaml({},1)
open_office.to_yaml({},1,1)
open_office.to_yaml({},1,1,10)
open_office.to_yaml({},1,1,10,10)
open_office.to_yaml({},1,1,10,10,'Info')
open_office.to_yaml({},1,1,10,10,0)

open_office.headers

open_office.header_line
open_office.header_line = 2


open_office.default_sheet

open_office.default_sheet = open_office.sheets.last || raise
open_office.default_sheet = open_office.sheets[2]
open_office.default_sheet = 'Info'
open_office.default_sheet = 1

open_office.first_column_as_letter
open_office.first_column_as_letter('Info')
open_office.first_column_as_letter(1)

open_office.last_column_as_letter
open_office.last_column_as_letter('Info')
open_office.last_column_as_letter(1)

open_office.first_last_row_col_for_sheet('Info')
open_office.first_last_row_col_for_sheet(1)

open_office.collect_last_row_col_for_sheet('Info')
open_office.collect_last_row_col_for_sheet(1)

open_office.find(0)
open_office.find(:all)
open_office.find(:all, { conditions: { 'A' => 'foo', 1 => 'bar' } })

open_office.reload

open_office.info

open_office.sheet('Info').row(1)
open_office.sheet('Info', true)
open_office.sheet(0).row(1)
open_office.sheet(0, true)

open_office.each_with_pagename.each_with_index do |(name, sheet), index|
  name.gsub!(/Info/, 'Information')
  p sheet.row(index)
end
open_office.each_with_pagename do |name, sheet|
  name.gsub!(/Info/, 'Information')
  p sheet.row(1)
end

open_office.each(id: 'ID', name: 'FULL_NAME', clean: true, header_search: true) do |cells|
  puts cells.inspect # => { id: 1, name: 'John Smith' }
end
open_office.each('id' => 'ID', 'name' => 'FULL_NAME', header_search: true) do |cells|
  puts cells.inspect
end
open_office.each(id: 'ID', name: 'FULL_NAME', clean: true, headers: true) do |cells|
  puts cells.inspect
end
open_office.each('id' => 'ID', 'name' => 'FULL_NAME', headers: :first_row) do |cells|
  puts cells.inspect
end
open_office.each(id: 'ID', name: 'FULL_NAME') do |cells|
  puts cells.inspect
end
open_office.each(id: 'ID', name: 'FULL_NAME').map do |cells|
  { address: 'Tokyo', **cells }
end
open_office.each {|row| row[0] }
open_office.each.with_index do |row, index|
  row[index]
end

open_office.parse(id: 'ID', name: 'FULL_NAME', clean: true, header_search: true) do |cells|
  cells.to_a # => { id: 1, name: 'John Smith' }
end
open_office.parse('id' => 'ID', 'name' => 'FULL_NAME', header_search: true) do |cells|
  cells.to_a
end
open_office.parse(id: 'ID', name: 'FULL_NAME', clean: true, headers: true) do |cells|
  cells.to_a
end
open_office.parse('id' => 'ID', 'name' => 'FULL_NAME', headers: :first_row) do |cells|
  cells.to_a
end
open_office.parse(id: 'ID', name: 'FULL_NAME') do |cells|
  cells.to_a
end
open_office.parse(id: /UPC|SKU/, qty: /ATS*\sATP\s*QTY\z/)
# => [{:id => 727880013358, :qty => 12}, ...]
open_office.row_with([/Header/, /Missing Header 1/, /Missing Header 2/])
open_office.row_with([/Header/, /Missing Header 1/, /Missing Header 2/], true)

open_office.close
