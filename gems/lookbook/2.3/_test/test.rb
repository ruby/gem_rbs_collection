require "lookbook"

version_string = Lookbook.version
version_string.upcase

Lookbook.configure do |config|
  config.ui_theme = "green"
  config.ui_theme_overrides = { header_bg: "#1b5e20" }
  config.preview_paths = ["#{Rails.root}/test/previews"]
end

config = Lookbook.config
config.project_name = ["Main", "Review"].join(" - ")
config.project_logo = "<svg></svg>"
config.ui_theme = :indigo
config.preview_layout = "component_preview"
config.preview_controller = "LookbooksController"
config.preview_template = "lookbook/previews/preview"
config.preview_collection_label = "Components"
config.preview_nav_filter = true
config.preview_display_options = { density: ["compact", "comfortable"] }
config.preview_disable_error_handling = false
config.preview_single_pass_rendering = true
config.preview_sort_scenarios = true
config.page_collection_label = "Docs"
config.page_nav_filter = false
config.page_paths = ["docs"]
config.page_extensions = ["md.erb"]
config.page_route = "guides"
config.page_options = { header: false }
config.component_paths = ["app/components"]
config.markdown_options = { tables: true }
config.highlighter_options = { theme: "github" }
config.reload_on_change = true
config.lazy_load_previews_and_pages = true
config.live_updates = false
config.listen_paths = ["app/components"]
config.listen_extensions = ["rb"]
config.autoload_previews = true
config.ui_favicon = { light: "<svg></svg>", dark: "<svg></svg>" }
config.log_level = 1
config.log_use_rails_logger = false
config.debug_menu = true

# @type var title: String | false | nil
title = config.project_name
theme_name = config.ui_theme
theme_name.upcase
config.preview_paths.each { |path| path.to_s.upcase }
config.page_extensions.first&.upcase
config.preview_inspector[:main_panels]
config.preview_embeds[:enabled]
config.ui_theme_overrides[:header_bg]
config.ui_theme_overrides { |overrides| overrides[:header_bg] = "#fff" }
display_options = config.preview_display_options
display_options.keys
labels = [config.preview_collection_label, config.page_collection_label, config.preview_controller, config.preview_template]
labels.map(&:upcase)
flags = [config.preview_nav_filter, config.page_nav_filter, config.live_updates, config.autoload_previews, config.lazy_load_previews_and_pages, config.debug_menu, config.using_view_component, config.log_use_rails_logger]
flags.map(&:!)
config.log_level + 1
config.using_view_component = true
config.project_logo&.upcase
config.preview_layout
config.ui_favicon
config.preview_disable_error_handling
config.preview_single_pass_rendering
config.preview_sort_scenarios
config.page_route.upcase
config.page_options
config.component_paths
config.markdown_options
config.highlighter_options
config.reload_on_change
config.listen_paths
config.listen_extensions

Lookbook.data = { user: "me" }
Lookbook.data[:user]
Lookbook.data.fetch(:user, "nobody")
Lookbook.data.to_h.keys

Lookbook.add_input_type(:currency, "inputs/currency", { label: "Currency" })
Lookbook.add_input_type(:color, "inputs/color")
Lookbook.add_panel(:info, "panels/info", { label: "Extra Info", hotkey: "i", locals: { a: 1 } })
Lookbook.add_panel("extra", "panels/extra")
Lookbook.update_panel(:notes, { label: "Usage Info", hotkey: "u" })
Lookbook.remove_panel(:notes)
Lookbook.add_tag(:status, [:state]) do |tag|
  tag.tag_args[:state]&.upcase
  tag.tag_body&.upcase
  tag.opts.keys
  tag.arg_names.first
  tag.text
end
Lookbook.add_tag("note")
Lookbook.add_tag(:custom) { |tag| tag.options }
Lookbook.after_initialize { |app| app.version }
Lookbook.before_exit { |app| app.config }
Lookbook.after_change { |app, changes| app.pages.size + changes.size }

Lookbook::Engine.mount_path.upcase
Lookbook::Engine.mounted? ? 1 : 2
Lookbook::Engine.previews.find_by_preview_class(Lookbook::Preview)
Lookbook::Engine.pages.find_by_id(:welcome)&.title
Lookbook::Engine.previews.find_scenario_by_path("button/default")&.label

class ButtonPreview < Lookbook::Preview
  layout "preview_layout"

  def default
    render "button/default"
  end

  def with_template
    render_with_template(template: "button_preview/with_template", locals: { label: "Go" })
  end

  def with_block
    render { "x" }
  end

  def alias_render
    render_component "button/default", label: "Go"
  end

  def tags
    tag.span("x") + image_tag("a.png")
  end
end

class DesignController < Lookbook::PreviewController
end

Lookbook.previews.each do |preview|
  preview.preview_class.layout("x")
  preview.preview_class_name.upcase
  preview.scenarios.map(&:name)
  preview.visible_scenarios.first&.label
  preview.hidden_scenarios.count
  preview.default_scenario&.inspect_path
  preview.scenario(:default)&.preview_path
  preview.inspect_path.upcase
  preview.preview_path.upcase
  preview.url_path.upcase
  preview.notes.upcase
  preview.has_tag?(:hidden)
  preview.file_path.basename
  preview.file_name(true).upcase
  preview.relative_file_path.to_s
  preview.lookup_path.upcase
  preview.id.upcase
  preview.visible? && !preview.hidden?
  preview.directory_path
  preview.last_modified
  preview.relative_directory_path
  preview.render_targets.each do |target|
    target.component_class
    target.inline? || target.component? || target.template?
    target.template_file_path
  end
  if (first_scenario = preview.scenarios.first)
    preview.scenarios.next(first_scenario)
    preview.scenarios.previous(first_scenario)
  end
  preview.scenarios.find_by_path("default")
  preview.scenarios.each do |scenario|
    case scenario
    when Lookbook::ScenarioEntity
      scenario.source.upcase
      scenario.parent.label
      scenario.url_path
    when Lookbook::ScenarioGroupEntity
      scenario.scenarios.map(&:label)
      scenario.preview.name
    end
  end
end

Lookbook.pages.each do |page|
  page.title.upcase
  page.docs_path.upcase
  page.url_path.upcase
  page.landing? || page.markdown? || page.header? || page.footer?
  page.data
  page.type
  page.label
  page.file_extension
end

# @type var describe_error: ^(Lookbook::Error) -> String?
describe_error = lambda do |error|
  error.scope
  error.line_number
  error.file_path
  error.backtrace_lines
  error.original&.message
  error.status
  error.detail
  error.source
  error.relative_file_path
  error.type.upcase
  error.message&.upcase
end

# @type var describe_config_error: ^(Lookbook::ConfigError) -> String
describe_config_error = ->(error) { error.type }

module PreviewHelperUser
  include Lookbook::PreviewHelper

  def theme
    lookbook_display(:theme, "light")
    lookbook_data(:user)
  end
end
