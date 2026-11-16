require "liquid"

# Custom filter
module ShoutFilter
  def shout(input)
    input.upcase
  end
end

# Template: parse, render and render!
template = Liquid::Template.parse("Hello {{ name }}!", error_mode: :strict)
html = template.render({ "name" => "World" })
html.upcase
strict_html = template.render!({ "name" => "World" }, strict_variables: true, strict_filters: true)
strict_html.upcase
empty_html = template.render
empty_html.upcase
filtered_html = template.render({ "name" => "World" }, filters: [ShoutFilter], registers: { "controller" => 1 })
filtered_html.upcase
template.render({ "name" => "World" }, ShoutFilter).upcase
strict_options = { filters: [ShoutFilter], strict_filters: true, strict_variables: true }
template.render({ "name" => "World" }, strict_options).upcase
template.render!({ "name" => "World" }, [ShoutFilter]).upcase
template.render({ "name" => "World" }, global_filter: ->(value) { value }, exception_renderer: ->(_error) { "error" }).upcase
template.render({ "name" => "World" }, output: +"").upcase

# @type var errors: Array[Liquid::Error]
errors = template.errors
errors.first&.line_number
template.registers[:request_id] = 42
template.assigns["total"] = 3
root = template.root
root.nodelist.size
template.root = root

# Custom tags
Liquid::Template.register_filter(ShoutFilter)

class HelloTag < Liquid::Tag
  def initialize(tag_name, markup, parse_context)
    super
    @name = markup.strip
    @source = parse_context.partial_options[:source]
  end

  def parse(tokens)
    super
    tokens.shift
  end

  def render(context)
    # @type var agent: Integer
    agent = context.registers[:agent]
    "#{tag_name} #{@name} #{raw} #{line_number} #{nodelist.size} #{@tag_name} #{@markup} #{@line_number} #{agent}"
  end
end

Liquid::Template.register_tag("hello", HelloTag)
Liquid::Template.tags["hello"]
Liquid::Template.tags.each { |name, _tag| name.upcase }
Liquid::Template.tags.filter_map { |name, _tag| name.upcase }

class BoxTag < Liquid::Block
  def initialize(tag_name, markup, parse_context)
    super
    @inline = markup.split.include?("inline")
    parse_context.depth += 1
    parse_context.line_number = 1
    parse_context.partial
    parse_context.error_mode.to_s
    parse_context[:error_mode]
    parse_context.environment.error_mode
  end

  def render(context)
    content = super
    @body.nodelist.size
    "<div>#{content}#{nodelist.size}</div>"
  end

  def unknown_tag(tag_name, markup, tokenizer)
    return super unless tag_name == "else"

    markup.strip
    tokenizer.shift
    tokenizer.line_number
  end
end

Liquid::Template.register_tag("box", BoxTag)

class SplitTag < Liquid::Block
  def initialize(tag_name, markup, parse_context)
    super
    @in_block = Liquid::BlockBody.new
  end

  def parse(tokens)
    parse_body(@in_block, tokens)
  end

  def render(context)
    @in_block.nodelist.size
    @in_block.blank?
    @in_block.render(context)
  end
end

# Drop
class UserDrop < Liquid::Drop
  def initialize(user)
    super()
    @user = user
  end

  def name
    @user.to_s
  end

  def liquid_method_missing(method)
    method.to_s
  end

  def to_s
    @user.to_s
  end
end

drop = UserDrop.new("alice")
drop.to_liquid
drop.to_s.upcase
drop["name"]
drop.key?("name")
drop.context = Liquid::Context.new
Liquid::Template.parse("{{ user.name }}").render({ "user" => drop }).upcase
Liquid::Template.parse("{{ name }}").render(drop).upcase

# Context
context = Liquid::Context.new({ "env" => "production" }, { "outer" => 1 }, { agent: 1 }, true)
context["name"] = "Alice"
context["name"]
context.key?("name")
context.registers[:agent]
context.registers[:agent] = 2
context.registers.static[:flag] = true
context.registers.key?(:agent)
context.registers.delete(:agent)
context.environments.unshift({ "extra" => 1 })
context.scopes.first
context.errors.size
context.strict_variables = true
context.strict_filters = true
context.template_name = "greeting"
context.push({ "inner" => 1 })
context.pop
stacked = context.stack({ "temporary" => 1 }) { "inside" }
stacked.upcase
context.stack { context["inner"] }

class LiquidContext < Liquid::Context
  def initialize(owner)
    super({}, { "_owner_" => owner }, { owner: owner }, true)
  end

  def same?(other)
    @environments == other.environments && @scopes == other.scopes && @registers == other.registers
  end
end

LiquidContext.new("owner").same?(Liquid::Context.new)
Liquid::Template.parse("{{ _owner_ }}").render!(LiquidContext.new("owner")).upcase
Liquid::Context.new(UserDrop.new("bob")).registers
Liquid::Context.new([{ "a" => 1 }, UserDrop.new("bob")], nil, Liquid::Registers.new({ a: 1 }))
Liquid::Registers.new(Liquid::Registers.new)

# Environment
environment = Liquid::Environment.default
environment.register_tag("hello", HelloTag)
environment.register_filter(ShoutFilter)
environment.error_mode = :strict
environment.error_mode.to_s
environment.tags["hello"]
environment.tags = environment.tags.dup

custom_environment = Liquid::Environment.build(tags: { "hello" => HelloTag }, error_mode: :warn) do |env|
  env.register_tag("box", BoxTag)
end
Liquid::Template.parse("{% hello %}", environment: custom_environment).render.upcase
Liquid::Environment.build { |env| env.register_filter(ShoutFilter) }
Liquid::Environment.build(error_mode: :strict2)
Liquid::Environment.build(error_mode: :lax).error_mode

# Errors
begin
  Liquid::Template.parse("{% if %}", error_mode: :strict).render!
rescue Liquid::SyntaxError => e
  e.message.upcase
  e.line_number
  e.template_name
  e.markup_context
  e.to_s(false)
rescue Liquid::ZeroDivisionError, Liquid::UndefinedVariable, Liquid::UndefinedFilter, Liquid::UndefinedDropMethod => e
  e.to_s
rescue Liquid::ArgumentError, Liquid::ContextError, Liquid::FileSystemError, Liquid::StandardError, Liquid::StackLevelError, Liquid::MemoryError, Liquid::FloatDomainError => e
  e.message
rescue Liquid::MethodOverrideError, Liquid::DisabledError, Liquid::InternalError, Liquid::TemplateEncodingError => e
  e.message
rescue Liquid::Error => e
  e.message
end

# Constants
Liquid::VERSION.upcase
[
  Liquid::FilterSeparator, Liquid::TagStart, Liquid::TagEnd, Liquid::TagName, Liquid::VariableStart,
  Liquid::VariableEnd, Liquid::QuotedString, Liquid::QuotedFragment, Liquid::TagAttributes
].each { |pattern| pattern.source }
/#{Liquid::TagStart}+.*#{Liquid::FilterSeparator}+.*#{Liquid::TagEnd}+/
