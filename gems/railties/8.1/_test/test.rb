Rails.application.routes.draw do
  resources :test1_models
end

Rails.application.configure do
  config.eager_load = false
end

Rails.application.config.middleware

module SampleApp
  class Application < Rails::Application
    config.load_defaults 6.0
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
