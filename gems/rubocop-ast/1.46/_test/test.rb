# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rubocop-ast"

class MyRule < Parser::AST::Processor
  include RuboCop::AST::Traversal

  def on_sym(node)
    node.value
  end

  def on_if(node)
    node.if?
    node.if_branch
    node.else_branch
    node.elsif_conditional?
    node.if?
    node.unless?
    node.then?
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
    if node.location.is_a?(Parser::Source::Map::Condition)
      node.location.keyword
      node.location.begin
      node.location.else
      node.location.end
    end
    if node.loc.is_a?(Parser::Source::Map::Condition)
      node.loc.keyword
      node.loc.begin
      node.loc.else
      node.loc.end
    end
    if node.location.is_a?(Parser::Source::Map::Keyword)
      node.location.keyword
      node.location.begin
      node.location.end
    end
    if node.loc.is_a?(Parser::Source::Map::Keyword)
      node.loc.keyword
      node.loc.begin
      node.loc.end
    end
    if node.location.is_a?(Parser::Source::Map::Ternary)
      node.location.question
      node.location.colon
    end
    if node.loc.is_a?(Parser::Source::Map::Ternary)
      node.loc.question
      node.loc.colon
    end
  end

  def on_hash(node)
    node.pairs
    node.empty?
    node.each_pair {|k, v| "#{k}#{v}" }
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
    return if node.pairs.size == 0
    pair = node.pairs.first
    pair.key
    pair.value
    pair.same_line?(pair)
    pair.key_delta(pair)
    pair.value_delta(pair)
    pair.delimiter_delta(pair)
    pair.hash_rocket?
    pair.colon?
    pair.delimiter
    pair.delimiter(with_spacing: true)
    pair.inverse_delimiter
    pair.inverse_delimiter(with_spacing: true)
    pair.value_on_new_line?
    pair.value_omission?
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
rand > 0.5 ? 1 : 2

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
node&.parent?
node&.root?
node&.to_a
node&.node_parts
node&.each_ancestor { |node| node.send_type? }
node&.each_ancestor(:send) { |node| node.send_type? }
node&.each_ancestor&.each { |node| node.send_type? }&.send_type?
node&.each_ancestor(:send)&.each { |node| node.send_type? }&.send_type?
node&.ancestors
node&.source
node&.source_range
node&.first_line
node&.last_line
node&.line_count
node&.nonempty_line_count
node&.source_length
node&.receiver
node&.str_content
node&.const_name
node&.defined_module
node&.defined_module_name
node&.parent_module_name
node&.multiline?
node&.single_line?
node&.empty_source?
node&.assignment_or_similar?
node&.literal?
node&.basic_literal?
node&.truthy_literal?
node&.falsey_literal?
node&.mutable_literal?
node&.immutable_literal?
node&.recursive_literal?
node&.recursive_basic_literal?
node&.variable?
node&.reference?
node&.equals_asgn?
node&.shorthand_asgn?
node&.assignment?
node&.basic_conditional?
node&.conditional?
node&.post_condition_loop?
node&.loop_keyword?
node&.keyword?
node&.special_keyword?
node&.operator_keyword?
node&.parenthesized_call?
node&.call_type?
node&.chained?
node&.argument?
node&.argument_type?
node&.boolean_type?
node&.numeric_type?
node&.range_type?
node&.guard_clause?
node&.match_guard_clause?
node&.proc?
node&.lambda?
node&.lambda_or_proc?
node&.global_const?('a')
node&.class_constructor?
node&.struct_constructor?
node&.class_definition?
node&.module_definition?
node&.value_used?
node&.pure?
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

alias_node = RuboCop::AST::ProcessedSource.new('alias :new :old', RUBY_VERSION.to_f).ast
if alias_node.is_a?(RuboCop::AST::AliasNode)
  alias_node.old_identifier
  alias_node.new_identifier
end

and_asgn_node = RuboCop::AST::ProcessedSource.new('a &&= 1', RUBY_VERSION.to_f).ast
if and_asgn_node.is_a?(RuboCop::AST::AndAsgnNode)
  and_asgn_node.operator
end

