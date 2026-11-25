require "mustermann"
require "mustermann/rails"
require "mustermann/set"
require "mustermann/router"

class UpcaseCaster
  def cast(key, value)
    { key => String(value).upcase }
  end
end

pattern = Mustermann.new("/:prefix/*.*")
pattern === "/foo/bar.png"
pattern =~ "/foo/bar.png"
pattern.names.each { |name| name.upcase }
pattern.to_s.upcase
pattern.to_templates.map(&:upcase)
pattern.peek("/foo/bar.png")&.upcase
pattern.peek_size("/foo/bar.png")&.succ

if (params = pattern.params("/foo/bar.png"))
  params["prefix"]
end

if (match = pattern.match("/foo/bar.png"))
  match.params["prefix"]
  match[:prefix]
  match["splat"]
  match[0]
  match.names.first
  match.to_s.upcase
  match.post_match.upcase
  match.pre_match.upcase
  match.pattern.to_s
  match.to_h["prefix"]
  match.values_at(:prefix, "splat")
  match.deconstruct_keys([:prefix])
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
expandable.expand(file: "pony").upcase
expandable.expand(:append, file: "pony", value: "bar").upcase
expandable.expand(:raise, { file: "pony", "ext" => "jpg" }).upcase

combined = Mustermann.new("/foo/:input") | Mustermann.new("/:input/bar")
combined & "/foo/bar"
combined ^ "/foo/bar"
(Mustermann.new("/:prefix") + "/:suffix").to_s
Mustermann.new("/", "/*.jpg").to_s
Mustermann.new(%w[/foo /bar], operator: :&).to_s
Mustermann.new(:name, capture: :digit).to_s
%w[/foo /bar].select(&Mustermann.new("/:name"))

regular = Mustermann.new(/\/(?<name>\w+)/)
regular.regexp.source
regular.to_regexp.source

sinatra = Mustermann::Sinatra.new("/:name", capture: { name: /\w+/ })
sinatra.uri_decode
sinatra.options[:capture]
sinatra.safe_string.upcase
Mustermann::Sinatra.escape("/:name").upcase
Mustermann::Sinatra.try_convert("/foo")&.to_s
Mustermann::Rails.new("/:name(.:format)", version: "5").to_s
Mustermann::Identity.new("/foo").expand(:append, page: 1).upcase
Mustermann[:rails].new("/:id").names
Mustermann::Regular.new(/foo/, check_anchors: false).to_s

composite = Mustermann::Composite.new("/foo", "/bar", operator: :|)
composite.to_s

expander = Mustermann::Expander.new("/:slug", additional_values: :ignore)
expander << "/:slug/:page"
expander.add(Mustermann.new("/{id}", type: :rails))
expander.cast(:page) { |value| Integer(value) }
expander.cast(UpcaseCaster.new)
expander.expand(slug: "foo").upcase
expander.expandable?(slug: "foo")
expander.patterns.map(&:to_s)

set = Mustermann::Set.new({ "/foo" => :foo, "/bar/:id" => :bar })
set.add("/baz", :baz)
set["/qux"] = :qux
set["/bar/1"]
if (set_match = set.match("/bar/1"))
  set_match.value
  set_match.params["id"]
end
set.match_all("/bar/1")&.map(&:value)
set.patterns.map(&:to_s)
set.expand(:bar, id: 1).upcase
set.has_value?(:foo)
set.optimize!

Mustermann::Set.new(type: :rails) { |s| s.add("/:id", :id) }

router = Mustermann::Router.new do
  get("/") { |_env| [200, { "content-type" => "text/plain" }, ["Hello"]] }
  post "/:id", ->(_env) { [201, { "content-type" => "text/plain" }, ["Created"]] }
end
router.call({ "REQUEST_METHOD" => "GET", "PATH_INFO" => "/" })

begin
  Mustermann.new("/:file(.:ext)?").expand(ext: "jpg")
rescue Mustermann::ExpandError => error
  error.message
end
Mustermann::Expander.new << Mustermann::Expander.new("/:x")
