require "loofah"
require "loofah/helpers"

# Parsing and scrubbing
unsafe_html = "ohai! <div>div is safe</div> <script>but script is not</script>"

html4_frag = Loofah.html4_fragment(unsafe_html)
html4_str = html4_frag.scrub!(:strip).to_s
html4_str.upcase

html5_frag = Loofah.html5_fragment(unsafe_html, "UTF-8")
# @type var scrubbed: Loofah::HTML5::DocumentFragment
scrubbed = html5_frag.scrub!(:prune)
scrubbed.serialize.upcase

# @type var html5_doc: Loofah::HTML5::Document
html5_doc = Loofah.html5_document("<html><body><h1>Title</h1></body></html>")
html5_doc.scrub!(:escape).to_s.upcase

# @type var html5_doc_with_options: Loofah::HTML5::Document
html5_doc_with_options = Loofah.html5_document("<p>a</p>", nil, "UTF-8") { |options| options[:max_errors] = 10 }
html5_doc_with_options.to_s.upcase

# @type var html4_doc: Loofah::HTML4::Document
html4_doc = Loofah.html4_document("<h1>Title</h1>", nil, "UTF-8")
html4_doc.scrub!(:whitewash)

# @type var default_doc: Loofah::HTML4::Document
default_doc = Loofah.document("<p>hi</p>") { |options| options.noblanks }
# @type var default_frag: Loofah::HTML4::DocumentFragment
default_frag = Loofah.fragment("<p>hi</p>")
default_frag.to_s.upcase

Loofah.scrub_html4_fragment(unsafe_html, :strip).to_s.upcase
Loofah.scrub_html4_document(unsafe_html, :strip).to_s.upcase
Loofah.scrub_html5_fragment(unsafe_html, :strip).to_s.upcase
Loofah.scrub_html5_document(unsafe_html, :strip).to_s.upcase
Loofah.scrub_fragment(unsafe_html, :nofollow).to_s.upcase
Loofah.scrub_document(unsafe_html, :nofollow).to_s.upcase

# @type var xml_doc: Loofah::XML::Document
xml_doc = Loofah.xml_document("<root><child/></root>")
xml_doc.scrub!(:strip)
# @type var xml_frag: Loofah::XML::DocumentFragment
xml_frag = Loofah.xml_fragment("<child/>")
xml_frag.scrub!(:prune)
Loofah.scrub_xml_document("<root/>", :strip).to_s.upcase
Loofah.scrub_xml_fragment("<child/>", :strip).to_s.upcase

Loofah.html5_support? ? 1 : 0
Loofah::VERSION.upcase
Loofah.remove_extraneous_whitespace("a\n\n\n\nb").upcase

# nil becomes an empty fragment
Loofah.html5_fragment(nil).to_s.upcase
Loofah.html4_fragment(nil).to_s.upcase
Loofah.xml_fragment(nil).to_s.upcase
Loofah.scrub_html5_fragment(File.open(__FILE__), :strip).to_s.upcase
Loofah::HTML5::DocumentFragment.parse(File.open(__FILE__)).to_s.upcase

# Loofah::HTML is Loofah::HTML4
# @type var legacy_doc: Loofah::HTML::Document
legacy_doc = Loofah::HTML::Document.parse("<p>a</p>")
legacy_doc.to_s.upcase

# Text conversion
frag = Loofah.html5_fragment("<h1>Title</h1><div>Content<br>Next line</div>")
frag.text.upcase
frag.text(encode_special_chars: false).upcase
frag.inner_text.upcase
frag.to_str.upcase
frag.to_text.upcase
text_options = { encode_special_chars: false }
frag.to_text(text_options).strip.upcase

# Parsing through the classes
# @type var parsed4: Loofah::HTML4::Document
parsed4 = Loofah::HTML4::Document.parse("<p>a</p>")
# @type var parsed4_frag: Loofah::HTML4::DocumentFragment
parsed4_frag = Loofah::HTML4::DocumentFragment.parse("<p>a</p>", "UTF-8")
# @type var parsed5: Loofah::HTML5::Document
parsed5 = Loofah::HTML5::Document.parse("<p>a</p>")
# @type var parsed5_frag: Loofah::HTML5::DocumentFragment
parsed5_frag = Loofah::HTML5::DocumentFragment.parse("<p>a</p>")
# @type var parsed_xml: Loofah::XML::Document
parsed_xml = Loofah::XML::Document.parse("<a/>")
# @type var parsed_xml_frag: Loofah::XML::DocumentFragment
parsed_xml_frag = Loofah::XML::DocumentFragment.parse("<a/>")
[parsed4.to_s, parsed4_frag.to_s, parsed5.to_s, parsed5_frag.to_s, parsed_xml.to_s, parsed_xml_frag.to_s].map(&:upcase)

# Scrubbers
class Span2Div < Loofah::Scrubber
  def initialize
    super(direction: :bottom_up)
  end

  def scrub(node)
    node.name = "div" if node.name == "span"
    Loofah::Scrubber::CONTINUE
  end
end

span2div = Loofah::Scrubber.new do |node|
  node.name = "div" if node.name == "span"
end
Loofah.html5_fragment("<span>foo</span>").scrub!(span2div).to_s.upcase
Loofah.html5_fragment("<span>foo</span>").scrub!(Span2Div.new).to_s.upcase
Loofah.scrub_fragment("<span>foo</span>", Span2Div.new).to_s.upcase

stopper = Loofah::Scrubber.new(direction: :top_down) do |node|
  next Loofah::Scrubber::STOP if node.name == "pre"
  nil
