# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rubocop-ast"

class MyRule < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def on_sym(node)
    puts "I found a symbol! #{node.value}"
  end

  def on_if(node)
    node.if?
    node.if_branch
    node.else_branch
    node.elsif_conditional?
    node.if?
    node.unless?
    node.elsif?
    node.else?
    node.ternary?
    node.keyword
    node.inverse_keyword
    node.modifier_form?
    node.nested_conditional?
    node.elsif_conditional?
    node.if_branch
    node.else_branch
    node.node_parts
    node.branches
  end

  def on_hash(node)
    node.pairs
    node.empty?
    node.each_pair {|k, v| puts "#{k}#{v}" }
    node.each_pair
    node.keys
    node.each_key {|n| n }
    node.each_key
    node.values
    node.each_value {|n| n }
    node.each_value
    node.pairs_on_same_line?
    node.mixed_delimiters?
    node.braces?
  end
end

code = File.read(__FILE__)
source = RuboCop::AST::ProcessedSource.new(code, 2.7)
rule = MyRule.new
ast = source.ast
exit if ast.nil?
ast.each_node { |n| rule.process(n) }
ast.each_node(:sym) { |n| rule.process(n) }
ast.each_node(:sym, :if) { |n| rule.process(n) }
ast.each_node.each {}.each_node

{ this_is: :hash }

code = '!something.empty?'
source = RuboCop::AST::ProcessedSource.new(code, RUBY_VERSION.to_f)
node = source.ast
RuboCop::AST::NodePattern.new('send').match(node)
