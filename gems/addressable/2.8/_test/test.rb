# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

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
