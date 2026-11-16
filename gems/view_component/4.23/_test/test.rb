require "view_component"
require "action_view"
require "action_controller"

class ApplicationComponent < ViewComponent::Base
  strip_trailing_whitespace
end

class ActionComponent < ViewComponent::Base
  def call
    "<a></a>"
  end
end

class SmallBadgeComponent < ViewComponent::Base
  def call
    "<small></small>"
  end
end

class LargeBadgeComponent < ViewComponent::Base
  def call
    "<big></big>"
  end
end

class InlineComponent < ViewComponent::Base
  erb_template "<div><%= content %></div>"
end

class ParentComponent < ApplicationComponent
  def call
    "<p>parent</p>"
  end
end

class AlertComponent < ParentComponent
  renders_one :title
  renders_one :icon, "IconComponent"
  renders_one :footer, -> { "footer" }
  renders_many :actions, ActionComponent
  renders_one :badge, types: { small: SmallBadgeComponent, large: LargeBadgeComponent }

  strip_trailing_whitespace false
  with_collection_parameter :message

  def initialize(message:)
    super()
    @message = message
  end

  def render?
    !@message.empty?
  end

  def before_render
    # @type var ctrl: ActionController::Base
    ctrl = controller
    ctrl.controller_name

    # @type var view: ActionView::Base
    view = helpers
    view.content_tag(:span, @message)
  end

  def around_render
    yield
  end

  def call
    # @type var body: String?
    body = content
    content_tag(:div, body.to_s) if content?
    parent_html = render_parent_to_string
    parent_html.length
    request&.path
    translate(".title", count: 1)
    t(:message)
    t([:message, :title])
    render_parent
    title.content?
    title.to_s
    ""
  end
end

class IconComponent < ViewComponent::Base
  def call
    "<i></i>"
  end

  def output_preamble
    "<!-- icon -->"
  end

  def output_postamble
    "<!-- /icon -->"
  end
end

class CardComponent < ViewComponent::Base
  with_collection_parameter :card

  def initialize(card:, card_counter: 0)
    super()
    @card = card
    @counter = card_counter
  end

  def call
    "<div>#{@card}</div>"
  end
end

class CardPreview < ViewComponent::Preview
  layout "admin"

  def default
    render(CardComponent.new(card: "a"))
  end

  def with_block
    render(AlertComponent.new(message: "hi")) do
      "block"
    end
  end

  def templated
    render_with_template(template: "card_preview/templated", locals: { card: "a" })
  end
end

# @type var view_context: ActionView::Base
view_context = ActionController::Base.new.view_context

# @type var component: AlertComponent
component = AlertComponent.new(message: "hello")
component.with_title_content("Title")
# Slot#with_content raises DuplicateSlotContentError once the slot has content, so it is only type-checked
set_title_content = -> { component.title.with_content("text") }
set_title_content.arity
# @type var html: String
html = component.render_in(view_context) { "block" }
html.length

# @type var with_body: InlineComponent
with_body = InlineComponent.new.with_content("body")
with_body.render_in(view_context).length

# @type var cache_key: String
cache_key = AlertComponent.cache_digest(format: :html)
cache_key.length

# @type var options: ViewComponent::Config::Options
options = ViewComponent::Base.config
options.previews.generate
options.instrumentation_enabled = true
options.instrumentation_enabled

# @type var collection: ViewComponent::Collection
collection = CardComponent.with_collection(%w[a b], spacer_component: IconComponent.new)
collection.size.zero?
collection.each { |c| c.render? }
collection.map { |c| c.content? }
collection.render_in(view_context).length

AlertComponent.strip_trailing_whitespace?
AlertComponent.sidecar_files(%w[css js]).first&.length
AlertComponent.slot_type(:title)
AlertComponent.t("hello")
AlertComponent.translate(["a", :b])
InlineComponent.new.render_in(view_context).length

# @type var all_previews: Array[singleton(ViewComponent::Preview)]
all_previews = ViewComponent::Preview.all
CardPreview.examples.first&.length
CardPreview.exists?("card")
CardPreview.find("card")&.preview_name
CardPreview.preview_name.length
CardPreview.new.render(IconComponent.new)[:component]

ViewComponent::Config.current.generate
ViewComponent::Config.defaults.previews

icon = IconComponent.new
icon.output_preamble.length
icon.output_postamble.length
icon.before_render
icon.around_render { 1 }
icon.render?
icon.current_template
icon.content?
