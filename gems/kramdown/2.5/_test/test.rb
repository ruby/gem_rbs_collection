require "kramdown"

doc = Kramdown::Document.new("# Title\n\nSome *emphasis* and ![logo](a.png \"t\")\n")
html = doc.to_html
html.start_with?("<h1")

Kramdown::Document.new("text", auto_ids: false, header_offset: 2, input: "kramdown").to_html.empty?
Kramdown::Document.new("text", { input: "Kramdown" }).to_html.empty?

kd = doc.to_kramdown
kd.lines
tex = doc.to_latex
tex.strip

# @type var messages: Array[String]
messages = doc.warnings
messages.each { |message| message.length }
doc.options[:auto_ids]

# @type var root: Kramdown::Element
root = doc.root
doc.root = root
root.type == :root
root.children.each do |child|
  child.type.to_s
  child.value
  child.options[:category]
  child.attr["id"]
  child.block?
  child.span?
  Kramdown::Element.category(child)
end

element = Kramdown::Element.new(:p, nil, { "class" => "lead" }, { location: 1 })
element.type = :header
element.value = "text"
element.children = [Kramdown::Element.new(:text, "child")]
element.children.first&.value
element.attr["class"].upcase
element.options.keys
Kramdown::Element.new(:hr)
Kramdown::Element.new(:text, "plain", nil, nil)

begin
  Kramdown::Document.new("x", input: "unknown").to_html
rescue Kramdown::Error => e
  e.message.upcase
end

Kramdown::VERSION.split(".")
