require "rails"
require "rswag/ui"

Rswag::Ui.configure do |config|
  config.openapi_endpoint "/api-docs/v1/swagger.yaml", "API V1 Docs"
  config.swagger_endpoint "/api-docs/v0/swagger.yaml", "API V0 Docs"
  config.basic_auth_enabled = ENV.key?("SWAGGER_USER")
  config.basic_auth_credentials ENV.fetch("SWAGGER_USER", ""), ENV.fetch("SWAGGER_PASSWORD", "")
  config.config_object[:deepLinking] = true
  config.oauth_config_object[:clientId] = ENV.fetch("SWAGGER_CLIENT_ID", "")
  config.basic_auth_enabled = config.basic_auth_enabled ? true : false
end

# @type var ui_config: Rswag::Ui::Configuration
ui_config = Rswag::Ui.config
# @type var swagger_ui_options: Hash[Symbol, untyped]
swagger_ui_options = ui_config.config_object
swagger_ui_options.fetch(:urls)
swagger_ui_options.fetch(:deepLinking)
# @type var oauth: Hash[Symbol, untyped]
oauth = ui_config.oauth_config_object
oauth.keys
ui_config.config_object = { urls: [] }
ui_config.oauth_config_object = {}

# @type var deprecator: ActiveSupport::Deprecation
deprecator = Rswag::Ui.deprecator

# @type var engine: singleton(Rswag::Ui::Engine)
engine = Rswag::Ui::Engine
engine.engine_name
