require "rubyXL"
require "rubyXL/convenience_methods"

workbook = RubyXL::Workbook.new

worksheets = workbook.worksheets
worksheet = worksheets[0]

new_sheet = workbook.add_worksheet("Sheet2")
new_sheet.sheet_name = "Renamed Sheet"
name = new_sheet.sheet_name

sheet_by_index = workbook[0]
sheet_by_name = workbook["Sheet1"]

cell = new_sheet.add_cell(0, 0, "Hello, RubyXL!")
cell2 = new_sheet.add_cell(0, 1, 42)
cell3 = new_sheet.add_cell(1, 0, 3.14)

val = cell.value

cell.change_fill("FF0000")
cell.change_font_bold(true)
cell.change_text_wrap(true)
cell.change_vertical_alignment("center")

new_sheet.change_row_height(0, 20)
new_sheet.change_row_font_size(0, 12)
new_sheet.change_column_width(0, 15)

sheet_data = new_sheet.sheet_data
rows = sheet_data.rows
row_count = sheet_data.size

row = new_sheet[0]
if row
  cells = row.cells
  cell_count = row.size

  first_cell = row[0]
  if first_cell
    first_val = first_cell.value
  end
end

io = workbook.stream