end
# @type var direction: :top_down | :bottom_up
direction = stopper.direction
direction.to_s.upcase
stopper.block&.call(Loofah.fragment("<p/>"))

class LinkScrubber < Loofah::Scrubber
  def scrub(node)
    return Loofah::Scrubber::CONTINUE unless node.name == "a"

    # @type var rel: String
    rel = append_attribute(node, "rel", "nofollow")
    rel.upcase
    node.remove
    Loofah::Scrubber::STOP
  end
end
Loofah.html5_fragment("<a href='/'>x</a>").scrub!(LinkScrubber.new)

Span2Div.new.scrub(Loofah.fragment("<p/>").children.first)
Loofah::Scrubbers::Strip.new
Loofah::Scrubbers::Prune.new
Loofah::Scrubbers::Escape.new
Loofah::Scrubbers::Whitewash.new
Loofah::Scrubbers::NoFollow.new
Loofah::Scrubbers::TargetBlank.new
Loofah::Scrubbers::NoOpener.new
Loofah::Scrubbers::NoReferrer.new
Loofah::Scrubbers::Unprintable.new
Loofah::Scrubbers::DoubleBreakpoint.new
Loofah::Scrubbers::MAP[:strip]&.new
# @type var symbols: Array[Symbol]
symbols = Loofah::Scrubbers.scrubber_symbols
symbols.first

begin
  Loofah.html5_fragment("<p/>").scrub!(:no_such_scrubber)
rescue Loofah::ScrubberNotFound => e
  e.message.upcase
end

# View helpers
Loofah::Helpers.strip_tags("<div>Hello <b>there</b></div>").upcase
Loofah::Helpers.sanitize("<script>alert(1)</script>").upcase

# Scrub utilities and safe lists
Loofah::HTML5::Scrub.allowed_uri?("https://example.com") ? 1 : 0
Loofah::HTML5::Scrub.allowed_element?("div") ? 1 : 0
Loofah::HTML5::Scrub.scrub_css("display:block").upcase
Loofah::HTML5::Scrub::CONTROL_CHARACTERS.match?("a")

# Node-level helpers inside a custom scrubber
checker = Loofah::Scrubber.new do |node|
  if node.element?
    next Loofah::Scrubber::STOP unless Loofah::HTML5::Scrub.allowed_element?(node.name)

    Loofah::HTML5::Scrub.scrub_attributes(node)
    # @type var attr_nodes: Array[Nokogiri::XML::Attr]
    attr_nodes = node.attribute_nodes
    attr_nodes.each do |attr_node|
      Loofah::HTML5::Scrub.scrub_uri_attribute(attr_node) if attr_node.name == "href"
    end
  elsif Loofah::HTML5::Scrub.cdata_needs_escaping?(node)
    # @type var escaped: Nokogiri::XML::Node
    escaped = Loofah::HTML5::Scrub.cdata_escape(node)
    node.before(escaped)
  end
  Loofah::Scrubber::CONTINUE
end
Loofah.html5_fragment("<a href='javascript:x'>x</a>").scrub!(checker)

# Customizing the safe lists
Loofah::HTML5::SafeList::ALLOWED_ELEMENTS_WITH_LIBXML2.delete("form")
Loofah::HTML5::SafeList::ALLOWED_ELEMENTS_WITH_LIBXML2.merge(%w[audio video])
Loofah::HTML5::SafeList::ALLOWED_PROTOCOLS.add("tel")
Loofah::HTML5::SafeList::ALLOWED_ATTRIBUTES.merge(%w[data-foo])
Loofah::HTML5::SafeList::ACCEPTABLE_CSS_PROPERTIES.include?("position")
Loofah::HTML5::SafeList::ACCEPTABLE_ATTRIBUTES.to_a.first&.upcase
[
  Loofah::HTML5::SafeList::ACCEPTABLE_ELEMENTS,
  Loofah::HTML5::SafeList::MATHML_ELEMENTS,
  Loofah::HTML5::SafeList::SVG_ELEMENTS,
  Loofah::HTML5::SafeList::MATHML_ATTRIBUTES,
  Loofah::HTML5::SafeList::SVG_ATTRIBUTES,
  Loofah::HTML5::SafeList::ARIA_ATTRIBUTES,
  Loofah::HTML5::SafeList::ACCEPTABLE_CSS_KEYWORDS,
  Loofah::HTML5::SafeList::ACCEPTABLE_CSS_COLORS,
  Loofah::HTML5::SafeList::ACCEPTABLE_CSS_EXTENDED_COLORS,
  Loofah::HTML5::SafeList::ACCEPTABLE_CSS_FUNCTIONS,
  Loofah::HTML5::SafeList::ACCEPTABLE_SVG_PROPERTIES,
  Loofah::HTML5::SafeList::ACCEPTABLE_PROTOCOLS,
  Loofah::HTML5::SafeList::ACCEPTABLE_URI_DATA_MEDIATYPES,
  Loofah::HTML5::SafeList::ALLOWED_ELEMENTS,
  Loofah::HTML5::SafeList::ALLOWED_CSS_PROPERTIES,
  Loofah::HTML5::SafeList::ALLOWED_CSS_KEYWORDS,
  Loofah::HTML5::SafeList::ALLOWED_CSS_FUNCTIONS,
  Loofah::HTML5::SafeList::ALLOWED_SVG_PROPERTIES,
  Loofah::HTML5::SafeList::ALLOWED_URI_DATA_MEDIATYPES
].each { |set| set.size.succ }
