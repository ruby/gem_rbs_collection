require "racc/parser"

class ExampleParser < Racc::Parser
  def initialize(input)
    @input = input
  end

  def next_token
    [false, @input]
  end

  def on_error(token_id, value, value_stack)
    super
  end
end

parser = ExampleParser.new("input")
parser.do_parse
parser.yyparse(Object.new, :each_token)
parser.next_token
parser.on_error(1, "unexpected token", [])
parser.token_to_str(1)
Racc::Parser.racc_runtime_type
