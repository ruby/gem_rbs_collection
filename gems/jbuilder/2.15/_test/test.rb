require "jbuilder"
require "action_view"

class FakeTemplate
  def initialize(source)
    @source = source
  end

  def source
    @source
  end
end

class MappableComments
  def map(&block)
    ["a", "b"].map(&block)
  end
end

json = Jbuilder.new do |j|
  j.set!(:title, "Hello")
  j.set!("author") do |author|
    author.set!(:name, "Alice")
    author.set!(:age, 32)
  end
end
# @type var json_string: String
json_string = json.target!
json_string.upcase

# @type var encoded: String
encoded = Jbuilder.encode do |j|
  j.set!(:id, 1)
end
encoded.upcase

Jbuilder.encode(ignore_nil: true, deep_format_keys: true) { |j| j.set!(:a, nil) }.upcase
Jbuilder.encode.upcase
# @type var formatter: Jbuilder::KeyFormatter
formatter = Jbuilder::KeyFormatter.new(:upcase)
Jbuilder.new(key_formatter: formatter).target!.upcase
Jbuilder.new(key_formatter: nil, ignore_nil: true, deep_format_keys: false).target!.upcase
# @type var formatted_key: String
formatted_key = formatter.format(:first_name)
formatted_key.upcase
formatted = Jbuilder::KeyFormatter.new(camelize: :lower)
formatted.format("first_name").upcase

builder = Jbuilder.new
# @type var key_formatter: Jbuilder::KeyFormatter
key_formatter = builder.key_format!(:upcase)
key_formatter.format(:a)
builder.key_format!(camelize: :lower)
builder.key_format!(->(key) { "_#{key}" })
# @type var ignore_nil: boolish
ignore_nil = builder.ignore_nil!
ignore_nil = builder.ignore_nil!(false)
# @type var deep_format_keys: boolish
deep_format_keys = builder.deep_format_keys!
deep_format_keys = builder.deep_format_keys!(false)
# @type var default_formatter: Jbuilder::KeyFormatter
default_formatter = Jbuilder.key_format(:upcase)
default_formatter.format("a")
Jbuilder.ignore_nil(false)
Jbuilder.deep_format_keys(false)

builder.set!(:comments, [1, 2, 3]) do |comment|
  comment.to_s
end
builder.set!(:people, [{ name: "a" }], :name)
builder.set!(:mapped, MappableComments.new) { |comment| comment.upcase }
builder.set!(:none, nil) { |_comment| nil }
builder.set!(:copy, Jbuilder.new)

Jbuilder.new { |j| j.child! { j.set!(:content, "hello") } }.target!.upcase
Jbuilder.new { |j| j.child! { |c| c.set!(:content, "world") } }.attributes!

array_builder = Jbuilder.new
array_builder.array!([1, 2]) do |n|
  n.to_s
end
array_builder.array!([{ name: "x" }], :name)
array_builder.array!({ a: 1 }) { |pair| pair.first.to_s }
array_builder.array!(nil)
array_builder.array!
array_builder.target!.upcase

extract_builder = Jbuilder.new
extract_builder.extract!({ name: "x" }, :name)
extract_builder.extract!(Time.now, :year, "month")
extract_builder.call({ name: "x" }, :name)
extract_builder.call([1]) { |n| n.to_s }
# @type var null_value: nil
null_value = extract_builder.null!
null_value = extract_builder.nil!

merge_builder = Jbuilder.new
# @type var merged: Hash[untyped, untyped] | Array[untyped] | Jbuilder::Blank | nil
merged = merge_builder.merge!({ "a" => 1 })
merged = merge_builder.merge!([1])
merged = merge_builder.merge!(Jbuilder.new)
# @type var attrs: Hash[untyped, untyped] | Array[untyped] | Jbuilder::Blank | nil
attrs = merge_builder.attributes!
attrs.nil?

errors = [Jbuilder::NullError.new("x"), Jbuilder::ArrayError.new("x"), Jbuilder::MergeError.new("x")]
errors.map(&:message)
# @type var null_error: Jbuilder::NullError
null_error = Jbuilder::NullError.build(:name)
null_error.message
# @type var array_error: Jbuilder::ArrayError
array_error = Jbuilder::ArrayError.build("name")
array_error.message
# @type var merge_error: Jbuilder::MergeError
merge_error = Jbuilder::MergeError.build({ "a" => 1 }, [1])
merge_error.message
# @type var blank_empty: true
blank_empty = Jbuilder::Blank.new.empty?
# @type var blank_equal: bool
blank_equal = Jbuilder::Blank.new == Jbuilder::Blank.new
blank_equal ^ blank_empty

JbuilderTemplate.template_lookup_options = { handlers: [:jbuilder] }
# @type var lookup_options: Hash[Symbol, untyped]
lookup_options = JbuilderTemplate.template_lookup_options
lookup_options.keys

# JbuilderTemplate is created by the template handler, and these calls need a view context
# @type var render_template: ^(untyped) -> void
render_template = lambda do |view|
  template_json = JbuilderTemplate.new(view)
  JbuilderTemplate.new(view, { ignore_nil: true }) { |j| j.set!(:a, 1) }
  template_json.partial!("messages/message", message: "x")
  template_json.partial!(partial: "messages/message", locals: { message: "x" })
  template_json.partial!(Object.new, as: :comment)
  template_json.partial!(Object.new)
  template_json.set!(:comments, [1], partial: "comments/comment", as: :comment)
  template_json.set!(:comment, Object.new, partial: "comments/comment", as: :comment, cached: true)
  template_json.array!([1], partial: "comments/comment", as: :comment)
  template_json.set!(:author) { |a| a.partial!("authors/author") }
  template_json.array!([1]) { |n| n.to_s }
  template_json.array!([{ name: "x" }], :name)
  template_json.array!
  template_json.cache!(["v1", 1], expires_in: 600) { template_json.set!(:a, 1) }
  template_json.cache!(nil) { |j| j&.set!(:a, 1) }
  template_json.cache_root!("k") { template_json.set!(:a, 1) }
  template_json.cache_if!(true, "k") { template_json.set!(:a, 1) }
  # @type var template_target: String
  template_target = template_json.target!
  template_target.upcase
end
render_template.call(nil)

Jbuilder::VERSION.upcase

fake_template = FakeTemplate.new("json.partial! 'messages/message'")
# @type var tracker_result: Array[String]
tracker_result = Jbuilder::DependencyTracker.call("messages/show", fake_template)
tracker_result.map(&:upcase)
Jbuilder::DependencyTracker.call("messages/show", fake_template, [])
# @type var dependencies: Array[String]
dependencies = Jbuilder::DependencyTracker.new("messages/show", fake_template).dependencies
dependencies.first
Jbuilder::DependencyTracker::DIRECT_RENDERS.match?("json.partial! 'a'")
ActionView::DependencyTracker.register_tracker(:jbuilder, Jbuilder::DependencyTracker)

# @type var handler_source: String
handler_source = JbuilderHandler.call(fake_template, "json.a 1")
handler_source.upcase
JbuilderHandler.default_format.to_s

# Jbuilder < BasicObject has no Object#class
Jbuilder.new.class # steep:ignore NoMethod
