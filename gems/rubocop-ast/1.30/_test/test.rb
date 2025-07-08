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

node&.type?
# tests for *_type?
node&.true_type?
node&.false_type?
node&.nil_type?
node&.int_type?
node&.float_type?
node&.str_type?
node&.dstr_type?
node&.sym_type?
node&.dsym_type?
node&.xstr_type?
node&.regopt_type?
node&.regexp_type?
node&.array_type?
node&.splat_type?
node&.pair_type?
node&.kwsplat_type?
node&.hash_type?
node&.irange_type?
node&.erange_type?
node&.self_type?
node&.lvar_type?
node&.ivar_type?
node&.cvar_type?
node&.gvar_type?
node&.const_type?
node&.defined_type?
node&.lvasgn_type?
node&.ivasgn_type?
node&.cvasgn_type?
node&.gvasgn_type?
node&.casgn_type?
node&.mlhs_type?
node&.masgn_type?
node&.op_asgn_type?
node&.and_asgn_type?
node&.ensure_type?
node&.rescue_type?
node&.arg_expr_type?
node&.or_asgn_type?
node&.back_ref_type?
node&.nth_ref_type?
node&.match_with_lvasgn_type?
node&.match_current_line_type?
node&.module_type?
node&.class_type?
node&.sclass_type?
node&.def_type?
node&.defs_type?
node&.undef_type?
node&.alias_type?
node&.args_type?
node&.cbase_type?
node&.arg_type?
node&.optarg_type?
node&.restarg_type?
node&.blockarg_type?
node&.block_pass_type?
node&.kwarg_type?
node&.kwoptarg_type?
node&.kwrestarg_type?
node&.kwnilarg_type?
node&.csend_type?
node&.super_type?
node&.zsuper_type?
node&.yield_type?
node&.block_type?
node&.and_type?
node&.not_type?
node&.or_type?
node&.if_type?
node&.when_type?
node&.case_type?
node&.while_type?
node&.until_type?
node&.while_post_type?
node&.until_post_type?
node&.for_type?
node&.break_type?
node&.next_type?
node&.redo_type?
node&.return_type?
node&.resbody_type?
node&.kwbegin_type?
node&.begin_type?
node&.retry_type?
node&.preexe_type?
node&.postexe_type?
node&.iflipflop_type?
node&.eflipflop_type?
node&.shadowarg_type?
node&.complex_type?
node&.rational_type?
node&.__FILE___type?
node&.__LINE___type?
node&.__ENCODING___type?
node&.ident_type?
node&.lambda_type?
node&.indexasgn_type?
node&.index_type?
node&.procarg0_type?
node&.restarg_expr_type?
node&.blockarg_expr_type?
node&.objc_kwarg_type?
node&.objc_restarg_type?
node&.objc_varargs_type?
node&.numargs_type?
node&.numblock_type?
node&.forward_args_type?
node&.forwarded_args_type?
node&.forward_arg_type?
node&.case_match_type?
node&.in_match_type?
node&.in_pattern_type?
node&.match_var_type?
node&.pin_type?
node&.match_alt_type?
node&.match_as_type?
node&.match_rest_type?
node&.array_pattern_type?
node&.match_with_trailing_comma_type?
node&.array_pattern_with_tail_type?
node&.hash_pattern_type?
node&.const_pattern_type?
node&.if_guard_type?
node&.unless_guard_type?
node&.match_nil_pattern_type?
node&.empty_else_type?
node&.find_pattern_type?
node&.kwargs_type?
node&.match_pattern_p_type?
node&.match_pattern_type?
node&.forwarded_restarg_type?
node&.forwarded_kwrestarg_type?
node&.itarg_type?
node&.itblock_type?

node&.parent
node&.each_ancestor { |node| node.send_type? }
node&.each_ancestor(:send) { |node| node.send_type? }
node&.each_ancestor&.each { |node| node.send_type? }&.send_type?
node&.each_ancestor(:send)&.each { |node| node.send_type? }&.send_type?
node&.source_range
node&.sibling_index
node&.right_sibling
node&.left_sibling
node&.left_siblings
node&.right_siblings

node&.each_child_node { |node| node.send_type? }
node&.each_child_node(:send) { |node| node.send_type? }
node&.each_child_node&.each { |node| node.send_type? }
node&.each_child_node(:send)&.each { |node| node.send_type? }
node&.child_nodes
node&.each_descendant { |node| node.send_type? }
node&.each_descendant(:send) { |node| node.send_type? }
node&.each_descendant&.each { |node| node.send_type? }
node&.each_descendant(:send)&.each { |node| node.send_type? }
node&.each_node { |node| node.send_type? }
node&.each_node(:send) { |node| node.send_type? }
node&.each_node&.each { |node| node.send_type? }
node&.each_node(:send)&.each { |node| node.send_type? }

def_node = RuboCop::AST::ProcessedSource.new('def hoge(a, b); end', RUBY_VERSION.to_f).ast
if def_node.is_a?(RuboCop::AST::DefNode)
  def_node.first_argument
  def_node.parenthesized?
  def_node.last_argument
  def_node.arguments?
  def_node.splat_argument?
  def_node.rest_argument?
  def_node.block_argument?
end

send_node = RuboCop::AST::ProcessedSource.new('1 + 2', RUBY_VERSION.to_f).ast
if send_node.is_a?(RuboCop::AST::SendNode)
  send_node.first_argument
  send_node.arguments
  send_node.receiver
  send_node.method_name
  send_node.selector
  send_node.block_node
  send_node.macro?
  send_node.access_modifier?
  send_node.bare_access_modifier?
  send_node.non_bare_access_modifier?
  send_node.special_modifier?
  send_node.command?(:a)
  send_node.setter_method?
  send_node.assignment?
  send_node.dot?
  send_node.double_colon?
  send_node.safe_navigation?
  send_node.self_receiver?
  send_node.const_receiver?
  send_node.implicit_call?
  send_node.block_literal?
  send_node.arithmetic_operation?
  send_node.def_modifier?
  send_node.def_modifier
  send_node.lambda?
  send_node.lambda_literal?
  send_node.unary_operation?
  send_node.binary_operation?
end

array_node = RuboCop::AST::ProcessedSource.new('[1,2,3]', RUBY_VERSION.to_f).ast
if array_node.is_a?(RuboCop::AST::ArrayNode)
  array_node.values
  array_node.each_value { |node| node }
  array_node.each_value.each {}
  array_node.square_brackets?
  array_node.percent_literal?
  array_node.bracketed?
end

block_node = RuboCop::AST::ProcessedSource.new('1.tap { |n| n }', RUBY_VERSION.to_f).ast
block_node.send_node.method?(:tap) if block_node.is_a?(RuboCop::AST::BlockNode)

str_node = RuboCop::AST::ProcessedSource.new('"str"', RUBY_VERSION.to_f).ast
str_node.value if str_node.is_a?(RuboCop::AST::StrNode)

dstr_node = RuboCop::AST::ProcessedSource.new('"dstr#{123}dstr"', RUBY_VERSION.to_f).ast
dstr_node.value if dstr_node.is_a?(RuboCop::AST::DstrNode)

sym_node = RuboCop::AST::ProcessedSource.new(':sym', RUBY_VERSION.to_f).ast
sym_node.value if sym_node.is_a?(RuboCop::AST::SymbolNode)

regexp_node = RuboCop::AST::ProcessedSource.new('/abc/', RUBY_VERSION.to_f).ast
regexp_node.to_regexp if regexp_node.is_a?(RuboCop::AST::RegexpNode)
