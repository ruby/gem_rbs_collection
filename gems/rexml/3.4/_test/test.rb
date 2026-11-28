require "rexml/document"
require "rexml/streamlistener"
require "rexml/sax2listener"
require "rexml/parsers/sax2parser"
require "rexml/parsers/pullparser"
require "rexml/parsers/streamparser"
require "stringio"

xml = <<~XML
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE library>
  <library xmlns:b="http://example.com/book">
    <b:book id="1" lang="en"><title>Ruby</title><!-- note --><![CDATA[<raw>]]></b:book>
    <book id="2"><title>XML</title><?pi data?></book>
  </library>
XML

# @type var doc: REXML::Document
doc = REXML::Document.new(xml)
# @type var root: REXML::Element?
root = doc.root
raise unless root

# @type var name: String
name = root.name
# @type var decl: REXML::XMLDecl
decl = doc.xml_decl
# @type var version: String
version = decl.version
# @type var doctype: REXML::DocType?
doctype = doc.doctype
doctype&.name
doc.encoding
doc.stand_alone?

# @type var books: Array[REXML::Element]
books = root.get_elements("book")
# @type var first: REXML::Element?
first = root.elements[1]
root.elements["b:book/title"]
# @type var count: Integer
count = root.elements.size
root.elements.each("book") { |e| e.name }
# @type var titles: Array[String?]
titles = root.elements.collect { |e| e.attributes["id"] }
root.each_element { |e| e.text }
root.each_element_with_attribute("id", "2") { |e| e.name }
root.each_element_with_text(nil, 1) { |e| e.name }

if first
  # @type var id: String?
  id = first.attributes["id"]
  # @type var attr: REXML::Attribute?
  attr = first.attribute("id")
  attr&.value
  first.attributes.each { |(key, value)| key + value }
  first.attributes.each_attribute { |a| a.expanded_name }
  # @type var text: String?
  text = first.text("title")
  # @type var texts: Array[REXML::Text]
  texts = first.texts
  first.comments
  first.cdatas
  first.namespace
  first.has_elements?
  first.xpath
end

# @type var added: REXML::Element
added = root.add_element("book", { "id" => "3" })
added.add_attribute("lang", "ja")
added.add_attributes({ "year" => 2024 })
added.text = "new"
added.add_text("!")
added.add(REXML::Comment.new("added"))
added.add(REXML::CData.new("<cdata>"))
added.add(REXML::Instruction.new("target", "content"))
added.delete_attribute("year")
root.delete_element(added)

# @type var element: REXML::Element
element = REXML::Element.new("item")
element.add_namespace("x", "http://example.com/x")
element["id"]
element.attributes["count"] = 1
element.children
element.each_child { |child| child.parent }

REXML::XPath.first(doc, "//title")
# @type var matches: Array[untyped]
matches = REXML::XPath.match(doc, "//b:book", { "b" => "http://example.com/book" })
REXML::XPath.each(doc, "//title") { |node| node }

# @type var out: String
out = +""
doc.write(output: out, indent: 2)
doc.write(out)
REXML::Formatters::Default.new.write(doc, out)
pretty = REXML::Formatters::Pretty.new(2)
pretty.compact = true
pretty.write(root, $stdout)
# @type var str: String
str = doc.to_s

text_node = REXML::Text.new("a & b")
text_node.value
text_node.to_s
REXML::Text.normalize("<")
REXML::Text.unnormalize("&lt;")

begin
  REXML::Document.new("<broken>")
rescue REXML::ParseException => e
  e.line
  e.position
end

class MyStreamListener
  include REXML::StreamListener

  def tag_start(name, attrs)
    puts name, attrs.size
  end
end
REXML::Document.parse_stream(xml, MyStreamListener.new)
REXML::Parsers::StreamParser.new(StringIO.new(xml), MyStreamListener.new).parse

class MySAX2Listener
  include REXML::SAX2Listener

  def start_element(uri, localname, qname, attributes)
    puts uri, localname, qname, attributes.size
  end
end
sax = REXML::Parsers::SAX2Parser.new(xml)
sax.listen(MySAX2Listener.new)
sax.listen(:characters) { |chars| chars }
sax.listen(:start_element, ["title"]) { |_uri, local, _qname, _attrs| local }
sax.parse

pull = REXML::Parsers::PullParser.new(xml)
while pull.has_next?
  # @type var event: REXML::Parsers::PullEvent
  event = pull.pull
  event[0] if event.start_element?
  event.event_type
end
