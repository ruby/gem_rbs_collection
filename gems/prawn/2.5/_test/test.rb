require "prawn"
require "stringio"
require "pathname"

# A 1x1 PNG
PNG_DATA = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==".unpack1("m").to_s

# Document.new / Document.generate
doc = Prawn::Document.new
a4 = Prawn::Document.new(page_size: "A4", page_layout: :landscape, margin: [20, 40])
custom = Prawn::Document.new(page_size: [200, 300], margin: 0, compress: true, info: { Title: "T" })
Prawn::Document.new(left_margin: 10, right_margin: 10, top_margin: 5, bottom_margin: 5, skip_page_creation: false)
Prawn::Document.new(margin: 12.5) { |pdf| pdf.text "hi" }

Prawn::Document.generate(File::NULL, page_size: "A4") do |pdf|
  pdf.font "Times-Roman"
  pdf.text "Hello"
end

Prawn::Document.generate(Pathname(File::NULL)) do
  font "Times-Roman"
  text "Hello"
  bounding_box([0, cursor], width: 100) { text "inside" }
end

Prawn::Document.new(page_size: "A4") do
  text "evaluated in the document"
end

# Page management and cursor
doc.start_new_page
doc.start_new_page(size: "A4", layout: :landscape, margin: 1)
doc.start_new_page(margin: [1, 2], left_margin: 3, right_margin: 4, top_margin: 5, bottom_margin: 6)
count = doc.page_count + 0
doc.go_to_page(1)
deleted = doc.delete_page(2)
puts "deleted" if deleted
doc.y = 100
y = doc.y + 1
cursor = doc.cursor + 1
doc.move_cursor_to(200)
doc.move_up(10)
doc.move_down(10.5)
doc.page_number = doc.page_number + 1
margin_box = doc.margin_box
doc.margin_box = margin_box
doc.float { doc.text "floating" }
doc.pad_top(5) { doc.text "a" }
doc.pad_bottom(5) { doc.text "b" }
doc.pad(5) { doc.text "c" }
doc.indent(10) { doc.text "d" }
doc.indent(10, 5) { doc.text "e" }

# Bounds
bounds = doc.bounds
width = bounds.width + 1
height = bounds.height + 1
left = bounds.left + bounds.right + bounds.top + bounds.bottom
corners = [bounds.top_left, bounds.top_right, bounds.bottom_left, bounds.bottom_right]
first_corner_x = corners.first[0] + 1
absolute = bounds.absolute_left + bounds.absolute_right + bounds.absolute_top + bounds.absolute_bottom
bounds.indent(5) { doc.text "f" }
bounds.indent(5, 5) { doc.text "g" }
doc.bounds = margin_box

box = doc.bounding_box([bounds.left, bounds.top], width: bounds.width, height: bounds.height - 35) do
  doc.bounding_box([bounds.right - 225, bounds.top], width: 225) do
    doc.text "inside", align: :right
  end
end
box_width = box.width + 1
doc.canvas { doc.stroke_bounds }

# Text
doc.text "plain"
doc.text nil
doc.text "styled", style: :bold, align: :right, size: 12.5, color: "C1C1C1", leading: 2, kerning: true
doc.text "valign", valign: :center, width: 100, height: 50, overflow: :shrink_to_fit, min_font_size: 6, single_line: true
doc.text "<b>bold</b>", inline_format: true
doc.text "<b>bold</b>", inline_format: [{ foo: 1 }]
doc.text "mixed", mode: :stroke, direction: :ltr, fallback_fonts: ["Helvetica"], indent_paragraphs: 5, final_gap: false, character_spacing: 1
doc.formatted_text([{ text: "hello" }, { text: "world", size: 24, styles: [:bold, :italic], color: [0, 0, 0, 0], font: "Courier", character_spacing: 2, link: "http://example.com", anchor: "a" }], align: :center)
doc.draw_text "drawn", at: [10, 20]
doc.draw_text "drawn", at: [10.5, 20], size: 8, style: :bold, kerning: false, rotate: 45
remaining = doc.text_box("box", at: [0, 100], width: 200, height: 20, overflow: :truncate, rotate: 30, rotate_around: :center)
remaining.upcase
fragments = doc.text_box("<b>inline</b>", inline_format: true, at: [0, 100], width: 100)
fragments.first[:text].upcase
text_height = doc.height_of("text", width: 100) + 1
fragments_height = doc.height_of_formatted([{ text: "x" }], width: 100) + 1
doc.number_pages "Page <page> of <total>", start_count_at: 1, at: [bounds.right - 130, 22], align: :right
doc.number_pages "<page>", page_filter: :odd, total_pages: 5, color: "000000", width: 100, height: 20, valign: :top, size: 9, style: :bold
doc.number_pages "<page>", page_filter: [1, 2], start_count_at: "2"
doc.number_pages "<page>", page_filter: 1..2, overflow: :truncate, kerning: true, rotate: 5, rotate_around: :center
doc.number_pages "<page>", page_filter: ->(n) { n.even? }

# Fonts
font = doc.font
font_name = font.name.upcase
font_family = font.family&.upcase
font_options = font.options.keys
font_metrics = font.ascender + font.descender + font.line_gap + font.height + font.height_at(10)
doc.font("Helvetica-Bold")
doc.font("Helvetica", style: :bold, size: 10)
doc.font("Times-Roman") { doc.text "in block" }
doc.font_size = 12.2
doc.font_size 10
doc.font_size(8) { doc.text "small" }
size = doc.font_size + 1
string_width = doc.width_of("abc") + doc.width_of("abc", size: 12, kerning: true, style: :bold, inline_format: true)
doc.font_families["OpenSans"] = { normal: "/path/to/font.ttf", bold: Pathname("/path/to/bold.ttf") }
doc.font_families.update(
  "ABC" => {
    normal: { file: Pathname("/path/regular.ttf"), subset: false },
    italic: { file: "/path/italic.ttf" }
  }
)
doc.font_families["OpenSans"].keys

