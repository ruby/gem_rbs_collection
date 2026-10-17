# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "parser"
require "parser/current"

node = Parser::CurrentRuby.parse("2 + 2") or raise
node.loc
node.loc.node
node.loc.expression
node.loc.line
node.loc.first_line
node.loc.last_line
node.loc.column
node.loc.last_column

buffer = Parser::Source::Buffer.new(__FILE__)
buffer.name

node, comments = Parser::CurrentRuby.parse_with_comments(<<SOURCE)
# comment
2 + 2
SOURCE
node.location.node unless node.nil?
comments.first.text
range = comments.first.location.expression
range.source_buffer
range.begin_pos
range.end_pos
range.begin
range.end
range.size
range.length
range.line
range.first_line
range.column
range.last_line
range.last_column
range.column_range
range.source_line
range.source
range.with
range.with(begin_pos: 1, end_pos: 2)
range.adjust
range.adjust(begin_pos: 1, end_pos: 2)
range.resize(1)
range.join range
range.intersect range
range.disjoint? range
range.overlaps? range
range.contains? range
range.contained? range
range.crossing? range
range.empty?

node = Parser::CurrentRuby.parse("[1,2]") or raise
if node.loc.is_a? Parser::Source::Map::Collection
  node.loc.begin
  node.loc.end
end

node = Parser::CurrentRuby.parse("if true then 1 else 2 end") or raise
if node.loc.is_a? Parser::Source::Map::Condition
  node.loc.keyword
  node.loc.begin
  node.loc.else
  node.loc.end
end

node = Parser::CurrentRuby.parse("1.to_s") or raise
if node.loc.is_a? Parser::Source::Map::Send
  node.loc.dot
  node.loc.selector
  node.loc.operator
  node.loc.begin
  node.loc.end
end

parser = Parser::CurrentRuby.new
parser.version + 1
parser.diagnostics.all_errors_are_fatal = true
parser.diagnostics.ignore_warnings = true
parser.diagnostics.consumer = ->(diagnostic) { diagnostic.render.join("\n") }
source_buffer = Parser::Source::Buffer.new("(string)", source: "foo(1)")
parser.parse(source_buffer)&.type
ast, ast_comments = parser.parse_with_comments(source_buffer)
ast&.type
ast_comments.map(&:text)
Parser::CurrentRuby.parse("1", "(file)", 1)
Parser::CurrentRuby.parse_with_comments("1", "(file)", 1)

begin
  Parser::CurrentRuby.parse("foo(")
rescue Parser::SyntaxError => error
  error.diagnostic.level.to_s
  error.diagnostic.reason.to_s
  error.diagnostic.message.upcase
  error.diagnostic.location.source
  error.diagnostic.highlights.map(&:source)
  error.diagnostic.arguments.keys
rescue Parser::UnknownEncodingInMagicComment => error
  error.message
end
