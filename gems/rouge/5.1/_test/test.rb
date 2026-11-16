require "rouge"
require "rouge/plugins/redcarpet"

source = "puts 'hello'\n"

# Highlight with a lexer and a formatter
html_out = Rouge.highlight(source, "ruby", "html")
html_out.upcase
Rouge.highlight(source, Rouge::Lexers::Ruby.new, Rouge::Formatters::HTML.new).upcase
Rouge.highlight(source, Rouge::Lexers::Ruby, Rouge::Formatters::HTML).upcase
Rouge.highlight(source, "ruby", "html") { |chunk| chunk.upcase }
Rouge.version.upcase
Rouge.eager_load!

# Find a lexer
lexer_class = Rouge::Lexer.find("ruby")
lexer_class&.tag&.upcase
Rouge::Lexer.find(:ruby)
lexer = Rouge::Lexer.find_fancy("ruby", source)
lexer&.tag&.upcase
Rouge::Lexer.find_fancy("guess", source, { "debug" => false })
Rouge::Lexer.find_fancy(nil)
found_class, found_options = Rouge::Lexer.lookup_fancy("erb?parent=tex")
found_class&.tag&.upcase
found_options.size

# Guess a lexer
Rouge::Lexer.guess(filename: "foo.rb", source: source).tag.upcase
Rouge::Lexer.guess(mimetype: "text/x-shellscript").tag.upcase
Rouge::Lexer.guess_by_filename("foo.rb").tag.upcase
Rouge::Lexer.guess_by_mimetype("text/html").tag.upcase
Rouge::Lexer.guess_by_source(source).tag.upcase
Rouge::Lexer.guess({ source: source }) { |candidates| candidates.first || Rouge::Lexers::PlainText }.tag.upcase
guessed = Rouge::Lexer.guesses(source: source).first
guessed&.tag&.upcase
Rouge::Lexer.guess.tag.upcase

begin
  Rouge::Lexer.guess(source: source)
rescue Rouge::Guesser::Ambiguous => e
  e.alternatives.first&.tag&.upcase
end

# Lexer class attributes
Rouge::Lexer.all.map { |klass| klass.mimetypes.first }.compact.first&.upcase
Rouge::Lexers::Ruby.title.upcase
Rouge::Lexers::Ruby.lex(source) { |token, value| token.qualname.upcase + value.upcase }
Rouge::Lexers::Ruby.desc&.upcase
Rouge::Lexers::Ruby.aliases.first&.upcase
Rouge::Lexers::Ruby.filenames.first&.upcase

# Lex and format
ruby_lexer = Rouge::Lexers::Ruby.new
formatter = Rouge::Formatters::HTML.new
formatter.format(ruby_lexer.lex(source)).upcase
formatter.format(Rouge::Lexers::Ruby.lex(source)).upcase
formatter.format(Rouge::Lexers::Shell.lex(source, { debug: false })).upcase
formatter.format(Rouge::Formatters::HTML.new.format(ruby_lexer.continue_lex(source)).lines.map { |l| [Rouge::Token, l] }).upcase
Rouge::Lexers::PlainText.new(token: "Text").options.size
Rouge::Lexers::PlainText.new.token
ruby_lexer.tag.upcase
ruby_lexer.lex(source) { |token, value| token.qualname.upcase + value.upcase }
ruby_lexer.lex(source).each { |token, value| token.shortname&.upcase; value.upcase }
ruby_lexer.lex(source).each { |token, value| token.name&.upcase; value.upcase }
ruby_lexer.options.size
ruby_lexer.continue_lex(source) { |_token, value| value.upcase }

chunks = [] # steep:ignore UnannotatedEmptyCollection
formatter.format(ruby_lexer.lex(source)) { |chunk| chunks << chunk }
Rouge::Formatters::HTML.format(ruby_lexer.lex(source)).upcase

formatter.span(Rouge::Token, "<b>").upcase
formatter.safe_span(Rouge::Token, "b").upcase
Rouge::Formatters::HTMLDebug.new.format(ruby_lexer.lex(source)).upcase

# Formatters
Rouge::Formatters::HTMLLegacy.new.format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::HTMLLegacy.new(css_class: "codehilite", line_numbers: true, wrap: false).format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::HTMLLegacy.new(inline_theme: "github").format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::HTMLTable.new(formatter, start_line: 10, line_format: "%03i", table_class: "t", gutter_class: "g", code_class: "c").format(ruby_lexer.lex(source)).upcase
line_table = Rouge::Formatters::HTMLLineTable.new(formatter, start_line: 1, table_class: "t", line_id: "L%i", line_class: "l", gutter_class: "g", code_class: "c")
line_table.format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::HTMLLineTable.new(Rouge::Formatters::HTMLInline.new("github")).format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::Null.new.format(ruby_lexer.lex(source)).upcase
Rouge::Formatter.find("html")&.tag&.upcase
Rouge::Formatter.tag&.upcase

