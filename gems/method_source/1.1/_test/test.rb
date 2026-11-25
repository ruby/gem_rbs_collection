# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "method_source"

# A comment for Greeter
class Greeter
  # A comment for hello
  def hello
    :hello
  end
end

greeter = Greeter.new
greeter.method(:hello).source.display
greeter.method(:hello).comment.display
greeter.method(:hello).class_comment.display
greeter.method(:hello).module_comment.display
Greeter.instance_method(:hello).source.display
Greeter.instance_method(:hello).comment.display
Greeter.instance_method(:hello).class_comment.display

my_proc = proc { :proc }
my_proc.source.display
my_proc.comment.display
my_proc.class_comment.display
lambda { :lambda }.source.display

location = greeter.method(:hello).source_location
if location
  MethodSource.source_helper(location).display
  MethodSource.source_helper(location, :hello).display
  MethodSource.comment_helper(location).display
  MethodSource.comment_helper(location, "hello").display
  MethodSource.extract_code(location).display
end

begin
  method(:puts).source
rescue MethodSource::SourceNotFoundError => e
  e.message.display
end

lines = MethodSource.lines_for(__FILE__)
MethodSource.lines_for(__FILE__, :hello)
MethodSource.clear_cache

MethodSource.expression_at(lines, 9).display
MethodSource.expression_at(File.read(__FILE__), 9, { strict: true }).display
MethodSource.expression_at(lines, 9, strict: false, consume: 1).display
File.open(__FILE__) do |file|
  MethodSource.expression_at(file, 9).display
end
MethodSource.comment_describing(lines, 9).display
MethodSource.comment_describing(File.read(__FILE__), 9).display

MethodSource.complete_expression?("class Hello; end") # => true
MethodSource.valid_expression?("class Hello") # => false

# CodeHelpers can be used on its own.
class CodeReader
  include MethodSource::CodeHelpers
end

CodeReader.new.expression_at(["def a", "end"], 1).display
CodeReader.new.complete_expression?("def a")

MethodSource::VERSION.display
