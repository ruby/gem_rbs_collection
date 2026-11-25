require "awesome_print"

1.ai.upcase
[1, 2].ai(index: false, plain: true).upcase
{ a: 1 }.awesome_inspect(html: true).upcase

ap(1)&.succ
ap("x", indent: 2)&.upcase
Kernel.ap([1])&.size
awesome_print(:sym)&.to_proc

"text".red.upcase
"text".red(true).upcase
"text".yellowish.upcase
"text".black.upcase
"text".pale(false).upcase

AwesomePrint.defaults = { indent: 2, sort_keys: true }
AwesomePrint.defaults&.fetch(:indent)
AwesomePrint.defaults = nil
AwesomePrint.force_colors = false
AwesomePrint.force_colors!
AwesomePrint.force_colors! false
AwesomePrint.console? || AwesomePrint.rails_console?
AwesomePrint.pry!
AwesomePrint.version.upcase

inspector = AwesomePrint::Inspector.new(plain: true)
inspector.awesome([1, { a: 2 }]).upcase
inspector.current_indentation.succ
inspector.increase_indentation { inspector.current_indentation }.succ
inspector.options[:plain]
inspector.indentator.shift_width.succ
inspector.colorize?

formatter = AwesomePrint::Formatter.new(inspector)
formatter.format(1).upcase
formatter.format([1], :array).upcase
formatter.cast(1, :integer).to_proc
formatter.colorize("x", :string).upcase
formatter.inspector.awesome(nil)
AwesomePrint::Formatter::CORE_FORMATTERS.first

indentator = AwesomePrint::Indentator.new(2)
indentator.indent { indentator.indentation }.succ
