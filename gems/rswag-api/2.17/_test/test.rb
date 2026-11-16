require "rails"
require "rswag/api"

Rswag::Api.configure do |config|
  config.openapi_root = "/srv/app/swagger"
  config.swagger_filter = lambda { |swagger, env|
    swagger["host"] = env["HTTP_HOST"]
  }
  config.swagger_headers = { "Content-Type" => "application/json; charset=UTF-8" }
end

Rswag::Api.configure do |config|
  config.swagger_filter = proc { |_swagger, _env| nil }
  config.swagger_filter = nil
  config.openapi_root = nil
  config.swagger_headers = nil
end

# @type var api_config: Rswag::Api::Configuration
api_config = Rswag::Api.config
# @type var root: String?
root = api_config.openapi_root
# @type var headers: Hash[String, String]?
headers = api_config.swagger_headers
# @type var filter: (^(Hash[String, untyped], Hash[String, untyped]) -> untyped | Proc)?
filter = api_config.swagger_filter

# @type var deprecator: ActiveSupport::Deprecation
deprecator = Rswag::Api.deprecator

# @type var engine: singleton(Rswag::Api::Engine)
engine = Rswag::Api::Engine
engine.engine_name