# Themes
Rouge::Theme.find("github")&.render(scope: ".highlight")&.upcase
Rouge::Theme.registry.keys.first&.upcase
Rouge::Theme.registry["github"]&.palette("#fff")&.upcase
Rouge::Themes::Github.render(scope: ".highlight").upcase
Rouge::Themes::Github.render.upcase
Rouge::Themes::ThankfulEyes.render { |line| line.upcase }
Rouge::Themes::ThankfulEyes.new(scope: ".rouge").render.upcase
Rouge::Themes::Monokai.new.render { |line| line.upcase }
Rouge::CSSTheme.new.render.upcase
Rouge::Themes::Colorful.render.upcase
Rouge::Themes::Base16.render.upcase
Rouge::Themes::BlackWhiteTheme.render.upcase
Rouge::Themes::IgorPro.render.upcase
Rouge::Themes::Magritte.render.upcase
Rouge::Themes::Molokai.render.upcase
Rouge::Themes::MonokaiSublime.render.upcase
Rouge::Themes::Pastie.render.upcase
Rouge::Themes::Tulip.render.upcase

# Inline-styled formatter with a theme name, class, or instance
Rouge::Formatters::HTMLInline.new("github").format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::HTMLInline.new(Rouge::Themes::Github).format(ruby_lexer.lex(source)).upcase
Rouge::Formatters::HTMLInline.new(Rouge::Themes::Github.new).format(ruby_lexer.lex(source)).upcase

# Themes with modes
mode_theme = Rouge::Themes::Gruvbox.mode(:light)
Rouge::Formatters::HTMLInline.new(mode_theme).format(ruby_lexer.lex(source)).upcase
Rouge::Themes::Gruvbox.mode&.to_s&.upcase
Rouge::Themes::Github.mode(:dark).render.upcase
Rouge::Themes::Base16.mode(:light).render.upcase
Rouge::Themes::Gruvbox.light!
Rouge::Themes::Gruvbox.dark!
Rouge::Themes::Github.light!
Rouge::Themes::Github.dark!
Rouge::Themes::Base16.light!
Rouge::Themes::Base16.dark!

# Constants of lexers
[
  Rouge::Lexers::ArmAsm, Rouge::Lexers::C, Rouge::Lexers::Cpp, Rouge::Lexers::CSharp, Rouge::Lexers::CSS,
  Rouge::Lexers::Diff, Rouge::Lexers::Go, Rouge::Lexers::GraphQL, Rouge::Lexers::HTML, Rouge::Lexers::INI,
  Rouge::Lexers::Java, Rouge::Lexers::Javascript, Rouge::Lexers::JSON, Rouge::Lexers::Kotlin, Rouge::Lexers::Lua,
  Rouge::Lexers::Make, Rouge::Lexers::Markdown, Rouge::Lexers::ObjectiveC, Rouge::Lexers::Perl, Rouge::Lexers::PHP,
  Rouge::Lexers::PlainText, Rouge::Lexers::Python, Rouge::Lexers::R, Rouge::Lexers::Ruby, Rouge::Lexers::Rust,
  Rouge::Lexers::Scss, Rouge::Lexers::Shell, Rouge::Lexers::SQL, Rouge::Lexers::Swift, Rouge::Lexers::Typescript,
  Rouge::Lexers::VisualBasic, Rouge::Lexers::XML, Rouge::Lexers::YAML
].each { |klass| klass.lex(source).each { |_token, value| value.upcase } }

# Look up a lexer constant by name
# @type var json_lexer_class: singleton(Rouge::Lexer)
json_lexer_class = Rouge::Lexers.const_get(:JSON)
json_lexer_class.new.lex("{}").to_a

# Redcarpet plugin
class CodeRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet

  def rouge_formatter(lexer)
    lexer.tag.upcase
    Rouge::Formatters::HTMLInline.new("github")
  end
end

class PlainCodeRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end

CodeRenderer.new.block_code("puts 1", "ruby").upcase
PlainCodeRenderer.new.block_code("puts 1", nil).upcase
# @type var no_tokens: Array[Rouge::Token::pair]
no_tokens = []
PlainCodeRenderer.new.rouge_formatter(Rouge::Lexers::Ruby).format(no_tokens).upcase
Redcarpet::Markdown.new(PlainCodeRenderer.new, fenced_code_blocks: true).render("```ruby\nputs 1\n```").upcase
