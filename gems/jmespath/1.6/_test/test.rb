# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "jmespath"
require "pathname"
require "stringio"

data = { "foo" => { "bar" => [1, 2, 3] } }

JMESPath.search("foo.bar[0]", data)
JMESPath.search("foo.bar", data, disable_visit_errors: true)
JMESPath.search("[0]", [1, 2, 3])
JMESPath.search("foo", StringIO.new('{"foo": 1}'))
JMESPath.search("foo", Pathname.new("data.json"))

JMESPath.load_json("data.json")
JMESPath.load_json(Pathname.new("data.json"))

runtime = JMESPath::Runtime.new
runtime.search("foo.bar", data)
JMESPath::Runtime.new(cache_expressions: false).parser.parse("foo.bar")
JMESPath::Runtime.new(parser: JMESPath::Parser.new).search("foo", data)
JMESPath::Runtime.new(parser: JMESPath::CachingParser.new).search("foo", data)

JMESPath::VERSION.upcase

begin
  JMESPath.search("foo[", data)
rescue JMESPath::Errors::SyntaxError => e
  e.message
rescue JMESPath::Errors::Error => e
  e.message
end

[
  JMESPath::Errors::RuntimeError,
  JMESPath::Errors::InvalidTypeError,
  JMESPath::Errors::InvalidValueError,
  JMESPath::Errors::InvalidArityError,
  JMESPath::Errors::UnknownFunctionError
].each { |klass| klass.new("message") }
