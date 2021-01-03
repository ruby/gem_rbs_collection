require 'ast'

def String!(_) end
def Symbol!(_) end
def Array!(_) end
def Node!(_) end
def Bool!(_) end

# AST::Node

node1 = AST::Node.new(:x)
node2 = AST::Node.new(:x, [:foo, 42])
AST::Node.new(:x, [:foo, 42], { y: 1 })

Array!  node1.children
String! node1.hash
Symbol! node1.type
Bool!   node1 == node2
Node!   node1.append 42
Node!   node1.concat [1, 2, 3]
Node!   node1.dup
Bool!   node1.eql? node2
String! node1.inspect
Node!   node1.to_ast
String! node1.to_sexp
Array!  node1.to_sexp_array
Node!   node1.updated
Node!   node1.updated(:foo)
Node!   node1.updated(:foo, [])
Node!   node1.updated(:foo, [], {})

# AST::Processor

p = AST::Processor.new
n = p.process(node1)
Node! n if n
p.process(nil)
Array! p.process_all([node1, node2])

# AST::Sexp

class X
  extend AST::Sexp
end

Node! X.s(:foo, 1, 2, 3)
Node! X.s('foo', 1, 2, 3)
