# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'roo'

file_name = './test.xlsx'
xlsx = Roo::Excelx.new(file_name)

xlsx.sheets

xlsx.images
xlsx.images('Info')
xlsx.images(0)

xlsx.row(1)
xlsx.row(1, 'Info')
xlsx.row(1, 0)
# returns the first row of the spreadsheet.

xlsx.column(1)
xlsx.column(1, 'Info')
xlsx.column(1, 0)
# returns the first column of the spreadsheet.

xlsx.first_row
xlsx.first_row('Info')
xlsx.first_row(0)
xlsx.first_row(xlsx.sheets[0])
# => 1             # the number of the first row
xlsx.last_row
xlsx.last_row('Info')
xlsx.last_row(0)
xlsx.last_row(xlsx.sheets[0])
# => 42            # the number of the last row
xlsx.first_column
xlsx.first_column('Info')
xlsx.first_column(0)
xlsx.first_column(xlsx.sheets[0])
# => 1             # the number of the first column
xlsx.last_column
xlsx.last_column('Info')
xlsx.last_column(0)
xlsx.last_column(xlsx.sheets[0])
# => 10            # the number of the last column

xlsx.cell(1,1)
xlsx.cell('A',1)
xlsx.cell(1,'A')
xlsx.cell(1,1,'Info')
xlsx.cell(1,1,0)
# xlsx.a1

xlsx.set(1,1,'price')
xlsx.set('A',1,'10')
xlsx.set(1,1,'0.2','Info')
xlsx.set(1,1,'count',0)

xlsx.formula(1,1)
xlsx.formula('A',1)
xlsx.formula(1,'A')
xlsx.formula(1,1,'Info')
xlsx.formula(1,1,0)

xlsx.formula?(1,1)
xlsx.formula?('A',1)
xlsx.formula?(1,'A')
xlsx.formula?(1,1,'Info')
xlsx.formula?(1,1,0)

xlsx.formulas
xlsx.formulas('Info')
xlsx.formulas(1)

xlsx.font(1,1)
xlsx.font('A',1)
xlsx.font(1,'A')
xlsx.font(1,1,'Info')
xlsx.font(1,1,0)

xlsx.celltype(1,1)
xlsx.celltype('A',1)
xlsx.celltype(1,'A')
xlsx.celltype(1,1,'Info')
xlsx.celltype(1,1,0)

xlsx.excelx_type(1,1)
xlsx.excelx_type('A',1)
xlsx.excelx_type(1,'A')
xlsx.excelx_type(1,1,'Info')
xlsx.excelx_type(1,1,0)

xlsx.excelx_value(1,1)
xlsx.excelx_value('A',1)
xlsx.excelx_value(1,'A')
xlsx.excelx_value(1,1,'Info')
xlsx.excelx_value(1,1,0)

xlsx.formatted_value(1,1)
xlsx.formatted_value('A',1)
xlsx.formatted_value(1,'A')
xlsx.formatted_value(1,1,'Info')
xlsx.formatted_value(1,1,0)

xlsx.excelx_format(1,1)
xlsx.excelx_format('A',1)
xlsx.excelx_format(1,'A')
xlsx.excelx_format(1,1,'Info')
xlsx.excelx_format(1,1,0)

xlsx.empty?(1,1)
xlsx.empty?('A',1)
xlsx.empty?(1,'A')
xlsx.empty?(1,1,'Info')
xlsx.empty?(1,1,0)

xlsx.to_s
xlsx.to_s('Info')
xlsx.to_s(0)

xlsx.label('Info')

xlsx.labels

xlsx.hyperlink?(1,1)
xlsx.hyperlink?('A',1)
xlsx.hyperlink?(1,'A')
xlsx.hyperlink?(1,1,'Info')
xlsx.hyperlink?(1,1,0)

xlsx.hyperlink(1,1)
xlsx.hyperlink('A',1)
xlsx.hyperlink(1,'A')
xlsx.hyperlink(1,1,'Info')
xlsx.hyperlink(1,1,0)

xlsx.comment(1,1)
xlsx.comment('A',1)
xlsx.comment(1,'A')
xlsx.comment(1,1,'Info')
xlsx.comment(1,1,0)

xlsx.comment?(1,1)
xlsx.comment?('A',1)
xlsx.comment?(1,'A')
xlsx.comment?(1,1,'Info')
xlsx.comment?(1,1,0)

xlsx.comments
xlsx.comments('Info')
xlsx.comments(0)

xlsx.each_row_streaming.flat_map {|row| row.map(&:value) }
xlsx.each_row_streaming({ sheet: 'Info' }).flat_map {|row| row.map(&:value) }
xlsx.each_row_streaming do |row|
  row.each {|cell| cell.value }
end
xlsx.each_row_streaming({ sheet: 0 }) do |row|
  row.each {|cell| cell.value }
