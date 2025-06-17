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
