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