and_node = RuboCop::AST::ProcessedSource.new('1 and 2', RUBY_VERSION.to_f).ast
if and_node.is_a?(RuboCop::AST::AndNode)
  and_node.lhs
  and_node.rhs
  and_node.conditions
  and_node.operator
  and_node.logical_operator?
  and_node.semantic_operator?
  and_node.alternate_operator
  and_node.inverse_operator
end

def_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
def m(a, b, c)
end
EOM
if def_node.is_a?(RuboCop::AST::DefNode)
  args_node = def_node.arguments
  if args_node.is_a?(RuboCop::AST::ArgsNode)
    args_node.empty_and_without_delimiters?
    args_node.argument_list
    arg_node = args_node.child_nodes.first
    if arg_node.is_a?(RuboCop::AST::ArgNode)
      arg_node.name
      arg_node.default_value
      arg_node.default?
    end
  end
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

asgn_node = RuboCop::AST::ProcessedSource.new('x = 1', RUBY_VERSION.to_f).ast
if asgn_node.is_a?(RuboCop::AST::AsgnNode)
  asgn_node.name
  asgn_node.lhs
  asgn_node.expression
  asgn_node.rhs
end

block_node = RuboCop::AST::ProcessedSource.new('1.tap { |n| n }', RUBY_VERSION.to_f).ast
if block_node.is_a?(RuboCop::AST::BlockNode)
  block_node.send_node.method?(:tap)
  block_node.first_argument
  block_node.last_argument
  block_node.arguments
  block_node.argument_list
  block_node.body
  block_node.method_name
  block_node.arguments?
  block_node.braces?
  block_node.keywords?
  block_node.delimiters
  block_node.opening_delimiter
  block_node.closing_delimiter
  block_node.single_line?
  block_node.multiline?
  block_node.lambda?
  block_node.void_context?
end

break_node = RuboCop::AST::ProcessedSource.new('break 1, 2', RUBY_VERSION.to_f).ast
if break_node.is_a?(RuboCop::AST::BreakNode)
  break_node.arguments
end

_, case_match_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast&.child_nodes
config = {db: {user: 'admin', password: 'abc123'}}
case config
in db: {user:}
  puts "Connect with user " + user
in connection: {username: }
  puts "Connect with user " + username
else
  puts "Unrecognized structure of config"
end
EOM
if case_match_node.is_a?(RuboCop::AST::CaseMatchNode)
  case_match_node.single_line_condition?
  case_match_node.multiline_condition?
  case_match_node.condition
  case_match_node.body
  case_match_node.keyword
  case_match_node.in_pattern_branches
  case_match_node.branches
  case_match_node.else_branch
  case_match_node.else?
  in_pattern_node = case_match_node.in_pattern_branches.first
  if in_pattern_node.is_a?(RuboCop::AST::InPatternNode)
    in_pattern_node.pattern
    in_pattern_node.branch_index
    in_pattern_node.then?
    in_pattern_node.body
  end
end

case_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
case num
when 1
  :one
when 2
  :two
else
  :else
end
EOM
if case_node.is_a?(RuboCop::AST::CaseNode)
  case_node.single_line_condition?
  case_node.multiline_condition?
  case_node.condition
  case_node.body
  case_node.keyword
  case_node.when_branches
  case_node.branches
  case_node.else_branch
  case_node.else?
  when_node = case_node.when_branches.first
  if when_node.is_a?(RuboCop::AST::WhenNode)
    when_node.conditions
    when_node.branch_index
    when_node.then?
    when_node.body
  end
end

casgn_node = RuboCop::AST::ProcessedSource.new('::Foo::Bar::BAZ = 1', RUBY_VERSION.to_f).ast
if casgn_node.is_a?(RuboCop::AST::CasgnNode)
  casgn_node.namespace
  casgn_node.short_name
  casgn_node.module_name?
  casgn_node.class_name?
  casgn_node.absolute?
  casgn_node.relative?
  casgn_node.each_path
  casgn_node.each_path { |node| node }
  casgn_node.name
  casgn_node.lhs
  casgn_node.expression
  casgn_node.rhs
end

class_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
class Foo < Super
  def test
  end
end
EOM
if class_node.is_a?(RuboCop::AST::ClassNode)
  class_node.identifier
  class_node.parent_class
  class_node.body
end

