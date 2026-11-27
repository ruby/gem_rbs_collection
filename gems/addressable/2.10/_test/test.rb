require "addressable/uri"

uri = Addressable::URI.parse("http://example.com/path/to/resource/")
uri.scheme
#=> "http"
uri.host
#=> "example.com"
uri.path
#=> "/path/to/resource/"

uri = Addressable::URI.parse("http://www.詹姆斯.com/")
uri.normalize
#=> #<Addressable::URI:0xc9a4c8 URI:http://www.xn--8ws00zhy3a.com/>

require "addressable/template"

template = Addressable::Template.new("http://example.com/{?query*}")
template.expand({
  "query" => {
    'foo' => 'bar',
    'color' => 'red'
  }
})
#=> #<Addressable::URI:0xc9d95c URI:http://example.com/?foo=bar&color=red>

template = Addressable::Template.new("http://example.com/{?one,two,three}")
template.partial_expand({"one" => "1", "three" => 3}).pattern
#=> "http://example.com/?one=1{&two}&three=3"

template = Addressable::Template.new(
  "http://{host}{/segments*}/{?one,two,bogus}{#fragment}"
)
uri = Addressable::URI.parse(
  "http://example.com/a/b/c/?one=1&two=2#foo"
)
template.extract(uri)
#=>
# {
#   "host" => "example.com",
#   "segments" => ["a", "b", "c"],
#   "one" => "1",
#   "two" => "2",
#   "fragment" => "foo"
# }

uri = Addressable::URI.parse("http://example.com/a/b/c")
uri.query_values # => nil
uri.query_values = {"one" => "1", "two" => "2"}
uri.query_values # => {"one" => "1", "two" => "2"}
uri.query_values = ["three", "four"]
uri.query_values # => {"three" => nil, "four" => nil}
uri.query_values = [["five", "5"], ["six", "6"]]
uri.query_values # => {"five" => "5", "six" => "6"}
uri.query_values = [["seven"], ["andup", ["8", "9", "10"]]]
uri.query_values # => {"seven"=> nil, "andup"=>"10"}
uri.query_values = [["seven", "7"], ["andup", ["8", "9", "10"]]]
uri.query_values # => {"seven"=>"7", "andup"=>"10"}
uri.query_values = nil
uri.query_values # => nil

uri = Addressable::URI.parse("http://example.com/go?a=b&c=d")
uri.omit(:query).to_s # => "http://example.com/go"
uri.omit(:scheme, :path, :query).to_s # => "example.com"

uri = Addressable::URI.parse("http://example.com/go?a=b&c=d")
uri.omit!(:query)
uri.to_s # => "http://example.com"
uri.omit!(:scheme, :path)
uri.to_s # => "example.com"

# Parsing
# @type var parsed: Addressable::URI
parsed = Addressable::URI.parse("https://user:pass@example.com:8443/a/b.html?x=1&y#top")
# @type var nothing: nil
nothing = Addressable::URI.parse(nil)
# @type var maybe: Addressable::URI?
maybe = Addressable::URI.parse(ENV["ADDRESSABLE_TEST_URI"])
# @type var from_stdlib: Addressable::URI
from_stdlib = Addressable::URI.parse(URI("http://example.com/"))
# @type var heuristic: Addressable::URI
heuristic = Addressable::URI.heuristic_parse("example.com/path", { scheme: "https" })
# @type var file_uri: Addressable::URI
file_uri = Addressable::URI.convert_path("/tmp/file.txt")
# @type var joined: Addressable::URI
joined = Addressable::URI.join("http://example.com/", "a/", parsed)
# @type var joined_none: nil
joined_none = Addressable::URI.join
# @type var built: Addressable::URI
built = Addressable::URI.new(scheme: "http", host: "example.com", port: 8080, path: "/p", query_values: { "a" => "1" })
options = { scheme: "http", host: "example.com" }
built = Addressable::URI.new(options)

# Components
# @type var scheme: String?
scheme = parsed.scheme
# @type var user: String?
user = parsed.user
# @type var password: String?
password = parsed.password
# @type var userinfo: String?
userinfo = parsed.userinfo
# @type var host: String?
host = parsed.host
# @type var hostname: String?
hostname = parsed.hostname
# @type var port: Integer?
port = parsed.port
# @type var inferred_port: Integer?
inferred_port = parsed.inferred_port
# @type var authority: String?
authority = parsed.authority
# @type var path: String
path = parsed.path
# @type var query: String?
query = parsed.query
# @type var fragment: String?
fragment = parsed.fragment
# @type var site: String?
site = parsed.site
# @type var origin: String
origin = parsed.origin
# @type var request_uri: String?
request_uri = parsed.request_uri
# @type var basename: String
basename = parsed.basename
# @type var extname: String?
extname = parsed.extname
# @type var tld: String
tld = parsed.tld
# @type var domain: String?
domain = parsed.domain
# @type var normalized_host: String?
normalized_host = parsed.normalized_host
# @type var normalized_path: String
normalized_path = parsed.normalized_path
# @type var normalized_query: String?
normalized_query = parsed.normalized_query(:sorted)
# @type var normalized_port: Integer?
normalized_port = parsed.normalized_port

