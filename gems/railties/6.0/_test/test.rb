Rails.application.routes.draw do
  resources :test1_models
end

raise <<~HEREDOC unless Rails.application.routes.url_helpers.polymorphic_path(:new_test1_model) == '/test1_models/new'
  But it should work, since:
  >>> Rails.application.routes.method(:url_helpers).source_location
  ["/usr/local/bundle/gems/actionpack-6.0.6.1/lib/action_dispatch/routing/route_set.rb", 478]
HEREDOC

Rails.application.configure do
  config.eager_load = false
end

Rails.application.config.middleware

module SampleApp
  class Application < Rails::Application
    config.load_defaults 6.0
  end
end

