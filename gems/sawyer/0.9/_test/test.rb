require "sawyer"
require "json"

class LinksInBody
  def parse(data)
    links = data.delete(:links)
    [data, links]
  end
end

# @type var version: String
version = Sawyer::VERSION

# @type var serializer: Sawyer::Serializer
serializer = Sawyer::Agent.serializer
Sawyer::Agent.serializer = Sawyer::Serializer.any_json
# @type var encoded: String
encoded = Sawyer::Agent.encode({ a: 1, created_at: Time.now })
Sawyer::Agent.decode(encoded)
Sawyer::Agent.decode(nil)

agent = Sawyer::Agent.new("https://api.example.com/") do |conn|
  conn.headers["User-Agent"] = "sawyer"
end
Sawyer::Agent.new("https://api.example.com/", links_parser: Sawyer::LinkParsers::Simple.new, allow_undefined_methods: true)
agent.links_parser = LinksInBody.new
agent.links_parser = Sawyer::LinkParsers::Hal.new
agent.allow_undefined_methods = true
# @type var allowed: bool
allowed = agent.allow_undefined_methods?

# @type var response: Sawyer::Response
response = agent.call(:get, "users/{id}", uri: { id: 1 }, headers: { "Accept" => "application/json" })
response = agent.call(:post, Addressable::Template.new("users"), { name: "a" }, query: { page: 1 })
response = agent.start
response = agent.root
# @type var root_rels: Sawyer::Relation::Map
root_rels = agent.rels
# @type var url: String
url = agent.expand_url("users{/id}", { id: 1 })
# @type var body: String
body = agent.encode_body({ a: 1 })
agent.decode_body(body)
# @type var parsed: [Hash[Symbol, untyped], untyped]
parsed = agent.parse_links({ a: 1, _links: { self: { href: "/" } } })
agent.close

# @type var status: Integer
status = response.status
# @type var content_type: untyped
content_type = response.headers["Content-Type"]
# @type var http_method: Symbol
http_method = response.env.method
# @type var link_rels: Hash[Symbol, Sawyer::Relation]
link_rels = response.rels
response.data
response.body
# @type var timing: Float
timing = response.timing
# @type var time: Time?
time = response.time

resource = Sawyer::Resource.new(agent, { login: "octocat", _links: { self: { href: "/users/octocat" } } })
# @type var attrs: Hash[Symbol, untyped]
attrs = resource.attrs
# @type var fields: Set[Symbol]
fields = resource._fields
# @type var resource_rels: Sawyer::Relation::Map
resource_rels = resource._rels
# @type var has_login: bool
has_login = resource.key?(:login)
resource[:login]
resource["login"] = "hubot"
resource.dig(:login)
resource.fetch(:login)
resource.fetch(:missing, nil)
resource.fetch(:missing) { |key| key.to_s }
resource.each { |key, value| puts "#{key}: #{value}" }
# @type var keys: Array[Symbol]
keys = resource.map { |key, _value| key }
# @type var hash: Hash[Symbol, untyped]
hash = resource.to_h
Sawyer::Resource.attr_accessor(:login, "name")

# @type var rel: Sawyer::Relation?
rel = Sawyer::Relation.from_link(agent, :self, { href: "/users{/id}", method: "get,post" })
relation = Sawyer::Relation.new(agent, "user", "/users{/id}", :get)
# @type var href: String
href = relation.href(id: 1)
# @type var name: Symbol
name = relation.name
# @type var methods: Set[Symbol]
methods = relation.available_methods
# @type var template: Addressable::Template
template = relation.href_template
response = relation.get(headers: { "Accept" => "application/json" })
response = relation.post({ name: "a" })
response = relation.call(nil, method: :delete)

map = Sawyer::Relation.from_links(agent, { "self" => "/", "user" => { href: "/users/{id}" } })
map << relation
# @type var found: Sawyer::Relation?
found = map[:self]
# @type var size: Integer
size = map.size
# @type var hrefs: Hash[Symbol, String]
hrefs = map.to_h

# @type var custom: Sawyer::Serializer
custom = Sawyer::Serializer.new(JSON, :dump, :load)
# @type var dumped: String
dumped = custom.dump([1, 2])
custom.load(dumped)
