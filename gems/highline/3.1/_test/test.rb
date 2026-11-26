require "highline"
require "stringio"

input = StringIO.new("Ruby\n42\nyes\n2\n")
output = StringIO.new
# @type var cli: HighLine
cli = HighLine.new(input, output)
HighLine.new(input, output, 80, :auto, 2, 1)
HighLine.new

# @type var name: untyped
name = cli.ask("Name?  ") do |q|
  q.default = "Ruby"
  q.validate = /\A\w+\z/
  q.whitespace = :strip_and_collapse
  q.case = :capitalize
  q.echo = "*"
  q.limit = 10
  q.responses[:not_valid] = "Letters only."
  q.character = nil
  q.readline = false
  q.confirm = false
  q.glob = "*.rb"
  q.directory = Pathname.new(".")
end

# @type var age: untyped
age = cli.ask("Age?  ", Integer) { |q| q.in = 0..120 }

# @type var ok: bool
ok = cli.agree("Continue?  ")
ok = cli.agree("Continue?  ", true) { |q| q.default = "y" }

# @type var choice: untyped
choice = cli.choose do |menu|
  menu.index = :letter
  menu.index_suffix = ") "
  menu.layout = :list
  menu.flow = :rows
  menu.header = "Languages"
  menu.prompt = "Pick one?  "
  menu.shell = false
  menu.nil_on_handled = false
  menu.select_by = :index_or_name
  menu.index_color = :rgb_77bbff
  menu.choice(:ruby, "A dynamic language") { |command| command }
  menu.choices(:python, :perl)
  menu.hidden(:exit)
  menu.help("ruby", "Ruby help")
end
cli.choose("a", "b")

# @type var colored: String
colored = cli.color("Sustainable", :green, :bold)
colored = cli.color("Sustainable", HighLine::BOLD, [:red, :on_black])
colored = HighLine.color("Sustainable", HighLine::RED_STYLE)
colored = cli.uncolor(colored)
colored = cli.color_code(:red, :blue)

# @type var listed: String
listed = cli.list(%w[a b c], :columns_across, 2)
listed = cli.list(%w[a b c], :inline, " and ")

cli.say("Hello <%= color('world', BOLD) %>!")
cli.say(nil)
HighLine.say("Hello")
cli.indent(2, "indented", true)
# @type var indented: Integer
indented = cli.indent { |h| h.indent_level }
cli.newline
cli.puts("a", "b")
cli.wrap_at = :auto
cli.page_at = 20
# @type var wrap_at: Integer?
wrap_at = cli.wrap_at
# @type var cols: Integer
cols = cli.output_cols
cols = cli.output_rows
# @type var scoped: HighLine
scoped = cli.new_scope
scoped.use_color = false
# @type var flag: bool
flag = scoped.use_color?
scoped.track_eof = false
# @type var eof_flag: bool?
eof_flag = scoped.track_eof?
scoped.multi_indent = true
scoped.indent_size = 4
scoped.indent_level = 0
# @type var rendered: String
rendered = cli.render_statement("text")
rendered = cli.render_and_ident_statement("text")
rendered = cli.indentation

HighLine.default_instance = cli
HighLine.use_color = true
HighLine.track_eof = true
HighLine.reset_use_color
flag = HighLine.supports_rgb_color?

# @type var scheme: HighLine::ColorScheme
scheme = HighLine::ColorScheme.new do |cs|
  cs[:headline] = [:bold, :yellow, :on_black]
  cs[:even_row] = [:green]
end
scheme = HighLine::ColorScheme.new(warning: [:bold, :yellow])
scheme = HighLine::SampleColorScheme.new
# @type var scheme_style: HighLine::Style?
scheme_style = scheme[:critical]
flag = scheme.include?(:critical)
# @type var keys: Array[String]
keys = scheme.keys
# @type var scheme_hash: Hash[String, Array[HighLine::style]]
scheme_hash = scheme.to_hash
# @type var definition: Array[HighLine::style]?
definition = scheme.definition(:error)
HighLine.color_scheme = scheme
HighLine.using_color_scheme?
scheme = HighLine.add_to_color_scheme(custom: [:blue])
HighLine.reset_color_scheme
HighLine.reset

# @type var style: HighLine::Style
style = HighLine.Style(:red, :bold)
style = HighLine::Style.rgb(255, 96, 0)
style = style.on
style = HighLine::RED_STYLE.bright
# @type var code: String
code = style.code
code = HighLine::Style.rgb_hex(9, 10, "11")
code = HighLine::Style.uncolor("\e[31mred\e[0m")
# @type var parts: Array[Integer]
parts = HighLine::Style.rgb_parts("090A0B")

# @type var hl_string: HighLine::String
hl_string = HighLine::String("highline")
hl_string = hl_string.red.on_blue.bold
hl_string = hl_string.color(:bright_blue, :underline)
hl_string = hl_string.rgb(255, 96, 0)
hl_string = hl_string.on_rgb("ff6000")
hl_string = hl_string.uncolor

# @type var question: HighLine::Question
question = HighLine::Question.new("Name?", String)
question.gather = 3
question.verify_match = true
question.first_answer = "first"
rendered = question.to_s

begin
  cli.ask("Name?")
rescue HighLine::CustomErrors::ExplainableError => e
  # @type var explanation: Symbol?
  explanation = e.explanation_key
end
