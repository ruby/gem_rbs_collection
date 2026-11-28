require "crass"

css = "/* note */ a:hover { color: #0d8bfa; *zoom: 1 !important } @media print { p { margin: 0 } }"

# @type var tree: Array[Crass::node]
tree = Crass.parse(css, preserve_comments: true, preserve_hacks: true)
tree.each { |node| node[:node] }
Crass.parse(css, maximum_depth: 10)
options = { preserve_comments: true }
Crass.parse(css, options)
Crass.parse(css)

# @type var properties: Array[Crass::node]
properties = Crass.parse_properties("color: red; margin: 0 auto !important", preserve_comments: true)
properties.map { |node| node[:name] }

# @type var stringified: String
stringified = Crass::Parser.stringify(tree)
stringified.length
Crass::Parser.stringify(tree, exclude_comments: true)
Crass::Parser.stringify(properties.first || {})

# @type var stylesheet: Array[Crass::node]
stylesheet = Crass::Parser.parse_stylesheet(css, preserve_comments: true)
stylesheet.size
# @type var rules: Array[Crass::node]
rules = Crass::Parser.parse_rules("p { color: red } <!-- -->")
rules.size

# @type var tokens: Array[Crass::node]
tokens = Crass::Tokenizer.tokenize("a { b: c }", preserve_comments: true)
Crass::Parser.parse_properties(Crass::Tokenizer.tokenize("color: red"))
tokenizer = Crass::Tokenizer.new("a /* x */ b")
# @type var first_token: Crass::node?
first_token = tokenizer.consume
first_token&.fetch(:raw)
tokenizer.tokenize.size

parser = Crass::Parser.new(tokens)
# @type var scanner: Crass::TokenScanner
scanner = parser.tokens
parser.consume_rules(top_level: true)
scanner.reset
# @type var value: Crass::node
value = parser.parse_component_value
value[:node]
parser.parse_component_values(tokens).size
parser.parse_declaration(Crass::Tokenizer.tokenize("color: red")).fetch(:name)
parser.parse_declarations(Crass::Tokenizer.tokenize("color: red; ;"), strict: true).size
parser.parse_properties(Crass::Tokenizer.tokenize("color: red")).size
parser.parse_rule(Crass::Tokenizer.tokenize("a { b: c }")).fetch(:node)
# @type var selector_value: String
selector_value = parser.parse_value(tokens)
selector_value.strip

token_scanner = Crass::TokenScanner.new(tokens)
# @type var collected: Array[Crass::node]
collected = token_scanner.collect { token_scanner.consume }
collected.size
token_scanner.peek
token_scanner.reconsume
token_scanner.current
token_scanner.pos
token_scanner.tokens.size

str_scanner = Crass::Scanner.new("a b")
# @type var char: String
char = str_scanner.consume
char.size
str_scanner.mark
str_scanner.scan(/ /)
str_scanner.scan_until(/b/)
# @type var marked: String
marked = str_scanner.marked
marked.size
str_scanner.peek(2)
str_scanner.reconsume
str_scanner.eos?
str_scanner.consume_rest
str_scanner.current
str_scanner.pos = 0
str_scanner.marker = 0
str_scanner.string
str_scanner.reset
