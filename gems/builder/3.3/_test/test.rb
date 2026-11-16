require "builder"
require "builder/version"

xml = Builder::XmlMarkup.new(indent: 2, margin: 1, quote: :single, explicit_nil_handling: true)
xml.instruct!
xml.instruct!(:xml, version: "1.0", encoding: "UTF-8")
xml.comment!("generated")
xml.declare!(:DOCTYPE, :html, :PUBLIC, "-//W3C//DTD XHTML 1.0 Strict//EN")
xml.declare!(:DOCTYPE, :html) { |b| b.declare!(:ELEMENT, :p) }
xml.cdata!("<raw>")

xml.tag!(:rss, version: "2.0", "xmlns:g": "http://base.google.com/ns/1.0") do |rss|
  rss.tag!("channel") do |channel|
    channel.tag!(:title, "Feed")
    channel.tag!(:item) do |item|
      item.tag!("g:id", 1)
      item.tag!(:p, :a, "text")
      item.text!("a < b")
      item << "<br/>"
      item.tag!(:br)
    end
  end
end

# @type var output: String
output = xml.target!
output.length

buffer = +""
to_buffer = Builder::XmlMarkup.new(target: buffer)
to_buffer.tag!(:sitemapindex, xmlns: "http://www.sitemaps.org/schemas/sitemap/0.9")
Builder::XmlBase.cache_method_calls = false
Builder::XmlBase.cache_method_calls.!
xml.explicit_nil_handling?
xml.nil?.!
Builder::VERSION.length

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

events = Builder::XmlEvents.new(target: EventCollector.new)
events.tag!(:title, "x")
events.text!("y")
begin
  xml.comment!("x")
rescue Builder::IllegalBlockError => e
  e.message.length
end
