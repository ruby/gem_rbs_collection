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

