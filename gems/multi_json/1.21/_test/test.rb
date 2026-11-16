require "multi_json"
require "stringio"

MultiJSON.adapter = :json_gem
MultiJSON.use(MultiJSON::Adapters::JsonGem)
# @type var current: Module
current = MultiJSON.adapter
current.name

# @type var default_name: Symbol
default_name = MultiJSON.default_adapter
default_name.to_s

MultiJSON.current_adapter(nil).name
MultiJSON.current_adapter.name

# @type var json: String
json = MultiJSON.generate({"foo" => "bar"})
json = MultiJSON.generate({foo: "bar"}, pretty: true)
json = MultiJSON.generate([1, 2], adapter: :json_gem)

# @type var parsed: untyped
parsed = MultiJSON.parse(json)
parsed = MultiJSON.parse(json, symbolize_names: true)
parsed = MultiJSON.parse(nil)

# @type var block_result: Integer
block_result = MultiJSON.with_adapter(:json_gem) { MultiJSON.generate({}).size }

# @type var parse_opts: Hash[Symbol, untyped]
parse_opts = MultiJSON.parse_options
parse_opts = MultiJSON.generate_options
MultiJSON.parse_options = {symbolize_names: true}
MultiJSON.generate_options = {mode: :compat}
MultiJSON.parse_options = -> { {symbolize_names: true} }
MultiJSON.generate_options = proc { |_| {} }

parse_opts = MultiJSON.load_options
parse_opts = MultiJSON.dump_options
MultiJSON.load_options = {}
MultiJSON.dump_options = {}

# @type var old_json: String
old_json = MultiJSON.dump({a: 1})
old_json = MultiJSON.encode({a: 1})
parsed = MultiJSON.load(old_json, symbolize_keys: true)
parsed = MultiJSON.decode(old_json)

# @type var version: String
version = MultiJSON::VERSION
version.size

begin
  MultiJSON.parse("{")
rescue MultiJSON::ParseError => e
  # @type var data: untyped
  data = e.data
  # @type var line: Integer?
  line = e.line
  # @type var column: Integer?
  column = e.column
  e.message.size
end

begin
  MultiJSON.parse("{")
rescue MultiJSON::DecodeError, MultiJSON::LoadError => e
  e.message.size
end

begin
  MultiJSON.use(:unknown)
rescue MultiJSON::AdapterError => e
  e.message.size
end

class MyAdapter < MultiJSON::Adapter
  defaults :load, symbolize_names: true
  defaults :dump, pretty: true
end
MyAdapter.parse_options

MultiJSON::Adapters::JsonGem.load("[]")
MultiJSON::Adapters::JsonGem.dump([]).size

MultiJSON::Adapters::JsonGem::ParseError.new.message

# Legacy constant
MultiJson.use(:json_gem)
MultiJson.adapter.name
MultiJson.current_adapter.name
MultiJson.default_adapter.to_s
json = MultiJson.dump({"a" => 1})
json = MultiJson.dump(html_content: "x", text_content: "y")
json = MultiJson.encode([])
json = MultiJson.generate([])
parsed = MultiJson.load(json, symbolize_keys: true)
parsed = MultiJson.load(StringIO.new(json))
parsed = MultiJson.decode(json)
parsed = MultiJson.parse(json)
MultiJson.parse_options = {}
MultiJson.generate_options = {}
MultiJson.load_options = {}
MultiJson.dump_options = {}
MultiJson.load_options.size
MultiJson.dump_options.size

begin
  MultiJson.load("{")
rescue MultiJson::LoadError, MultiJson::ParseError, MultiJson::DecodeError => e
  e.data
  e.line
  e.column
end

begin
  MultiJson.use(:unknown)
rescue MultiJson::AdapterError => e
  e.message.size
end

# These adapters need gems that are not dependencies of multi_json (oj, yajl,
# fast_jsonparser) or a concrete adapter implementation, so they are only
# defined here.
# @type var use_optional_adapters: ^() -> void
use_optional_adapters = lambda do
  MultiJSON.use(:oj)
  MultiJSON.current_adapter(adapter: :oj).name
  MultiJSON.parse(StringIO.new("{}"), adapter: :oj)
  # @type var block_result: Integer
  block_result = MultiJSON.with_adapter(MultiJSON::Adapters::Oj) { 1 }
  block_result.succ
  MyAdapter.load("{}", symbolize_names: true)
  MyAdapter.dump({"a" => 1}, pretty: true).size
  MultiJSON::Adapters::Oj.load("[]", symbolize_names: true)
  MultiJSON::Adapters::Oj.dump({}, mode: :compat).size
  MultiJSON::Adapters::Yajl.dump([]).size
  MultiJSON::Adapters::FastJsonparser.load("[]")
  MultiJSON::Adapters::Oj::ParseError.new.message
  MultiJson.adapter = :oj
  MultiJson.with_adapter(:oj) { MultiJson.load("{}") }
  raise MultiJSON::ParseError.new("bad", data: "{", cause: nil)
end
