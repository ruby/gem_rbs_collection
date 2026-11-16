require "sanitize"
require "nokogiri"

# Class-level helpers with and without a config
html = "<b>bold</b><script>alert(1)</script>"
# @type var cleaned: String
cleaned = Sanitize.fragment(html)
cleaned = Sanitize.fragment(html, Sanitize::Config::RELAXED)
cleaned = Sanitize.fragment(nil, Sanitize::Config::BASIC)
cleaned = Sanitize.fragment(html, elements: %w[b], remove_contents: true)
cleaned = Sanitize.clean(html, Sanitize::Config::RESTRICTED)
cleaned = Sanitize.document("<html><body>x</body></html>", Sanitize::Config::RELAXED)
cleaned.strip

# Instance API
sanitizer = Sanitize.new(Sanitize::Config::BASIC)
cleaned = sanitizer.fragment(html)
cleaned = sanitizer.document("<html><body>x</body></html>")
cleaned = sanitizer.clean(html)
sanitizer.config[:elements]
Sanitize.new.fragment(html).strip

# Sanitizing a parsed node in place
fragment = Nokogiri::HTML::DocumentFragment.parse("<p onclick='x()'>hi</p>")
# @type var same_fragment: Nokogiri::HTML::DocumentFragment
same_fragment = Sanitize.node!(fragment, Sanitize::Config::BASIC)
same_fragment = sanitizer.node!(fragment)
same_fragment.to_html

# Config constants
Sanitize::Config::RESTRICTED[:elements].include?("b")
Sanitize::Config::BASIC[:attributes]["a"].include?("href")
Sanitize::Config::BASIC[:add_attributes]["a"]["rel"].upcase
Sanitize::Config::BASIC[:protocols]["a"]["href"].size
Sanitize::Config::RELAXED[:elements].size
Sanitize::Config::RELAXED[:attributes]["img"].size
Sanitize::Config::RELAXED[:attributes]["a"].include?("href")
Sanitize::Config::RELAXED[:attributes][:all].size
Sanitize::Config::RELAXED[:css][:properties].size
Sanitize::Config::RELAXED[:css][:allow_comments]
Sanitize::Config::RELAXED[:allow_doctype]
Sanitize::Config::DEFAULT[:remove_contents].size
Sanitize::Config::DEFAULT[:whitespace_elements]["p"][:before].strip
Sanitize::Config::DEFAULT[:transformers].size
Sanitize::Config::RESTRICTED[:transformers]&.size
Sanitize::Config::BASIC[:transformers]&.size

# Building a custom config on top of a bundled one
custom = Sanitize::Config.merge(
  Sanitize::Config::RELAXED,
  elements: Sanitize::Config::RELAXED[:elements] - %w[hgroup title],
  attributes: Sanitize::Config.merge(
    Sanitize::Config::RELAXED[:attributes],
    "td" => Sanitize::Config::RELAXED[:attributes]["td"] + ["nowrap"],
    "section" => [:data]
  ),
  css: { properties: Sanitize::Config::RELAXED[:css][:properties] + %w[--accent-color] }
)
custom = Sanitize::Config.merge(custom)
frozen = Sanitize::Config.freeze_config(custom)
Sanitize.fragment("<p>x</p>", frozen).strip

Sanitize::Config.freeze_config(Sanitize::Config::BASIC)[:elements].size

# Transformers
class_filter = lambda do |env|
  # @type var env: Sanitize::transformer_env
  node = env[:node]
  next unless env[:node_name] == "a"

  node["rel"] = "nofollow"
  node.remove_attribute("target")
  node["href"] ||= "#"
  env[:config][:elements]
  nil
end

allowlisting = ->(env) do
  # @type var env: Sanitize::transformer_env
  node = env[:node]
  return if env[:is_allowlisted]
  return unless node.element?
  return unless env[:node_name] == "video"
  # @type var src: String
  src = node["src"].to_s
  return unless %r{\Ahttps://media\.example\.org/}.match?(src)

  Sanitize.node!(node, elements: %w[video], attributes: { "video" => %w[src controls] })
  env[:node_allowlist].include?(node)
  { node_allowlist: [node] }
end

# @type var typed_transformer: Sanitize::transformer
typed_transformer = ->(env) { env[:node].remove if env[:node_name] == "script" }
untyped_proc = proc { |env| env }

Sanitize.fragment(html, transformers: class_filter)
Sanitize.fragment(html, transformers: [class_filter, allowlisting, typed_transformer, untyped_proc])
Sanitize.fragment(html, Sanitize::Config.merge(Sanitize::Config::BASIC, transformers: [allowlisting]))
# @type var relaxed_transformers: Array[Sanitize::transformer]
relaxed_transformers = (Sanitize::Config::RELAXED[:transformers] || []) + [typed_transformer]
Sanitize.fragment(html, transformers: relaxed_transformers)

# Errors and constants
begin
  Sanitize.node!(Nokogiri::HTML::Document.parse("<p>x</p>"), elements: %w[p])
rescue Sanitize::Error => e
  e.message.strip
end
Sanitize::VERSION.strip
Sanitize::REGEX_PROTOCOL.match("http://example.com")

# Standalone CSS sanitizing
css_config = { css: { properties: %w[color], protocols: %w[http https] } }
Sanitize::CSS.properties("color: red; position: fixed", css_config).strip
Sanitize::CSS.properties("color: red").strip
Sanitize::CSS.stylesheet("a { color: red }", css_config).strip
Sanitize::CSS.stylesheet("a { color: red }").strip

css = Sanitize::CSS.new(css_config)
css.config[:properties]
css.properties("color: red").strip
css.stylesheet("a { color: red }").strip
# @type var tree: Array[Hash[Symbol, untyped]]
tree = []
css.tree!(tree).size
Sanitize::CSS.tree!(tree, css_config).size
