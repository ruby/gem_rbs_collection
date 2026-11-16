require "phlex-rails"

class Article
  def to_partial_path
    "articles/article"
  end
end

class Counter
  def render_in(view_context, &)
    "1"
  end
end

class LinksComponent < Phlex::HTML
  include Phlex::Rails::Helpers::LinkTo
  include Phlex::Rails::Helpers::LinkToIf
  include Phlex::Rails::Helpers::LinkToUnless
  include Phlex::Rails::Helpers::LinkToUnlessCurrent
  include Phlex::Rails::Helpers::ButtonTo
  include Phlex::Rails::Helpers::MailTo
  include Phlex::Rails::Helpers::CurrentPage
  include Phlex::Rails::Helpers::URLFor
  include Phlex::Rails::Helpers::TurboFrameTag
  include Phlex::Rails::Helpers::TurboStreamFrom

  def view_template
    link_to "Home", "/", class: "nav"
    link_to("/docs", class: "doc") { plain "Docs" }
    link_to_if true, "Admin", "/admin"
    link_to_unless false, "Admin", "/admin", class: "admin"
    link_to_unless_current "Home", "/"
    button_to "Delete", "/articles/1", method: :delete, class: "danger"
    button_to("/articles/1", method: :delete) { plain "Remove" }
    mail_to "foo@example.com", "Mail", class: "mail"
    turbo_frame_tag "article_1", src: "/articles/1", target: "_top"
    turbo_frame_tag("modal") { plain "Loading" }
    turbo_stream_from "articles", "comments"

    # @type var current: bool
    current = current_page?("/")
    # @type var path: String
    path = url_for(controller: "articles", action: "index")
    path = url_for
    path.upcase
  end
end

class FormComponent < Phlex::HTML
  include Phlex::Rails::Helpers::FormWith
  include Phlex::Rails::Helpers::FormFor
  include Phlex::Rails::Helpers::FormTag
  include Phlex::Rails::Helpers::FieldsFor
  include Phlex::Rails::Helpers::CollectionCheckBoxes
  include Phlex::Rails::Helpers::CollectionCheckboxes
  include Phlex::Rails::Helpers::CollectionRadioButtons
  include Phlex::Rails::Helpers::CollectionSelect
  include Phlex::Rails::Helpers::FieldSetTag
  include Phlex::Rails::Helpers::FormAuthenticityToken
  include Phlex::Rails::Helpers::SelectTag
  include Phlex::Rails::Helpers::OptionsForSelect
  include Phlex::Rails::Helpers::OptionsFromCollectionForSelect
  include Phlex::Rails::Helpers::SubmitTag
  include Phlex::Rails::Helpers::ButtonTag
  include Phlex::Rails::Helpers::LabelTag
  include Phlex::Rails::Helpers::TextFieldTag
  include Phlex::Rails::Helpers::TextAreaTag
  include Phlex::Rails::Helpers::TextareaTag
  include Phlex::Rails::Helpers::SearchFieldTag
  include Phlex::Rails::Helpers::PasswordFieldTag
  include Phlex::Rails::Helpers::HiddenFieldTag
  include Phlex::Rails::Helpers::FileFieldTag
  include Phlex::Rails::Helpers::EmailFieldTag
  include Phlex::Rails::Helpers::NumberFieldTag
  include Phlex::Rails::Helpers::CheckBoxTag
  include Phlex::Rails::Helpers::CheckboxTag
  include Phlex::Rails::Helpers::TextField
  include Phlex::Rails::Helpers::TextArea
  include Phlex::Rails::Helpers::Label
  include Phlex::Rails::Helpers::Select
  include Phlex::Rails::Helpers::CheckBox
  include Phlex::Rails::Helpers::Checkbox
  include Phlex::Rails::Helpers::RadioButton
  include Phlex::Rails::Helpers::HiddenField
  include Phlex::Rails::Helpers::PasswordField
  include Phlex::Rails::Helpers::EmailField
  include Phlex::Rails::Helpers::NumberField
  include Phlex::Rails::Helpers::FileField

  def view_template
    form_with(url: "/search", method: :get, class: "search") do |form|
      form.label :q, "Query"
      form.text_field :q, placeholder: "Search"
      form.text_area :memo, rows: 3
      form.hidden_field :page, value: 1
      form.password_field :secret
      form.email_field :email
      form.number_field :age, min: 0
      form.search_field :term
      form.url_field :site
      form.telephone_field :phone
      form.file_field :avatar
      form.date_field :born_on
      form.time_field :at
      form.datetime_local_field :starts_at
      form.color_field :color
      form.range_field :volume
      form.check_box :agree, class: "box"
      form.check_box :agree, {}, "1", "0"
      form.radio_button :kind, "a"
      form.select :role, %w[admin member], { include_blank: true }, class: "role"
      form.collection_select :author_id, [], :id, :name, { prompt: true }
      form.collection_check_boxes :tag_ids, [], :id, :name do |builder|
        builder.check_box
        builder.text
      end
      form.collection_radio_buttons :kind, [], :id, :name do |builder|
        builder.radio_button
        builder.value
      end
      form.fields_for :address do |address_form|
        address_form.text_field :city
        address_form.fields_for :geo, nil, {} do |geo_form|
          geo_form.hidden_field :lat
        end
      end
      form.submit "Search", class: "button"
      form.button "Go", name: "go" do
        plain "Go"
      end
      form.send(:text_field, :q)
      form.public_send(:text_field, :q, class: "dynamic")
      form.object
      form.object_name.to_s
      form.unwrap
    end

    form_for(Article.new, html: { class: "edit" }) do |form|
      form.label :title
    end

    form_tag("/articles", method: :post, multipart: true) do
      plain "fields"
    end

    fields_for(:profile, Article.new) do |profile|
      profile.text_field :name
    end

    field_set_tag("Account", class: "group") { plain "x" }

    # @type var token: String
    token = form_authenticity_token
    token = form_authenticity_token(form_options: {})

    select_tag :sort, class: "sort" do
      options_for_select([["Name", "name"], ["Date", "date"]], "name")
    end
    select_tag :author do
      options_from_collection_for_select([], :id, :name, 1)
    end
    select_tag :size, nil, include_blank: true
    submit_tag "Save", class: "button"
    button_tag "Save", type: "submit" do
      plain "Save"
    end
    label_tag :email, "Email", class: "label"
    text_field_tag :q, "default", class: "input"
    textarea_tag :memo, "body"
    textarea :user, :bio
    text_area_tag :memo, "body", rows: 5
    search_field_tag :term
    password_field_tag :password
    hidden_field_tag :token, "abc"
    file_field_tag :upload, accept: "image/*"
    email_field_tag :email, "foo@example.com"
    number_field_tag :count, 1, min: 0
    check_box_tag :agree, "1", true, class: "box"
    checkbox_tag :agree
    text_field :user, :name, class: "input"
    text_area :user, :bio
    label :user, :name, "Name"
    select :user, :role, %w[admin member], { include_blank: true }
    check_box :user, :admin
    checkbox :user, :admin
    radio_button :user, :kind, "a"
    hidden_field :user, :id
    password_field :user, :password
    email_field :user, :email
    number_field :user, :age
    file_field :user, :avatar
    collection_select :user, :author_id, [], :id, :name
    collection_check_boxes :user, :tag_ids, [], :id, :name do |builder|
      builder.check_box
    end
    collection_checkboxes :user, :tag_ids, [], :id, :name do |builder|
      builder.label
    end
    collection_radio_buttons :user, :kind, [], :id, :name do |builder|
      builder.radio_button
    end
  end
