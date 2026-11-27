require "builder"
require "builder/version"

# @type var xml: Builder::XmlMarkup
xml = Builder::XmlMarkup.new(indent: 2, margin: 1, quote: :single, explicit_nil_handling: true)
xml.instruct!
xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
xml.instruct!("xml-stylesheet", type: "text/xsl", href: "style.xsl")
xml.comment!("generated")
xml.declare!(:DOCTYPE, :html, :PUBLIC, "-//W3C//DTD XHTML 1.0 Strict//EN")
xml.declare!(:DOCTYPE, :html) { |b| b.declare!(:ELEMENT, :p) }
xml.cdata!("<raw>")
xml.cdata_value!("content:encoded", "<p>text</p>")
xml.cdata_value!(:summary, "x ]]> y")

xml.tag!(:rss, version: "2.0", "xmlns:g": "http://base.google.com/ns/1.0") do |rss|
  rss.tag!("channel") do |channel|
    channel.tag!(:title, "Feed")
    channel.tag!(:item) do |item|
      item.tag!("g:id", 1)
      item.tag!(:p, :a, "text")
      item.tag!(:empty, nil)
      item.text!("a < b")
      item << "<br/>"
      item.tag!(:br)
    end
  end
end

# @type var output: String
output = xml.target!
output.length

options = { indent: 2 } #: Hash[Symbol, untyped]
Builder::XmlMarkup.new(options)
Builder::XmlMarkup.new

buffer = +""
# @type var to_buffer: Builder::XmlMarkup
to_buffer = Builder::XmlMarkup.new(target: buffer, indent: nil, margin: nil)
# With a String target, tag! returns it.
# @type var sitemap: String
sitemap = to_buffer.tag!(:sitemapindex, xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9")
sitemap.length
to_buffer.tag!(:changefreq) { to_buffer.text!("daily") }
to_buffer.tag!(:g, :id, "1")
to_buffer.method_missing(:loc, "https://example.com/", nil, { lang: "en" })
to_buffer.method_missing(:url) { |url| url.tag!(:loc, "https://example.com/") }

# Builders can be targets of other builders, as can IO and Arrays.
nested = Builder::XmlMarkup.new(target: to_buffer)
nested.tag!(:inner)
Builder::XmlMarkup.new(target: $stdout)
lines = [] #: Array[String]
Builder::XmlMarkup.new(target: lines).tag!(:line)

Builder::XmlBase.cache_method_calls = false
# @type var caching: boolish
caching = Builder::XmlBase.cache_method_calls

# @type var nil_handling: bool?
nil_handling = xml.explicit_nil_handling?
nil_handling.nil?

# @type var is_nil: false
is_nil = xml.nil?
is_nil.!

# @type var version: String
version = Builder::VERSION
version.length
# @type var version_numbers: Array[Integer]
version_numbers = Builder::VERSION_NUMBERS
version_numbers.sum
# @type var major: Integer
major = Builder::VERSION_MAJOR
major + Builder::VERSION_MINOR + Builder::VERSION_BUILD

class EventCollector
  def initialize
    @events = []
  end

  def start_tag(name, attrs)
    @events << [:start, name, attrs]
  end

  def end_tag(name)
    @events << [:end, name]
  end

  def text(string)
    @events << [:text, string]
  end
end

# @type var events: Builder::XmlEvents
events = Builder::XmlEvents.new(target: EventCollector.new, indent: 2)
events.tag!(:title, "x")
events.text!("y")
event_options = { target: EventCollector.new } #: Hash[Symbol, untyped]
Builder::XmlEvents.new(event_options)

# @type var escaped: String
escaped = Builder::XChar.encode("a < b & \u00e9")
escaped.length
# @type var utf8: String
utf8 = Builder::XChar.unicode("caf\xE9".b)
utf8.length

begin
  xml.comment!("x")
rescue Builder::IllegalBlockError => e
  e.message.length
end

# @type var collision: nil
collision = Builder.check_for_name_collision(String, :no_such_builder_method)
collision.nil?