const_node = RuboCop::AST::ProcessedSource.new('::Foo::Bar::BAZ', RUBY_VERSION.to_f).ast
if const_node.is_a?(RuboCop::AST::ConstNode)
  const_node.namespace
  const_node.short_name
  const_node.module_name?
  const_node.class_name?
  const_node.absolute?
  const_node.relative?
  const_node.each_path { |node| node.type }
end

csend_node = RuboCop::AST::ProcessedSource.new('o&.hoge(1)', RUBY_VERSION.to_f).ast
if csend_node.is_a?(RuboCop::AST::CsendNode)
  csend_node.send_type?
end

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
def_node = RuboCop::AST::ProcessedSource.new('def ! = true', RUBY_VERSION.to_f).ast

defined_node = RuboCop::AST::ProcessedSource.new('defined? print', RUBY_VERSION.to_f).ast
if defined_node.is_a?(RuboCop::AST::DefinedNode)
  defined_node.parenthesized?
  defined_node.method_name
  defined_node.node_parts
  defined_node.arguments
end

dstr_node = RuboCop::AST::ProcessedSource.new('"dstr#{123}dstr"', RUBY_VERSION.to_f).ast
if dstr_node.is_a?(RuboCop::AST::DstrNode)
  dstr_node.value
  if dstr_node.location.is_a?(Parser::Source::Map::Collection)
    dstr_node.location.begin
    dstr_node.location.end
  end
  if dstr_node.loc.is_a?(Parser::Source::Map::Collection)
    dstr_node.loc.begin
    dstr_node.loc.end
  end
