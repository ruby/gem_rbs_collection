# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "tilt"
require "tilt/erb"
require "tilt/string"
require "tilt/plain"
require "tilt/cli"
require "stringio"

class TiltScope
  def title
    "Tilt"
  end
end

# Templates from a block
erb = Tilt::ERBTemplate.new { "Hello <%= name %> from <%= title %>" }
erb.render(TiltScope.new, name: "World").upcase
erb.render(TiltScope.new, { name: "World" }).upcase
Tilt::ERBTemplate.new { "static" }.render.size
erb.data
erb.line + 1
erb.options.key?(:trim)
erb.eval_file.upcase
erb.basename&.upcase
erb.name&.upcase
erb.fixed_locals?
erb.metadata[:mime_type]

layout = Tilt::ERBTemplate.new(nil, 1, trim: "-") { "<div><%= yield %></div>" }
layout.render { "content" }.upcase

str = Tilt::StringTemplate.new(freeze: true) { |_template| 'Hi #{name}' }
str.render(Object.new, name: "Tilt").upcase

# Templates from a file
path = File.join(Dir.pwd, "tilt_test.html.erb")
File.write(path, "<%= 1 + 1 %>")
begin
  Tilt.new(path).render.strip
  Tilt.new(path, 1, { trim: "-" }).render.strip
  Tilt::ERBTemplate.new(path, trim: "-").file&.upcase
  File.open(path) { |file| Tilt::ERBTemplate.new(file).render.strip }

  if klass = Tilt[path]
    klass.new(path).render
  end
  Tilt.template_for(path)
  Tilt.templates_for(path).map(&:name)
ensure
  File.delete(path)
end

# Registering templates
class UpcaseTemplate < Tilt::Template
  self.default_mime_type = "text/plain"

  private

  def prepare
    @upcased = data.to_s.upcase
  end

  def evaluate(scope, locals, &block)
    @upcased.to_s
  end

  def freeze_string_literals?
    true
  end
end

UpcaseTemplate.default_mime_type&.upcase
UpcaseTemplate.metadata[:mime_type]
Tilt.register(UpcaseTemplate, "up", :upcase)
Tilt.registered?("up")
Tilt.register_lazy(:ERBTemplate, "tilt/erb", "rhtml")
Tilt.register_lazy("Tilt::StringTemplate", "tilt/string", "str")
Tilt.extract_fixed_locals = false
Tilt.extract_fixed_locals

pipeline = Tilt.register_pipeline("str.erb")
pipeline.new { "<%= 1 %>" }.render

mapping = Tilt::Mapping.new
mapping.register(Tilt::ERBTemplate, "erb")
mapping.register("str", Tilt::StringTemplate)
mapping.registered?("erb")
mapping.extensions_for(Tilt::ERBTemplate).map(&:upcase)
mapping.template_map["erb"]
mapping.lazy_map.each { |ext, choices| choices.map(&:first) }
mapping.unregister("str")
mapping["template.erb"]&.new { "" }
finalized = mapping.finalized
finalized.registered?("erb")
finalized.dup.templates_for("index.html.erb")

default = Tilt.default_mapping
default.registered?("erb")

plain = Tilt::PlainTemplate.new { "<p>plain</p>" }
plain.render.upcase
plain.allows_script?

Shout = Tilt::StaticTemplate.subclass(mime_type: "text/plain") { data.to_s.upcase }
Shout.new { "static" }.render.upcase
Shout.new { "static" }.render(Object.new) { "ignored" }.upcase

stdout = StringIO.new
Tilt::CLI.run(argv: ["--list"], stdout: stdout, stderr: StringIO.new) + 1