end

xlsx.filter_map {|row| row[0] }

xlsx.to_csv
xlsx.to_csv(separator: '/', sheet: 'Info')
xlsx.to_csv(separator: '/', sheet: 0)
xlsx.to_csv('test.csv')
xlsx.to_csv('test.csv', '/')
xlsx.to_csv('test.csv', '/', 'Info')
xlsx.to_csv('test.csv', '/', 0)
xlsx.to_csv('test.csv', separator: '/', sheet: 'Info')
xlsx.to_csv('test.csv', separator: '/', sheet: 0)
xlsx.to_matrix
xlsx.to_matrix(1)
xlsx.to_matrix(1,1)
xlsx.to_matrix(1,1,10)
xlsx.to_matrix(1,1,10,10)
xlsx.to_matrix(1,1,10,10,'Info')
xlsx.to_matrix(1,1,10,10,0)
xlsx.to_xml
xlsx.to_yaml
xlsx.to_yaml({ file: 'flightdata_2007-06-26', 'sheet' => 1, 2 => :number })
xlsx.to_yaml({},1)
xlsx.to_yaml({},1,1)
xlsx.to_yaml({},1,1,10)
xlsx.to_yaml({},1,1,10,10)
xlsx.to_yaml({},1,1,10,10,'Info')
xlsx.to_yaml({},1,1,10,10,0)

xlsx.headers

xlsx.header_line
xlsx.header_line = 2


xlsx.default_sheet

xlsx.default_sheet = xlsx.sheets.last || raise
xlsx.default_sheet = xlsx.sheets[2]
xlsx.default_sheet = 'Info'
xlsx.default_sheet = 1

xlsx.first_column_as_letter
xlsx.first_column_as_letter('Info')
xlsx.first_column_as_letter(1)

xlsx.last_column_as_letter
xlsx.last_column_as_letter('Info')
xlsx.last_column_as_letter(1)

xlsx.first_last_row_col_for_sheet('Info')
xlsx.first_last_row_col_for_sheet(1)

xlsx.collect_last_row_col_for_sheet('Info')
xlsx.collect_last_row_col_for_sheet(1)

xlsx.find(0)
xlsx.find(:all)
xlsx.find(:all, { conditions: { 'A' => 'foo', 1 => 'bar' } })

xlsx.reload

xlsx.info

xlsx.sheet('Info').row(1)
xlsx.sheet('Info', true)
xlsx.sheet(0).row(1)
xlsx.sheet(0, true)

xlsx.each_with_pagename.each_with_index do |(name, sheet), index|
  name.gsub!(/Info/, 'Information')
  p sheet.row(index)
end
xlsx.each_with_pagename do |name, sheet|
  name.gsub!(/Info/, 'Information')
  p sheet.row(1)
end

xlsx.each(id: 'ID', name: 'FULL_NAME', clean: true, header_search: true) do |cells|
  puts cells.inspect # => { id: 1, name: 'John Smith' }
end
xlsx.each('id' => 'ID', 'name' => 'FULL_NAME', header_search: true) do |cells|
  puts cells.inspect
end
xlsx.each(id: 'ID', name: 'FULL_NAME', clean: true, headers: true) do |cells|
  puts cells.inspect
end
xlsx.each('id' => 'ID', 'name' => 'FULL_NAME', headers: :first_row) do |cells|
  puts cells.inspect
end
xlsx.each(id: 'ID', name: 'FULL_NAME') do |cells|
  puts cells.inspect
end
xlsx.each(id: 'ID', name: 'FULL_NAME').map do |cells|
  { address: 'Tokyo', **cells }
end
xlsx.each {|row| row[0] }
xlsx.each.with_index do |row, index|
  row[index]
end

xlsx.parse(id: 'ID', name: 'FULL_NAME', clean: true, header_search: true) do |cells|
  cells.to_a # => { id: 1, name: 'John Smith' }
end
xlsx.parse('id' => 'ID', 'name' => 'FULL_NAME', header_search: true) do |cells|
  cells.to_a
end
xlsx.parse(id: 'ID', name: 'FULL_NAME', clean: true, headers: true) do |cells|
  cells.to_a
end
xlsx.parse('id' => 'ID', 'name' => 'FULL_NAME', headers: :first_row) do |cells|
  cells.to_a
end
xlsx.parse(id: 'ID', name: 'FULL_NAME') do |cells|
  cells.to_a
end
xlsx.parse(id: /UPC|SKU/, qty: /ATS*\sATP\s*QTY\z/)
# => [{:id => 727880013358, :qty => 12}, ...]
xlsx.row_with([/Header/, /Missing Header 1/, /Missing Header 2/])
xlsx.row_with([/Header/, /Missing Header 1/, /Missing Header 2/], true)

xlsx.close
