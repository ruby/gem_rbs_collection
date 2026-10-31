Rails.application.routes.draw do
  resources :test1_models
end

Rails.application.configure do
  config.eager_load = false
end

Rails.application.config.middleware

module SampleApp
  class Application < Rails::Application
    config.load_defaults 8.1
  end
end


Rails.application.config.middleware.use(Rack::Head)
Rails.application.config.middleware.insert_before(Rack::Head, Rack::ETag, "max-age=0")
Rails.application.config.middleware.move_after(Rack::Head, Rack::ETag)

Rails.env.production?
Rails.env.to_sym
Rails.env = "test"
Rails.root.join("config", "database.yml").to_s
Rails.public_path.join("robots.txt")
Rails.configuration.eager_load
Rails.backtrace_cleaner.clean([])
Rails.error.handle { 1 }
Rails.groups(assets: %w[development test]).map(&:to_s)
Rails.version.split(".")
Rails.cache.fetch("key") { "value" }
Rails.autoloaders.main

Rails.application.initialized? || Rails.application.initialize!
Rails.application.credentials.read
Rails.application.secret_key_base.bytesize
Rails.application.key_generator.generate_key("salt")
Rails.application.message_verifier(:remember_me).generate("data")
Rails.application.deprecators[:railties]

# Methods whose block is optional
Rails.application.rake_tasks
SampleApp::Application.console

# Accessors defined with mattr_accessor and class_attribute, and delegated methods
Rails::Info.properties
Rails::Generators.namespace = SampleApp
Rails.initialized?
Rails.application.isolated?

# Class methods of the concerns included
Rails::Command.subclasses
Rails::Engine.set_callback(:load_seed, :before) { nil }

class SampleGeneratorTest < Rails::Generators::TestCase
  tests Rails::Generators::ModelGenerator
  destination "tmp"
  arguments %w[user]
end

class TrackingApplication < Rails::Application
  def self.inherited(base)
    super
    base.name
  end
end
