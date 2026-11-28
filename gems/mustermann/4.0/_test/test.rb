require "mustermann"
require "mustermann/rails"
require "mustermann/set"
require "mustermann/router"

class UpcaseCaster
  def cast(key, value)
    { key => String(value).upcase }
  end
end

# @type var pattern: Mustermann::Pattern
pattern = Mustermann.new("/:prefix/*.*")
# @type var matches: bool
matches = pattern === "/foo/bar.png"
# @type var position: Integer?
position = pattern =~ "/foo/bar.png"
# @type var names: Array[String]
names = pattern.names
names.each { |name| name.upcase }
pattern.to_s.upcase
# @type var templates: Array[String | Array[untyped]]
templates = pattern.to_templates
templates.flatten.size
# @type var peeked_string: String?
peeked_string = pattern.peek("/foo/bar.png")
peeked_string&.upcase
# @type var peek_size: Integer?
peek_size = pattern.peek_size("/foo/bar.png")
peek_size&.succ
# @type var peek_match: Mustermann::Match?
peek_match = pattern.peek_match("/foo/bar.png/baz")
peek_match&.post_match
# @type var pattern_hash: Integer
pattern_hash = pattern.hash
pattern_hash + 1
# @type var equal: bool
equal = pattern == Mustermann.new("/:prefix/*.*")
equal = pattern.eql?(Mustermann.new("/:prefix/*.*"))
pattern.inspect.upcase
# @type var proc: ^(String) -> bool
proc = pattern.to_proc
proc.call("/foo/bar.png")

if (params = pattern.params("/foo/bar.png"))
  params["prefix"]
end
# @type var no_params: Hash[String, untyped]?
no_params = pattern.params

# @type var match: Mustermann::Match?
match = pattern.match("/foo/bar.png")
if match
  match.params["prefix"]
  match[:prefix]
  match["splat"]
  match[0]
  # @type var capture_slice: Array[untyped]?
  capture_slice = match[0, 2]
  capture_slice = match[0..1]
  match.names.first
  match.to_s.upcase
  match.post_match.upcase
  match.pre_match.upcase
  match.string.upcase
  match.pattern.to_s
  match.to_h["prefix"]
  # @type var captures: Array[untyped]
  captures = match.captures
  # @type var named_captures: Hash[String, untyped]
  named_captures = match.named_captures
  # @type var match_regexp: Regexp?
  match_regexp = match.regexp
  # @type var values: Array[untyped]
  values = match.values_at(:prefix, "splat")
  # @type var deconstructed: Hash[String | Symbol, untyped]
  deconstructed = match.deconstruct_keys([:prefix])
  match.eql?(match)
  match == match
  match.hash
  match.inspect
  # @type var copy: Mustermann::Match
  copy = Mustermann::Match.new(match)
  copy = Mustermann::Match.new(pattern, "/foo/bar.png", params: { "prefix" => "foo" })
  if (match_data = /(?<prefix>\w+)/.match("foo"))
    copy = Mustermann::Match.new(pattern, match_data, params: { "prefix" => "foo" })
  end
  copy.to_s
end

if (peeked = Mustermann.new("/:prefix").peek_params("/foo/bar"))
  peek_params, size = peeked
  peek_params["prefix"]
  size + 1
end

case "/foo/bar.pdf"
when Mustermann.new("foo/*") then "prefixed with foo"
when Mustermann.new("*.pdf") then "a PDF"
end

expandable = Mustermann.new("/:file(.:ext)?")
# @type var expanded: String
expanded = expandable.expand(file: "pony")
expanded.upcase
expandable.expand(:append, file: "pony", value: "bar").upcase
expandable.expand(:raise, { file: "pony", "ext" => "jpg" }).upcase

# @type var combined: Mustermann::Pattern
combined = Mustermann.new("/foo/:input") | Mustermann.new("/:input/bar")
combined = combined & "/foo/bar"
combined = combined ^ "/foo/bar"
(Mustermann.new("/:prefix") + "/:suffix").to_s
Mustermann.new("/", "/*.jpg").to_s
Mustermann.new(%w[/foo /bar], operator: :&).to_s
Mustermann.new(:name, capture: :digit).to_s
%w[/foo /bar].select(&Mustermann.new("/:name"))

# @type var regular: Mustermann::Regular
regular = Mustermann.new(/\/(?<name>\w+)/)
# @type var regexp: Regexp
regexp = regular.regexp
regexp = regular.to_regexp
regexp.source