end

class ValueComponent < Phlex::HTML
  include Phlex::Rails::Helpers::ClassNames
  include Phlex::Rails::Helpers::ContentFor
  include Phlex::Rails::Helpers::Sanitize
  include Phlex::Rails::Helpers::StripTags
  include Phlex::Rails::Helpers::Truncate
  include Phlex::Rails::Helpers::Excerpt
  include Phlex::Rails::Helpers::Highlight
  include Phlex::Rails::Helpers::SimpleFormat
  include Phlex::Rails::Helpers::Pluralize
  include Phlex::Rails::Helpers::Cycle
  include Phlex::Rails::Helpers::NumberToHumanSize
  include Phlex::Rails::Helpers::NumberToHuman
  include Phlex::Rails::Helpers::NumberToCurrency
  include Phlex::Rails::Helpers::NumberToPercentage
  include Phlex::Rails::Helpers::NumberWithDelimiter
  include Phlex::Rails::Helpers::DistanceOfTimeInWords
  include Phlex::Rails::Helpers::DistanceOfTimeInWordsToNow
  include Phlex::Rails::Helpers::TimeAgoInWords
  include Phlex::Rails::Helpers::TimeTag
  include Phlex::Rails::Helpers::DOMClass
  include Phlex::Rails::Helpers::DOMID
  include Phlex::Rails::Helpers::L
  include Phlex::Rails::Helpers::Localize
  include Phlex::Rails::Helpers::T
  include Phlex::Rails::Helpers::Translate
  include Phlex::Rails::Helpers::Request
  include Phlex::Rails::Helpers::Flash
  include Phlex::Rails::Helpers::Notice
  include Phlex::Rails::Helpers::ControllerName
  include Phlex::Rails::Helpers::ActionName
  include Phlex::Rails::Helpers::ContentSecurityPolicyNonce
  include Phlex::Rails::Helpers::ContentTag
  include Phlex::Rails::Helpers::DefaultURLOptions
  include Phlex::Rails::Helpers::URLOptions

  def view_template
    # @type var css: ActiveSupport::SafeBuffer
    css = class_names("card", active: true)
    css.html_safe?

    content_for :title, "Home"
    content_for(:sidebar) { plain "side" }
    # @type var has_title: bool
    has_title = content_for?(:title)

    # @type var clean: ActiveSupport::SafeBuffer?
    clean = sanitize("<b>x</b>", tags: %w[b])
    strip_tags("<b>x</b>")&.html_safe?
    truncate("long text", length: 4)&.html_safe?
    # @type var snippet: String?
    snippet = excerpt("long text", "text", radius: 2)
    highlight("long text", "text") { plain "x" }
    simple_format("a\nb", class: "p").html_safe?
    # @type var label: String
    label = pluralize(2, "apple")
    label = cycle("odd", "even")
    # @type var size: String?
    size = number_to_human_size(1024)
    size = number_to_human(1_000_000)
    size = number_to_currency(10.5, unit: "$")
    size = number_to_percentage(12.3)
    size = number_with_delimiter(1_000_000)

    time = Time.now
    label = distance_of_time_in_words(time, time + 60)
    label = distance_of_time_in_words_to_now(time)
    label = time_ago_in_words(time)
    time_tag time, "now", class: "time"
    time_tag(time) { plain "now" }

    label = dom_class(Article.new, :edit)
    label = dom_id(Article.new, :edit)
    label = l(time, format: :short)
    label = localize(time)
    label = t("hello", name: "x")
    label = translate(".title")

    # @type var req: ActionDispatch::Request
    req = request
    req.path
    # @type var flashes: ActionDispatch::Flash::FlashHash
    flashes = flash
    flashes[:notice]
    # @type var message: String?
    message = notice
    message = content_security_policy_nonce
    label = controller_name
    label = action_name
    content_tag :div, "body", class: "box"
    content_tag(:div, class: "box") { plain "body" }
    # @type var defaults: Hash[Symbol, untyped]
    defaults = default_url_options
    url_options
  end
