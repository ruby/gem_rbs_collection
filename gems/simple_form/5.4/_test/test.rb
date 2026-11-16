require "simple_form"
require "active_record"
require "action_view"

module AppendComponent
  def append(_wrapper_options = nil)
    template.content_tag(:span, options[:append], class: "append") if options[:append]
  end
end

SimpleForm.include_component(AppendComponent)

module CustomInputs
end

SimpleForm.setup do |config|
  config.wrappers :default, class: :input, hint_class: :field_with_hint, error_class: :field_with_errors do |b|
    b.use :html5
    b.use :placeholder
    b.optional :maxlength
    b.optional :pattern
    b.use :label_input
    b.use :hint, wrap_with: { tag: :span, class: :hint }
    b.use :error, wrap_with: { tag: :span, class: :error }
  end

  config.wrappers :grouped, tag: :div do |b|
    b.use :html5
    b.wrapper tag: :div, class: "row" do |ba|
      ba.use :label
      ba.use :input
    end
    b.wrapper :hint_group, tag: :div, class: "hints" do |ba|
      ba.use :hint
    end
  end

  config.wrappers hint: false do |b|
    b.use :label_input
  end

  config.default_wrapper = :default
  config.boolean_style = :nested
  config.button_class = "btn"
  config.error_notification_tag = :div
  config.error_notification_class = "alert"
  config.error_method = :to_sentence
  config.label_text = ->(label, required, _explicit_label) { "#{label} #{required}" }
  config.label_class = "form-label"
  config.browser_validations = false
  config.required_by_default = false
  config.wrapper_mappings = { boolean: :grouped }
  config.input_mappings = { /count/ => :integer }
  config.custom_inputs_namespaces << "CustomInputs"
  config.generate_additional_classes_for = [:wrapper]
  config.item_wrapper_tag = :div
  config.item_wrapper_class = "form-check"
  config.collection_wrapper_tag = :div
  config.collection_wrapper_class = "form-group"
  config.boolean_label_class = "form-check-label"
  config.default_form_class = "simple_form"
  config.input_class = "form-control"
  config.input_field_error_class = "is-invalid"
  config.input_field_valid_class = "is-valid"
  config.include_default_input_wrapper_class = false
  config.collection_label_methods = [:to_label, :name]
  config.collection_value_methods = [:id]
  config.time_zone_priority = ["UTC"]
  config.country_priority = ["JP"]
  config.translate_labels = true
  config.inputs_discovery = true
  config.cache_discovery = false
  config.i18n_scope = "simple_form"
  config.field_error_proc = proc { |html_tag, _instance| html_tag }
end

# @type var wrapper: SimpleForm::Wrappers::Root
wrapper = SimpleForm.wrapper(:default)
wrapper.options.each_key { |key| key.to_sym }
wrapper.defaults.keys
wrapper.namespace
wrapper.find(:hint)
SimpleForm.wrappers.each_key { |name| name.upcase }
SimpleForm::WrapperNotFound.new("missing").message

# @type var label_text_proc: Proc
label_text_proc = SimpleForm.label_text
label_text_proc.call("a", "b", true)
SimpleForm.error_notification_tag.to_s
SimpleForm.error_notification_class.to_s
SimpleForm.button_class.to_s
SimpleForm.boolean_style == :inline
SimpleForm.default_wrapper.to_s
SimpleForm.error_method.to_s
SimpleForm.label_class.to_s
SimpleForm.browser_validations & true
SimpleForm.required_by_default & true
SimpleForm.wrapper_mappings&.keys
SimpleForm.input_mappings&.keys
SimpleForm.custom_inputs_namespaces.map(&:upcase)
SimpleForm.generate_additional_classes_for.map(&:to_s)
SimpleForm.item_wrapper_tag.to_s
SimpleForm.item_wrapper_class.to_s
SimpleForm.collection_wrapper_tag.to_s
SimpleForm.collection_wrapper_class.to_s
SimpleForm.boolean_label_class.to_s
SimpleForm.default_form_class.to_s
SimpleForm.input_class.to_s
SimpleForm.input_field_error_class.to_s
SimpleForm.input_field_valid_class.to_s
SimpleForm.include_default_input_wrapper_class & true
SimpleForm.collection_label_methods.map(&:to_s)
SimpleForm.collection_value_methods.map(&:to_s)
Array(SimpleForm.time_zone_priority).size
Array(SimpleForm.country_priority).size
SimpleForm.translate_labels & true
SimpleForm.inputs_discovery & true
SimpleForm.cache_discovery & true
SimpleForm.i18n_scope.to_s
SimpleForm.field_error_proc.call("<input>", nil)

class PercentInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    "#{@builder.text_field(attribute_name, merged_input_options)} %".html_safe
  end
end

class UppercaseInput < SimpleForm::Inputs::StringInput
  disable :placeholder
  enable :maxlength

  def input(wrapper_options = nil)
    input_html_classes << "uppercase"
    input_html_options[:class] = input_html_classes
    super
  end
end

class SelectableInput < SimpleForm::Inputs::CollectionSelectInput
  def input_options
    opts = super
    opts[:include_blank] = false
    opts
  end
end

class InspectInput < SimpleForm::Inputs::Base
  def input(wrapper_options = nil)
    # @type var name: String | Symbol
    name = attribute_name
    # @type var type: Symbol
    type = input_type
    # @type var opts: Hash[Symbol, untyped]
    opts = options
    # @type var view: ActionView::Base
    view = template
    summary = object_name.to_s + name.to_s + type.to_s + opts.keys.join + view.class.name.to_s +
      input_options.keys.join + additional_classes.join + input_class + Array(object).size.to_s + Array(column).size.to_s + Array(reflection).size.to_s +
      input_html_classes.join + html_classes.join + label_text + label_html_options.keys.join +
      has_errors?.to_s + has_hint?.to_s + has_value?.to_s + valid?.to_s +
      hint.to_s + error.to_s + full_error.to_s + label.to_s + label_input.to_s + label_target.to_s

    view.content_tag(:pre, summary)
  end
end

class CustomFormBuilder < SimpleForm::FormBuilder
  map_type :percent, to: PercentInput

  def labeled_input(name)
    input(name, wrapper: :grouped, input_html: { class: "custom" })
  end
end

class Member
  include ActiveModel::Model

  attr_accessor :name, :email, :note, :role
end

class Post < ActiveRecord::Base
end

class User < ActiveRecord::Base
  has_many :posts
end

# @type var view: ActionView::Base
view = ActionView::Base.empty
member = Member.new

# @type var form_html: String
form_html = view.simple_form_for(member, url: "/members", builder: CustomFormBuilder, html: { class: "form" }) do |f|
  # @type var input_html: ActiveSupport::SafeBuffer
  input_html = f.input(:name, as: :string, label: "Name", hint: "Hint", input_html: { class: "x" }, wrapper_html: { id: "w" })
  input_html.html_safe?
  f.attribute(:email, required: false).html_safe?
  f.input(:note) { "block" }.html_safe?
  f.input_field(:name, as: :boolean, boolean_style: :inline).html_safe?
  f.input(:name, as: :percent).html_safe?
  f.button(:submit, "Save", class: "extra").to_s
  f.error(:name, id: "name_error")&.upcase
  f.full_error(:name)&.upcase
  f.hint(:name)&.upcase
  f.hint("No special characters.")&.upcase
  f.label(:name, "Label").upcase
  f.label(:name, required: false).upcase
  f.error_notification(message: "Oops")&.upcase
  f.collection_radio_buttons(:role, [%w[a 1]], :last, :first) { |builder| builder }.upcase
  f.collection_check_boxes(:role, [%w[a 1]], :last, :first, {}, { class: "boxes" }).upcase
  f.template.class
  f.object_name.to_s
  Array(f.object).size
  f.wrapper.options
  f.labeled_input(:name).to_s if f.is_a?(CustomFormBuilder)
end
form_html.upcase

view.simple_fields_for(:profile, member, builder: CustomFormBuilder) do |f|
  f.input(:name).to_s
end.upcase

view.simple_fields_for(:profile, wrapper: :grouped) { |f| f.input(:name).to_s }.upcase

# association needs an ActiveRecord model and its database, so it is only defined here.
def render_association_form(view, user)
  view.simple_form_for(user, url: "/users") do |f|
    f.association(:posts, as: :check_boxes).to_s
    f.association(:posts) { |nested| nested.input(:id) }
  end
end

SimpleForm::FormBuilder.mappings.fetch(:string)
SimpleForm::FormBuilder::ACTIONS.fetch("create")
