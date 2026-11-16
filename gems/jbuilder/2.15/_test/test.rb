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

json = Jbuilder.new do |j|
  j.set!(:title, "Hello")
  j.set!("author") do |author|
    author.set!(:name, "Alice")
    author.set!(:age, 32)
  end
end
json_string = json.target!
json_string.upcase

encoded = Jbuilder.encode do |j|
  j.set!(:id, 1)
end
encoded.upcase

Jbuilder.encode(ignore_nil: true, deep_format_keys: true) { |j| j.set!(:a, nil) }.upcase
formatter = Jbuilder::KeyFormatter.new(:upcase)
Jbuilder.new(key_formatter: formatter).target!.upcase
formatter.format(:first_name).upcase
formatted = Jbuilder::KeyFormatter.new(camelize: :lower)
formatted.format("first_name").upcase

builder = Jbuilder.new
builder.key_format!(:upcase)
builder.key_format!(camelize: :lower)
builder.key_format!(->(key) { "_#{key}" })
builder.ignore_nil!
builder.ignore_nil!(false)
builder.deep_format_keys!
builder.deep_format_keys!(false)
Jbuilder.key_format(:upcase)
Jbuilder.ignore_nil(false)
Jbuilder.deep_format_keys(false)

builder.set!(:comments, [1, 2, 3]) do |comment|
  comment.to_s
end
builder.set!(:people, [{ name: "a" }], :name)

Jbuilder.new { |j| j.child! { j.set!(:content, "hello") } }.target!.upcase
Jbuilder.new { |j| j.child! { |c| c.set!(:content, "world") } }.attributes!

array_builder = Jbuilder.new
array_builder.array!([1, 2]) do |n|
  n.to_s
end
array_builder.array!([{ name: "x" }], :name)
array_builder.array!
array_builder.target!.upcase

extract_builder = Jbuilder.new
extract_builder.extract!({ name: "x" }, :name)
extract_builder.extract!(Time.now, :year, "month")
extract_builder.call({ name: "x" }, :name)
extract_builder.call([1]) { |n| n.to_s }
extract_builder.null!
extract_builder.nil!

merge_builder = Jbuilder.new
merge_builder.merge!({ "a" => 1 })
merge_builder.merge!([1])
merge_builder.merge!(Jbuilder.new)
attrs = merge_builder.attributes!
attrs.nil?

errors = [Jbuilder::NullError.new("x"), Jbuilder::ArrayError.new("x"), Jbuilder::MergeError.new("x")]
errors.map(&:message)
Jbuilder::Blank.new.empty?

JbuilderTemplate.template_lookup_options = { handlers: [:jbuilder] }
JbuilderTemplate.template_lookup_options.keys

# JbuilderTemplate is created by the template handler, and these calls need a view context
# @type var render_template: ^(JbuilderTemplate) -> void
render_template = lambda do |template_json|
  template_json.partial!("messages/message", message: "x")
  template_json.partial!(partial: "messages/message", locals: { message: "x" })
  template_json.partial!(Object.new, as: :comment)
  template_json.partial!(Object.new)
  template_json.set!(:comments, [1], partial: "comments/comment", as: :comment)
  template_json.array!([1], partial: "comments/comment", as: :comment)
  template_json.set!(:author) { |a| a.set!(:name, "x") }
  template_json.array!([1]) { |n| n.to_s }
  template_json.cache!(["v1", 1], expires_in: 600) { template_json.set!(:a, 1) }
  template_json.cache!(nil) { template_json.set!(:a, 1) }
  template_json.cache_root!("k") { template_json.set!(:a, 1) }
  template_json.cache_if!(true, "k") { template_json.set!(:a, 1) }
  template_json.target!.upcase
end

Jbuilder::VERSION.upcase

fake_template = FakeTemplate.new("json.partial! 'messages/message'")
tracker_result = Jbuilder::DependencyTracker.call("messages/show", fake_template)
tracker_result.map(&:upcase)
Jbuilder::DependencyTracker.call("messages/show", fake_template, [])
ActionView::DependencyTracker.register_tracker(:jbuilder, Jbuilder::DependencyTracker)

# Jbuilder < BasicObject has no Object#class
Jbuilder.new.class # steep:ignore NoMethod
