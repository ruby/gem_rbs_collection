require "terminal-table"

rows = [["One", 1], ["Two", 2], ["Three", 3]]

# @type var report: Terminal::Table
report = Terminal::Table.new(title: "Cheatsheet", headings: %w[Word Number], rows: rows, style: { width: 40 })
report << ["Four", { value: 4.0, alignment: :center }]
report << :separator
report.add_row ["Five", 5]
report.add_separator(border_type: :double)
report.align_column(1, :right)
report.style = { border: :unicode_round, padding_left: 2, border_top: false }
report.style.padding_right = 2
report.style.alignment = :center

# @type var rendered: String
rendered = report.render
puts rendered
puts report

# @type var width: Integer
width = report.column_width(0)
# @type var values: Array[untyped]
values = report.column(0)
# @type var cells: Array[Terminal::Table::Cell]
cells = report.column(1, nil)
# @type var table_rows: Array[Terminal::Table::Row]
table_rows = report.rows
puts width, values.size, cells.size, table_rows.size, report.number_of_columns

# A block with a parameter receives the report.
# @type var yielded: Terminal::Table
yielded = Terminal::Table.new do |t|
  t.headings = ["id", "name"]
  t.rows = [[1, "One"], [2, "Two"]]
  t.title = "Yielded"
end

# A block without parameters runs with the table as self.
# @type var evaluated: Terminal::Table
evaluated = Terminal::Table.new do
  self.headings = ["id", "name"]
  add_row [1, "One"]
  add_separator
  self.style = { all_separators: true }
end
evaluated.elaborate_rows.each do |row|
  row.border_type = :heavy if row.is_a?(Terminal::Table::Separator)
end
puts yielded, evaluated, yielded == evaluated

# @type var style: Terminal::Table::Style
style = Terminal::Table::Style.new(border: :ascii)
style.border_x = "="
style.border_i = "x"
# @type var border: Terminal::Table::Border
border = style.border
border[:x] = "-"
Terminal::Table::Style.defaults = { padding_left: 1 }

# @type var cell: Terminal::Table::Cell?
cell = report.rows.first&.[](0)
puts cell&.value, cell&.alignment

class Report
  include Terminal::Table::TableHelper

  def build
    # @type var helper: Terminal::Table
    helper = table(["a", "b"], [1, 2], [3, 4])
    helper.render
  end
end
puts Report.new.build
