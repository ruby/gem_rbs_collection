require "i18n-js"
require "i18n/js/version"
require "i18n/js/middleware"
require "i18n"

# @type var version: String
version = I18n::JS::VERSION

# @type var default_config_path: String
default_config_path = I18n::JS::DEFAULT_CONFIG_PATH
default_config_path.end_with?(".yml")

# @type var default_export_dir: String
default_export_dir = I18n::JS::DEFAULT_EXPORT_DIR_PATH
default_export_dir.start_with?("public")

# @type var config_file_path: String
config_file_path = I18n::JS.config_file_path
I18n::JS.config_file_path = "config/custom-i18n-js.yml"

# @type var export_dir: String | :none
export_dir = I18n::JS.export_i18n_js_dir_path
I18n::JS.export_i18n_js_dir_path = "app/assets/javascripts"
I18n::JS.export_i18n_js_dir_path = false
I18n::JS.export_i18n_js_dir_path = nil

# @type var sorted: bool
sorted = I18n::JS.sort_translation_keys?
I18n::JS.sort_translation_keys = false

I18n::JS.backend = I18n.backend
simple_backend = I18n::Backend::Simple.new
I18n::JS.backend = simple_backend
simple_backend.reload!

# @type var translations: Hash[Symbol, untyped]
translations = I18n::JS.translations
translations.keys

# Writes i18n.js and the translation files into the configured directories
class Exporter
  def run
    I18n::JS.export
  end
end

I18n::JS::Middleware.is_a?(Class)