# @type var sinatra: Mustermann::Sinatra
sinatra = Mustermann::Sinatra.new("/:name", capture: { name: /\w+/ })
# @type var uri_decode: bool
uri_decode = sinatra.uri_decode
# @type var options: Hash[Symbol, untyped]
options = sinatra.options
options[:capture]
sinatra.safe_string.upcase
Mustermann::Sinatra.escape("/:name").upcase
# @type var converted: Mustermann::Sinatra?
converted = Mustermann::Sinatra.try_convert("/foo")
converted&.to_s
# @type var rails: Mustermann::Rails
rails = Mustermann::Rails.new("/:name(.:format)", version: "5")
rails.to_s
# @type var identity: Mustermann::Identity
identity = Mustermann::Identity.new("/foo")
identity.expand(:append, page: 1).upcase
# @type var pattern_class: singleton(Mustermann::Pattern)
pattern_class = Mustermann[:rails]
pattern_class.new("/:id").names
Mustermann::Regular.new(/foo/, check_anchors: false).to_s
# @type var supported_options: Array[Symbol]
supported_options = Mustermann::Sinatra.supported_options
# @type var supported: bool
supported = Mustermann::Sinatra.supported?(:capture)

# @type var composite: Mustermann::Composite
composite = Mustermann::Composite.new("/foo", "/bar", operator: :|)
composite.to_s
# @type var composite_patterns: Array[Mustermann::Pattern]
composite_patterns = composite.patterns
# @type var operator: Symbol
operator = composite.operator
# @type var composite_params: Hash[String, untyped]?
composite_params = composite.params("/foo")
# @type var single: Mustermann::Pattern
single = Mustermann::Composite.new(sinatra)
# @type var concat: Mustermann::Concat
concat = Mustermann::Concat.new("/:foo", "/:bar")
concat.params("/a/b")

# @type var expander: Mustermann::Expander
expander = Mustermann::Expander.new("/:slug", additional_values: :ignore)
expander << "/:slug/:page"
expander = expander.add(Mustermann.new("/{id}", type: :rails))
expander = expander.cast(:page) { |value| Integer(value) }
expander.cast(UpcaseCaster.new)
expander.expand(slug: "foo").upcase
expander.expand(:append, { slug: "foo", page: "2" }).upcase
# @type var expandable_values: bool
expandable_values = expander.expandable?(slug: "foo")
expander.patterns.map(&:to_s)
# @type var behavior: Mustermann::additional_values
behavior = expander.additional_values

# @type var set: Mustermann::Set
set = Mustermann::Set.new({ "/foo" => :foo, "/bar/:id" => :bar })
set = set.add("/baz", :baz)
set["/qux"] = :qux
set["/bar/1"]
# @type var set_match: Mustermann::Set::Match?
set_match = set.match("/bar/1")
if set_match
  set_match.value
  set_match.params["id"]
end
# @type var set_matches: Array[Mustermann::Set::Match]?
set_matches = set.match_all("/bar/1")
set_matches&.map(&:value)
set_matches = set.peek_match_all("/bar/1/more")
set_match = set.peek_match("/bar/1/more")
# @type var set_patterns: Array[Mustermann::Pattern]
set_patterns = set.patterns
set_patterns.map(&:to_s)
set.expand(:bar, id: 1).upcase
set.expand(id: 1).upcase
set.expand(:bar, :ignore, { id: 1, other: 2 }).upcase
set.expander(:bar).expand(id: 1)
# @type var has_value: bool?
has_value = set.has_value?(:foo)
set.optimize!
set = set.merge("/merged")
set = set.update({ "/updated" => :updated })
set.strict_order?
set.use_cache?
set.use_trie?

Mustermann::Set.new(type: :rails) { |s| s.add("/:id", :id) }
Mustermann::Set.new { { "/:id" => :id } }

router = Mustermann::Router.new do
  get("/") { |_env| [200, { "content-type" => "text/plain" }, ["Hello"]] }
  post "/:id", ->(_env) { [201, { "content-type" => "text/plain" }, ["Created"]] }
end
router.call({ "REQUEST_METHOD" => "GET", "PATH_INFO" => "/" })
show = ->(_env) { [200, { "content-type" => "text/plain" }, ["User"]] }
# @type var route_set: Mustermann::Set
route_set = router.route("GET", "/users/:id", show)
# @type var path: String
path = router.path_for(show, id: 42)
path = router.path_for(show, :append, { id: 42, page: 2 })
router.fallback { |_env| [404, { "content-type" => "text/plain" }, ["Missing"]] }

# @type var cache: Mustermann::EqualityMap
cache = Mustermann::EqualityMap.new
# @type var cached: String
cached = cache.fetch(["key"]) { "value" }

begin
  Mustermann.new("/:file(.:ext)?").expand(ext: "jpg")
rescue Mustermann::ExpandError => error
  error.message
end
Mustermann::Expander.new << Mustermann::Expander.new("/:x")
Mustermann::Composite.new(["/foo", "/bar"])
