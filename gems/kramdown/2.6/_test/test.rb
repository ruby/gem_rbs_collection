require "kramdown"

doc = Kramdown::Document.new("# Title\n\nSome *emphasis* and ![logo](a.png \"t\")\n")
# @type var html: String
html = doc.to_html
html.start_with?("<h1")

Kramdown::Document.new("text", auto_ids: false, header_offset: 2, input: "kramdown").to_html.empty?
Kramdown::Document.new("text", { input: "Kramdown" }).to_html.empty?
Kramdown::Document.new("text", { "auto_ids" => "false" }).to_html.empty?

# @type var kd: String
kd = doc.to_kramdown
kd.lines
# @type var tex: String
tex = doc.to_latex
tex.strip
# @type var man: String
man = doc.to_man
man.strip

# @type var toc: Kramdown::Element
toc = doc.to_toc
toc.children.each { |entry| entry.attr[:id] }
# @type var stripped: Kramdown::Element
stripped = Kramdown::Document.new("<span>x</span>", remove_span_html_tags: true).to_remove_html_tags
stripped.type
ast = doc.to_hash_ast
ast[:type] if ast.is_a?(Hash)

# @type var messages: Array[String]
messages = doc.warnings
messages.each { |message| message.length }
# @type var doc_options: Hash[Symbol, untyped]
doc_options = doc.options
doc_options[:auto_ids]

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
  # @type var category: :block | :span | nil
  category = Kramdown::Element.category(child)
  category
end

element = Kramdown::Element.new(:p, nil, { "class" => "lead" }, { location: 1 })
element.type = :header
element.value = "text"
element.children = [Kramdown::Element.new(:text, "child")]
element.children.first&.value
# @type var css_class: String
css_class = element.attr["class"]
css_class.upcase
element.options.keys
Kramdown::Element.new(:hr)
Kramdown::Element.new(:text, "plain", nil, nil)
Kramdown::Element.new(:toc, element, id: "title")

begin
  Kramdown::Document.new("x", input: "unknown").to_html
rescue Kramdown::Error => e
  e.message.upcase
end

Kramdown::VERSION.split(".")
# @type var data_dir: String
data_dir = Kramdown.data_dir
data_dir.length

# Options
# @type var definitions: Hash[Symbol, Kramdown::Options::Definition]
definitions = Kramdown::Options.definitions
definition = definitions.fetch(:auto_ids)
definition.name.to_s
definition.desc.length
definition.validator&.call(true)
Kramdown::Options.defined?(:auto_ids)
Kramdown::Options.defined?("auto_ids")
# @type var defaults: Hash[Symbol, untyped]
defaults = Kramdown::Options.defaults
defaults[:header_offset]
# @type var merged: Hash[Symbol, untyped]
merged = Kramdown::Options.merge(header_offset: "1", "auto_ids" => false)
merged[:header_offset]
Kramdown::Options.parse(:header_offset, "2")
# @type var sym: Symbol?
sym = Kramdown::Options.str_to_sym(":rouge")
sym
Kramdown::Options.simple_array_validator("a,b", :toc_levels)
Kramdown::Options.simple_array_validator([1, 2], :smart_quotes, 2)
Kramdown::Options.simple_hash_validator("a: 1", :syntax_highlighter_opts)
Kramdown::Options::Boolean === true

# Parsers
# @type var parsed: [Kramdown::Element, Array[String]]
parsed = Kramdown::Parser::Kramdown.parse("*a*", auto_ids: false)
parsed[0].children
Kramdown::Parser::Html.parse("<p>a</p>")
Kramdown::Parser::Markdown.parse("a")
Kramdown::Parser::Kramdown.has_parser?(:emphasis)
# @type var parser_data: Kramdown::Parser::Kramdown::Data?
parser_data = Kramdown::Parser::Kramdown.parser(:emphasis)
parser_data&.start_re

# Converters
# @type var converted: [String, Array[String]]
converted = Kramdown::Converter::Html.convert(root, auto_ids: false)
converted[0].length
Kramdown::Converter::Latex.convert(root)
Kramdown::Converter::Kramdown.convert(root)
Kramdown::Converter::Man.convert(root)
# @type var toc_result: [Kramdown::Element, Array[String]]
toc_result = Kramdown::Converter::Toc.convert(root)
toc_result[0].children
Kramdown::Converter::RemoveHtmlTags.convert(root)
hash_ast = Kramdown::Converter::HashAST.convert(root)[0]
hash_ast[:type] if hash_ast.is_a?(Hash)
Kramdown::Converter::HashAst.convert(root)

Kramdown::Converter.add_syntax_highlighter(:plain) do |_converter, text, _lang, _type, _opts|
  text
end
Kramdown::Converter.syntax_highlighter(:plain)
Kramdown::Converter.add_math_engine(:plain) { |_converter, el, _opts| el.type.to_s }
Kramdown::Converter.math_engine(:plain)
Kramdown::Converter.configurables.keys

class UpcaseHtml < Kramdown::Converter::Html
  def convert_text(el, indent)
    # @type var text: String
    text = super
    text.upcase
  end

  def convert_header(el, indent)
    # @type var raw_text: String
    raw_text = el.options[:raw_text]
    id = generate_id(raw_text)
    format_as_block_html("h#{output_header_level(el.options[:level])}", { "id" => id }, inner(el, indent), indent)
  end
end
UpcaseHtml.convert(root)[0].length

# Utils
Kramdown::Utils.camelize("hash_ast").length
Kramdown::Utils.snake_case("HashAST").length
Kramdown::Utils::Entities.entity("nbsp").char
Kramdown::Utils::Entities.entity(160).code_point
# @type var entity: Kramdown::Utils::Entities::Entity
entity = Kramdown::Utils::Entities::Entity.new(65, nil)
entity.char&.length
custom = Kramdown::Options::Definition.new(:my_option, String, "", "My option", nil)
custom.type
Kramdown::Parser::Kramdown::Data.new(:erb, /<%/, "<%", "parse_erb").method.length
Kramdown::Options.define(:my_validated, Object, nil, "Validated") { |value| value }
