require "reverse_markdown"
require "nokogiri"

html = "<h1>Title</h1><p>Hello <strong>world</strong></p>"

markdown = ReverseMarkdown.convert(html)
markdown.strip

ReverseMarkdown.convert(html, unknown_tags: :bypass, github_flavored: true, tag_border: "").strip
ReverseMarkdown.convert(html, unknown_tags: "drop", force_encoding: true).strip
ReverseMarkdown.convert(Nokogiri::HTML(html)).strip
ReverseMarkdown.convert(Nokogiri::HTML::DocumentFragment.parse(html)).strip
ReverseMarkdown.convert(nil).strip
# @type var convert_options: Hash[Symbol, untyped]
convert_options = { github_flavored: true }
ReverseMarkdown.convert(html, convert_options).strip

ReverseMarkdown::VERSION.upcase

config = ReverseMarkdown.config
# @type var config: ReverseMarkdown::Config
config.unknown_tags = :bypass
config.github_flavored = true
config.tag_border = ""
config.force_encoding = false
config.unknown_tags = "raise"

ReverseMarkdown.config do |c|
  c.unknown_tags = :drop
  c.github_flavored = false
  c.tag_border = " "
  c.force_encoding = true
  c.tag_border.upcase
end

# @type var tags: ReverseMarkdown::unknown_tags
tags = config.unknown_tags
tags.to_s
config.github_flavored ? 1 : 2
config.tag_border.upcase
config.force_encoding ? 1 : 2

result = config.with(github_flavored: true) { ReverseMarkdown.cleaner.tidy("**a** b") }
result.upcase
config.with { 1 }.succ
config.with(convert_options) { 1 }.succ

class QuoteConverter < ReverseMarkdown::Converters::Base
  def convert(node, state = {})
    inner = treat_children(node, state)
    "> #{escape_keychars(inner)}#{extract_title(node)}"
  end
end

class RawConverter < ReverseMarkdown::Converters::Base
  def convert(node, state = {})
    treat_children(node, state)
  end

  def treat(node, state)
    case node.name
    when "br"
      "\n"
    else
      super
    end
  end
end

converter = ReverseMarkdown::Converters.register(:quote, QuoteConverter.new)
converter.treat_children(Nokogiri::HTML::DocumentFragment.parse("<q>a</q>"), {}).upcase
ReverseMarkdown::Converters.register("raw", RawConverter.new)
ReverseMarkdown::Converters.lookup(:quote).convert(Nokogiri::HTML::DocumentFragment.parse("<q>a</q>")).upcase
ReverseMarkdown::Converters.lookup("raw").treat(Nokogiri::HTML::DocumentFragment.parse("<br>"), { ol_count: 1 }).upcase
ReverseMarkdown::Converters.unregister(:quote)&.escape_keychars("a_b")
ReverseMarkdown::Converters.unregister("raw")

begin
  ReverseMarkdown.convert("<foo></foo>", unknown_tags: :raise)
rescue ReverseMarkdown::UnknownTagError => e
  e.message.upcase
rescue ReverseMarkdown::InvalidConfigurationError => e
  e.message.upcase
rescue ReverseMarkdown::Error => e
  e.message.upcase
end