end

class AssetsComponent < Phlex::HTML
  include Phlex::Rails::Helpers::ImageTag
  include Phlex::Rails::Helpers::ImagePath
  include Phlex::Rails::Helpers::ImageURL
  include Phlex::Rails::Helpers::AssetPath
  include Phlex::Rails::Helpers::AssetURL
  include Phlex::Rails::Helpers::VideoTag
  include Phlex::Rails::Helpers::AudioTag
  include Phlex::Rails::Helpers::JavaScriptTag
  include Phlex::Rails::Helpers::JavascriptTag
  include Phlex::Rails::Helpers::StylesheetLinkTag
  include Phlex::Rails::Helpers::JavascriptIncludeTag

  def view_template
    image_tag "logo.png", alt: "logo", class: "logo"
    video_tag "movie.mp4", controls: true
    audio_tag "song.mp3"
    javascript_tag "alert(1)", nonce: true
    javascript_tag(defer: true) { plain "alert(1)" }
    stylesheet_link_tag "application", media: "all"
    # @type var path: String
    path = image_path("logo.png")
    path = image_url("logo.png")
    path = asset_path("logo.png", type: :image)
    path = asset_url("logo.png")
  end
end

class BaseLayout < Phlex::HTML
  include Phlex::Rails::Layout

  def view_template(&block)
    doctype
    html do
      head do
        csp_meta_tag
        csrf_meta_tags
        favicon_link_tag "favicon.ico"
        preload_link_tag "font.woff2", as: :font
        stylesheet_link_tag "application"
        action_cable_meta_tag
        auto_discovery_link_tag :rss, "/feed"
        javascript_include_tag "application"
        javascript_importmap_module_preload_tags
        javascript_importmap_tags
        javascript_importmap_tags("admin", importmap: nil)
        javascript_import_module_tag "application"
        javascript_inline_importmap_tag
        turbo_refresh_method_tag
        turbo_refresh_method_tag :morph
        turbo_refresh_scroll_tag :preserve
        turbo_refreshes_with method: :morph, scroll: :preserve
        turbo_include_tags
      end
      body(&block)
    end
  end
end

# Helpers::Routes is included in test.rbs only. Including it here evaluates Rails.application.routes when the file loads.
class RenderComponent < Phlex::HTML
  include Phlex::Rails::Helpers::ContentFor

  register_output_helper :custom_output
  register_output_helper :custom_safe_output, mark_safe: true
  register_value_helper :custom_value
  register_builder_yielding_helper :custom_builder

  def initialize(article)
    @article = article
  end

  def view_template
    # @type var rails_view: ActionView::Base
    rails_view = view_context
    rails_view.request

    render @article
    render Counter.new
    render partial("articles/article", article: @article)
    render(partial("shared/box")) { plain "box" }
    render LinksComponent.new
    render { plain "block" }
    render "text"

    # @type var box: Phlex::Rails::Partial
    box = partial("shared/box", size: 1)
    # @type var rendered: String?
    rendered = box.render_in(view_context)
    rendered&.length

    # @type var html: ActiveSupport::SafeBuffer
    html = "<b>x</b>".html_safe
    raw html

    default_url_options
    url_for(only_path: true)
  end
end

Phlex::Rails::Helpers::CheckBoxTag
Phlex::Rails::HelpersCalledBeforeRenderError.new
