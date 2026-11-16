require "i18n-js"
require "i18n-js/listen"
require "pathname"

# @type var version: String
version = I18nJS::VERSION

# @type var translations: Hash[Symbol, untyped]
translations = I18nJS.translations
translations.keys

I18nJS::MissingConfigError.new("missing").message.upcase

# These write files, read the config file or need a Rails app, so they are not called
class Exporter
  def run
    # @type var exported_files: Array[String]
    exported_files = I18nJS.call(config_file: "config/i18n.yml")
    exported_files = I18nJS.call(config_file: Pathname.new("config/i18n.yml"))

    config = {
      "translations" => [
        { "file" => "app/javascript/locales/:locale.json", "patterns" => ["*"] }
      ]
    }
    exported_files = I18nJS.call(config:)
    exported_files
  end

  def watch
    I18nJS.listen
    I18nJS.listen(config_file: "config/i18n.yml")
    I18nJS.listen(config_file: Pathname.new("config/i18n.yml"), locales_dir: Pathname.new("config/locales"))

    # @type var listened: Array[String]?
    listened = I18nJS.listen(
      config_file: "config/i18n.yml",
      locales_dir: ["config/locales", "app/views"],
      options: { only: /.yml$/ },
      run_on_start: nil
    )
    listened
  end
end

module I18nJS
  class SamplePlugin < I18nJS::Plugin
    def transform(translations:)
      translations
    end

    def validate_schema
      valid_keys = %i[enabled prefix]

      schema.expect_required_keys(keys: valid_keys, path: [config_key])
      schema.reject_extraneous_keys(keys: valid_keys, path: [config_key])
      schema.expect_type(path: [config_key, :enabled], types: [TrueClass, FalseClass])
      schema.expect_type(path: nil, types: Hash)
      schema.expect_array_with_items(path: [:translations])
      schema.expect_array_with_items(path: nil)
      schema.reject("unexpected value") unless config[:prefix]
    end

    def setup
      I18nJS::Schema.root_keys << config_key
    end

    def after_export(files:)
      files.map(&:upcase)
    end

    def inspect_state
      # @type var key: Symbol
      key = config_key
      # @type var plugin_config: Hash[Symbol, untyped]
      plugin_config = config
      # @type var main_config: Hash[Symbol, untyped]
      main_config = self.main_config
      # @type var plugin_schema: I18nJS::Schema
      plugin_schema = schema
      # @type var enabled: bool?
      enabled = enabled?
      transformed = transform(translations: { en: { hello: "Hello" } })
      transformed.keys
      [key, plugin_config, main_config, plugin_schema, enabled]
    end
  end
end

I18nJS.register_plugin(I18nJS::SamplePlugin)