# Graphics
doc.fill_color "C1C1C1"
doc.fill_color 0, 99, 95, 0
doc.fill_color [255, 0, 0]
doc.stroke_color "000000"
doc.stroke_color 0, 0, 0, 100
doc.stroke_color [0, 0, 0]
fill = doc.fill_color
fill.is_a?(String)
stroke = doc.stroke_color
stroke.is_a?(Array)
doc.line_width = 2
doc.line_width 1.5
lw = doc.line_width + 1
doc.dash 5
doc.dash [3, 2], space: 4, phase: 1
doc.dash(1, phase: 2)
doc.undash
dashed = doc.dashed?
doc.transparent(0.5) { doc.fill_circle [10, 10], 5 }
doc.transparent(0.5, 0.25) { doc.stroke_circle [10, 10], 5 }

doc.move_to [0, 0]
doc.move_to 0, 0
doc.line_to [10, 10]
doc.line_to 10, 10
doc.stroke
doc.stroke { doc.line [0, 0], [10, 10] }
doc.line 0, 0, 10, 10
doc.line [0, 0], [10, 10]
doc.close_and_stroke
doc.close_and_stroke { doc.rectangle [0, 0], 10, 10 }
doc.horizontal_line 0, 100
doc.horizontal_line 0, 100, at: 50
doc.vertical_line 0, 100, at: 50
doc.horizontal_rule
doc.circle [10, 10], 5
doc.polygon [0, 0], [10, 0], [5, 10]
doc.fill
doc.fill(fill_rule: :even_odd)
doc.fill { doc.circle [1, 1], 1 }
doc.fill_and_stroke
doc.fill_and_stroke(fill_rule: :nonzero) { doc.rectangle [0, 0], 5, 5 }
doc.close_path
doc.stroke_rectangle [0, 0], 10, 10
doc.fill_rectangle [0, 0], 10.5, 10
doc.stroke_circle [10, 10], 5
doc.fill_circle [10, 10], 5
doc.stroke_line [0, 0], [5, 5]
doc.stroke_line 0, 0, 5, 5
doc.stroke_horizontal_line 0, 50
doc.stroke_horizontal_line 0, 50, at: 10
doc.stroke_horizontal_rule
doc.stroke_vertical_line 0, 50, at: 10
doc.stroke_polygon [0, 0], [10, 0], [5, 10]
doc.fill_polygon [0, 0], [10, 0], [5, 10]
doc.stroke do
  doc.horizontal_line 0, 20
  doc.horizontal_line 30, doc.bounds.width
end

# Images
image = doc.image(StringIO.new(PNG_DATA))
image_width = image.width + image.height + 1
scaled = image.scaled_width
image.scaled_width = 10
image.scaled_height = 20.5
scaled_height = image.scaled_height
doc.image(StringIO.new(PNG_DATA), fit: [250, 85])
doc.image(StringIO.new(PNG_DATA), width: 75, vposition: :center, position: :right)
doc.image(StringIO.new(PNG_DATA), at: [10, 20], height: 30, scale: 0.5, position: 5, vposition: :top)
begin
  doc.image("missing.png", position: :center, vposition: :bottom)
  doc.image(Pathname("missing.png"))
rescue ArgumentError => e
  e.message
end

# Repeat
doc.repeat(:all) { doc.text "footer" }
doc.repeat(:odd, dynamic: true) { doc.text "odd" }
doc.repeat([1, 2]) { doc.text "x" }
doc.repeat(1..3) { doc.text "x" }
doc.repeat(->(n) { n > 1 }) { doc.text "x" }

# Rendering
rendered = doc.render
rendered.bytesize
doc.render_file(File::NULL)
doc.render_file(Pathname(File::NULL))
doc.render(StringIO.new).length
a4.render
custom.render

# View
class ReportPdf
  include Prawn::View

  def build
    document.text "Report"
    update { document.text "updated" }
    save_as File::NULL
    save_as Pathname(File::NULL)
  end

  def draw
    font_families["Report"] = { normal: "/path/to/report.ttf" }
    font "Helvetica", size: 10
    font_size 12
    text "forwarded to the document"
    bounding_box([bounds.left, bounds.top], width: bounds.width) { text "inside" }
    move_down 10
    stroke_horizontal_rule
    image StringIO.new(PNG_DATA), width: 10
    number_pages "<page>", at: [0, 0]
    repeat(:all) { draw_text "footer", at: [0, 0] }
    start_new_page
    page_count
  end
end
ReportPdf.new.build
ReportPdf.new.draw
view_doc = ReportPdf.new.document
view_doc.page_count

# Errors and constants
version = Prawn::VERSION.upcase
begin
  doc.image(StringIO.new("GIF89a"))
rescue Prawn::Errors::UnsupportedImageType, Prawn::Errors::UnknownFont => e
  e.message
rescue Prawn::Errors::NotOnPage, Prawn::Errors::CannotFit, Prawn::Errors::IncompatibleStringEncoding,
       Prawn::Errors::UnknownOption, Prawn::Errors::NameTaken, Prawn::Errors::InvalidName,
       Prawn::Errors::UndefinedObjectName, Prawn::Errors::RequiredOption, Prawn::Errors::BlockRequired,
       Prawn::Errors::InvalidGraphicsPath, Prawn::Errors::InvalidJoinStyle => e
  e.message
end