end
dstr_node = RuboCop::AST::ProcessedSource.new('<<EOM
dstr#{123}dstr
EOM', RUBY_VERSION.to_f).ast
if dstr_node.is_a?(RuboCop::AST::DstrNode)
  dstr_node.value
  if dstr_node.location.is_a?(Parser::Source::Map::Heredoc)
    dstr_node.location.heredoc_body
    dstr_node.location.heredoc_end
  end
  if dstr_node.loc.is_a?(Parser::Source::Map::Heredoc)
    dstr_node.loc.heredoc_body
    dstr_node.loc.heredoc_end
  end
end

keyword_begin_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
begin
  do_something
rescue
  recover
ensure
  must_to_do
end
EOM
if keyword_begin_node.is_a?(RuboCop::AST::KeywordBeginNode)
  keyword_begin_node.body
  keyword_begin_node.ensure_node
  keyword_begin_node.rescue_node
end
ensure_node = keyword_begin_node&.child_nodes&.first
if ensure_node.is_a?(RuboCop::AST::EnsureNode)
  ensure_node.child_nodes
  ensure_node.branch
  ensure_node.rescue_node
  ensure_node.void_context?
end

float_node = RuboCop::AST::ProcessedSource.new('1.1', RUBY_VERSION.to_f).ast
if float_node.is_a?(RuboCop::AST::FloatNode)
  float_node.sign?
  float_node.value
end

for_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
for i in [1, 2, 3]
  print i*2, "\n"
end
EOM
if for_node.is_a?(RuboCop::AST::ForNode)
  for_node.keyword
  for_node.do?
  for_node.void_context?
  for_node.variable
  for_node.collection
  for_node.body
end

int_node = RuboCop::AST::ProcessedSource.new('+1', RUBY_VERSION.to_f).ast
if int_node.is_a?(RuboCop::AST::IntNode)
  int_node.sign?
  int_node.value
end

keyword_splat_node = RuboCop::AST::ProcessedSource.new('a(**{a: 1})', RUBY_VERSION.to_f).ast&.child_nodes&.first&.child_nodes&.first
if keyword_splat_node.is_a?(RuboCop::AST::KeywordSplatNode)
  keyword_splat_node.key
  keyword_splat_node.value
  keyword_splat_node.hash_rocket?
  keyword_splat_node.colon?
  keyword_splat_node.operator
  keyword_splat_node.node_parts
  keyword_splat_node.kwsplat_type?
end

masgn_node = RuboCop::AST::ProcessedSource.new('a, b, c = 1, 2, 3', RUBY_VERSION.to_f).ast
if masgn_node.is_a?(RuboCop::AST::MasgnNode)
  masgn_node.lhs
  masgn_node.lhs.assignments
  masgn_node.assignments
  masgn_node.names
  masgn_node.expression
  masgn_node.rhs
  masgn_node.values
end

module_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
module Foo
  def test
  end
end
EOM
if module_node.is_a?(RuboCop::AST::ModuleNode)
  module_node.identifier
  module_node.body
end

next_node = RuboCop::AST::ProcessedSource.new('next 1', RUBY_VERSION.to_f).ast
if next_node.is_a?(RuboCop::AST::NextNode)
  next_node.arguments
end

or_asgn_node = RuboCop::AST::ProcessedSource.new('a ||= 1', RUBY_VERSION.to_f).ast
if or_asgn_node.is_a?(RuboCop::AST::OrAsgnNode)
  or_asgn_node.assignment_node
  or_asgn_node.name
  or_asgn_node.operator
  or_asgn_node.expression
end

or_node = RuboCop::AST::ProcessedSource.new('1 or 2', RUBY_VERSION.to_f).ast
if or_node.is_a?(RuboCop::AST::OrNode)
  or_node.lhs
  or_node.rhs
  or_node.conditions
  or_node.operator
  or_node.logical_operator?
  or_node.semantic_operator?
  or_node.alternate_operator
  or_node.inverse_operator
end

send_node = RuboCop::AST::ProcessedSource.new('puts("hello")', RUBY_VERSION.to_f).ast
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
  send_node.method?(:puts)
  send_node.operator_method?
  send_node.nonmutating_binary_operator_method?
  send_node.nonmutating_unary_operator_method?
  send_node.nonmutating_operator_method?
  send_node.nonmutating_array_method?
  send_node.nonmutating_hash_method?
  send_node.nonmutating_string_method?
  send_node.comparison_method?
  send_node.assignment_method?
  send_node.enumerator_method?
  send_node.enumerable_method?
  send_node.predicate_method?
  send_node.bang_method?
  send_node.camel_case_method?
  send_node.self_receiver?
  send_node.const_receiver?
  send_node.negation_method?
  send_node.prefix_not?
  send_node.prefix_bang?
  send_node.send_type?
end
send_node = RuboCop::AST::ProcessedSource.new('1 + 2', RUBY_VERSION.to_f).ast

str_node = RuboCop::AST::ProcessedSource.new('"str"', RUBY_VERSION.to_f).ast
if str_node.is_a?(RuboCop::AST::StrNode)
  str_node.value
  str_node.single_quoted?
  str_node.double_quoted?
  str_node.character_literal?
  str_node.heredoc?
  str_node.percent_literal?
  str_node.percent_literal?(:Q)
  if str_node.location.is_a?(Parser::Source::Map::Collection)
    str_node.location.begin
    str_node.location.end
  end
  if str_node.loc.is_a?(Parser::Source::Map::Collection)
    str_node.loc.begin
    str_node.loc.end
  end
end
str_node = RuboCop::AST::ProcessedSource.new('<<EOM
heredoc
EOM', RUBY_VERSION.to_f).ast
if str_node.is_a?(RuboCop::AST::StrNode)
  if str_node.location.is_a?(Parser::Source::Map::Heredoc)
    str_node.location.heredoc_body
    str_node.location.heredoc_end
  end
  if str_node.loc.is_a?(Parser::Source::Map::Heredoc)
    str_node.loc.heredoc_body
    str_node.loc.heredoc_end
  end
end

super_node = RuboCop::AST::ProcessedSource.new('super 1, 2, 3', RUBY_VERSION.to_f).ast
if super_node.is_a?(RuboCop::AST::SuperNode)
  super_node.node_parts
  super_node.arguments
end

sym_node = RuboCop::AST::ProcessedSource.new(':sym', RUBY_VERSION.to_f).ast
sym_node.value if sym_node.is_a?(RuboCop::AST::SymbolNode)

irange_node = RuboCop::AST::ProcessedSource.new('1..10', RUBY_VERSION.to_f).ast
if irange_node.is_a?(RuboCop::AST::RangeNode)
  irange_node.begin
  irange_node.end
end
erange_node = RuboCop::AST::ProcessedSource.new('1...10', RUBY_VERSION.to_f).ast
if erange_node.is_a?(RuboCop::AST::RangeNode)
  erange_node.begin
  erange_node.end
end

regexp_node = RuboCop::AST::ProcessedSource.new('/abc/', RUBY_VERSION.to_f).ast
if regexp_node.is_a?(RuboCop::AST::RegexpNode)
  regexp_node.to_regexp
  regexp_node.regopt
  regexp_node.options
  regexp_node.content
  regexp_node.slash_literal?
  regexp_node.percent_r_literal?
  regexp_node.delimiters
  regexp_node.delimiter?('/')
  regexp_node.interpolation?
  regexp_node.multiline_mode?
  regexp_node.extended?
  regexp_node.ignore_case?
  regexp_node.single_interpolation?
  regexp_node.no_encoding?
  regexp_node.fixed_encoding?
end

rescue_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast&.child_nodes&.first
begin
  do_something
rescue
  retry
end
EOM
if rescue_node.is_a?(RuboCop::AST::RescueNode)
  rescue_node.body
  rescue_node.resbody_branches
  rescue_node.branches
  rescue_node.else_branch
  rescue_node.else?
  resbody_node = rescue_node.resbody_branches.first
  if resbody_node.is_a?(RuboCop::AST::ResbodyNode)
    resbody_node.body
    resbody_node.exceptions
    resbody_node.exception_variable
    resbody_node.branch_index
  end
end

return_node = RuboCop::AST::ProcessedSource.new('return 1', RUBY_VERSION.to_f).ast
if return_node.is_a?(RuboCop::AST::ReturnNode)
  return_node.arguments
end

self_class_node = RuboCop::AST::ProcessedSource.new(<<EOM, RUBY_VERSION.to_f).ast
class << self
  def foo
  end
end
EOM
if self_class_node.is_a?(RuboCop::AST::SelfClassNode)
  self_class_node.identifier
  self_class_node.body
end

until_node = RuboCop::AST::ProcessedSource.new('1 until true', RUBY_VERSION.to_f).ast
if until_node.is_a?(RuboCop::AST::UntilNode)
  until_node.single_line_condition?
  until_node.multiline_condition?
  until_node.condition
  until_node.body
  until_node.modifier_form?
  until_node.keyword
  until_node.inverse_keyword
  until_node.do?
end

var_node = RuboCop::AST::ProcessedSource.new('x = 1; x', RUBY_VERSION.to_f).ast&.child_nodes&.[](1)
if var_node.is_a?(RuboCop::AST::VarNode)
  var_node.name
end

while_node = RuboCop::AST::ProcessedSource.new('1 while true', RUBY_VERSION.to_f).ast
if while_node.is_a?(RuboCop::AST::WhileNode)
  while_node.single_line_condition?
  while_node.multiline_condition?
  while_node.condition
  while_node.body
  while_node.modifier_form?
  while_node.keyword
  while_node.inverse_keyword
  while_node.do?
end

yield_node = RuboCop::AST::ProcessedSource.new('yield 1', RUBY_VERSION.to_f).ast
if yield_node.is_a?(RuboCop::AST::YieldNode)
  yield_node.parenthesized?
  yield_node.first_argument
  yield_node.last_argument
  yield_node.arguments?
  yield_node.splat_argument?
  yield_node.rest_argument?
  yield_node.block_argument?
  yield_node.method?(:yield)
  yield_node.receiver
  yield_node.method_name
  yield_node.selector
  yield_node.block_node
  yield_node.macro?
  yield_node.access_modifier?
  yield_node.bare_access_modifier?
  yield_node.non_bare_access_modifier?
  yield_node.special_modifier?
  yield_node.command?(:yield)
  yield_node.setter_method?
  yield_node.assignment?
  yield_node.dot?
  yield_node.double_colon?
  yield_node.safe_navigation?
  yield_node.self_receiver?
  yield_node.const_receiver?
  yield_node.implicit_call?
  yield_node.block_literal?
  yield_node.arithmetic_operation?
  yield_node.def_modifier?
  yield_node.def_modifier
  yield_node.lambda?
  yield_node.lambda_literal?
  yield_node.unary_operation?
  yield_node.binary_operation?
  yield_node.node_parts
  yield_node.arguments
end