# Query values
# @type var values: Hash[String, String?]?
values = parsed.query_values
# @type var pairs: Array[Array[String]]?
pairs = parsed.query_values(Array)
parsed.query_values = { "a" => "1", b: ["2", "3"], c: nil }

# Setters
# @type var copy: Addressable::URI
copy = parsed.dup
copy.scheme = "http"
copy.user = nil
copy.password = nil
copy.host = "example.org"
copy.hostname = "127.0.0.1"
copy.port = "8080"
copy.port = nil
copy.path = "/new"
copy.query = "q=1"
copy.fragment = nil
copy.authority = "example.net:81"
copy.site = "https://example.org"
copy.origin = "https://example.org:444"
copy.request_uri = "/x?y=z"
copy.userinfo = "u:p"
copy.tld = "net"
copy.defer_validation do
  copy.host = nil
  copy.path = "relative"
end

# Joining, routing and normalization
# @type var plus: Addressable::URI
plus = parsed + "c"
# @type var merged: Addressable::URI
merged = parsed.merge(scheme: "http", port: nil)
# @type var route: Addressable::URI
route = parsed.route_to("https://user:pass@example.com:8443/a/c.html")
# @type var route_back: Addressable::URI
route_back = route.route_from(parsed)
# @type var normalized: Addressable::URI
normalized = parsed.normalize
# @type var display: Addressable::URI
display = parsed.display_uri
# @type var same: bool
same = parsed == normalized
# @type var hash: Integer
hash = parsed.hash
# @type var string: String
string = parsed.to_s
# @type var components: Hash[Symbol, String | Integer | nil]
components = parsed.to_hash
# @type var absolute: bool
absolute = parsed.absolute?

# Encoding
# @type var encoded: String
encoded = Addressable::URI.encode_component("a b", Addressable::URI::CharacterClasses::UNRESERVED)
# @type var encoded_nil: nil
encoded_nil = Addressable::URI.encode_component(nil)
# @type var decoded: String
decoded = Addressable::URI.unencode_component("a%20b")
# @type var decoded_uri: Addressable::URI
decoded_uri = Addressable::URI.unencode("http://example.com/a%20b", Addressable::URI)
# @type var encoded_uri: String
encoded_uri = Addressable::URI.encode("http://example.com/a b")
# @type var normalized_uri: Addressable::URI
normalized_uri = Addressable::URI.normalized_encode("http://example.com/a b", Addressable::URI)
# @type var component: String
component = Addressable::URI.normalize_component("a%2fb", "a-z", "/")
# @type var form: String
form = Addressable::URI.form_encode({ "a" => "1", "b" => ["2", "3"] }, true)
# @type var unform: Array[[String?, String?]]
unform = Addressable::URI.form_unencode("a=1&b=2")

# IDNA
# @type var ascii: String
ascii = Addressable::IDNA.to_ascii("www.詹姆斯.com")
# @type var unicode: String
unicode = Addressable::IDNA.to_unicode("www.xn--8ws00zhy3a.com")

# Templates
template = Addressable::Template.new("http://example.com/{id}{?q}")
# @type var expanded: Addressable::URI
expanded = template.expand { |name| name == "id" ? 1 : nil }
# @type var partial: Addressable::Template
partial = template.partial_expand({ id: 1 })
# @type var extracted: Hash[String, untyped]?
extracted = template.extract("http://example.com/1?q=x")
# @type var match: Addressable::Template::MatchData?
match = template.match("http://example.com/1?q=x")
if match
  # @type var variables: Array[String]
  variables = match.variables
  # @type var match_uri: Addressable::URI
  match_uri = match.uri
  # @type var captures: Array[untyped]
  captures = match.captures
  match["id"]
  match[1, 2]
end
# @type var regexp: Regexp
regexp = template.to_regexp
# @type var names: Array[String]
names = template.keys

pairs = Addressable::URI.parse("http://example.com/?a=1&b").query_values(Array)
copy = Addressable::URI.parse("http://example.com/")
copy.query_values = pairs
copy.query_values = Addressable::URI.parse("http://example.com/?x=1").query_values
Addressable::URI.form_encode(pairs || [])
