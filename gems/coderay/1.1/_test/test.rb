# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "coderay"

CodeRay.scan("puts 'Hello, world!'", :ruby).encode(:html)
CodeRay.scan("1 + 2", :ruby).encode(:span, line_numbers: :inline)
tokens = CodeRay.scan("1 + 2", :ruby).tokens
tokens.count.succ
if tokens.is_a?(CodeRay::Tokens)
  tokens.text_token("foo", :comment).begin_group(:string).end_group(:string)
  tokens.split_into_parts(2, 3).each { |part| part.to_s }
  CodeRay.encode_tokens(tokens, :span)
end
CodeRay.scan(%w[a b], :text).tokens.size
CodeRay.encode("puts 1", :ruby, :terminal)
CodeRay.highlight("puts 1", :ruby, { line_numbers: :table }, :div)
CodeRay.encode_file(__FILE__, :html)
CodeRay.highlight_file(__FILE__)
CodeRay.scan_file(__FILE__).tokens

encoder = CodeRay.encoder(:html, css: :style)
encoder.encode("x = 1", :ruby)
encoder.file_extension.upcase
loc = CodeRay::Encoders::LinesOfCode.new.encode("x = 1\n\ny = 2", :ruby)
loc + 1
CodeRay::Encoders::Count.new.encode_tokens(CodeRay::Tokens.new.text_token("x", :ident)) + 1
CodeRay::Encoders::Filter.new.encode_tokens(CodeRay::Tokens.new.text_token("x", :ident)).count

scanner = CodeRay.scanner(:ruby)
scanner.tokenize("a = 1")
scanner.tokenize(["a = ", "1"]).each { |part| part.count }
scanner.line + scanner.column
scanner.lang
CodeRay::Scanners[:python].file_extension.upcase

duo = CodeRay::Duo[ruby: :html]
duo.highlight("def a; end")
CodeRay::Duo.new(:python, :text).call("print 1")

type = CodeRay::FileType["main.rb"]
type&.to_proc
CodeRay::FileType.fetch("main.rb").to_proc
CodeRay::FileType.fetch("unknown", :text)
CodeRay::FileType.fetch("unknown") { :plain }

CodeRay::Encoders[:html].title.upcase
CodeRay::Scanners.list.map(&:to_proc)
CodeRay::Scanners::Scanner.plugin_host.list

begin
  CodeRay.encoder(:no_such_format)
rescue CodeRay::PluginHost::PluginNotFound => e
  e.message
end
