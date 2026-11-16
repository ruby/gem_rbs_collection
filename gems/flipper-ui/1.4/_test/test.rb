require "flipper-ui"
require "rack"

app = Flipper::UI.app(Flipper)
status, _headers, _body = app.call({ "REQUEST_METHOD" => "GET" })
status.to_i

Flipper::UI.app(Flipper, env_key: "flipper", rack_protection: { except: :http_origin })
Flipper::UI.app(nil, { rack_protection: { except: [:json_csrf, :remote_token] } })

Flipper::UI.app(Flipper) do |builder|
  builder.use Rack::Auth::Basic do |username, password|
    Rack::Utils.secure_compare(ENV.fetch("FLIPPER_USERNAME"), username) &&
      Rack::Utils.secure_compare(ENV.fetch("FLIPPER_PASSWORD"), password)
  end
end

# @type var descriptions: ^(Array[String]) -> Hash[String, String]
descriptions = lambda { |keys| keys.to_h { |key| [key, "description of #{key}"] } }

Flipper::UI.configure do |config|
  config.banner_text = "Staging"
  config.banner_text = nil
  config.banner_class = "warning"
  config.read_only = true
  config.application_href = "/"
  config.application_breadcrumb_href = "/admin"
  config.nav_items << { title: "Custom", href: "/custom" }
  config.feature_creation_enabled = false
  config.feature_removal_enabled = false
  config.fun = false
  config.cloud_recommendation = false
  config.version_check_enabled = false
  config.add_actor_placeholder = "user id"
  config.descriptions_source = descriptions
  config.actor_names_source = lambda { |keys| keys.to_h { |key| [key, key.upcase] } }
  config.show_feature_description_in_list = true
  config.actors_separator = ";"
  config.confirm_fully_enable = true
  config.confirm_disable = false
  config.disable_fully_enable = "Use the deploy pipeline instead."
  config.disable_fully_enable = true
  config.disable_fully_enable = nil
end

config = Flipper::UI.configuration
config.fun = false
config.banner_text&.upcase
config.banner_class.upcase
config.application_href&.upcase
config.application_breadcrumb_href&.upcase
config.nav_items.first&.fetch(:title)&.upcase
config.add_actor_placeholder.upcase
config.actors_separator.upcase
config.descriptions_source.is_a?(Proc)
config.actor_names_source.is_a?(Proc)
[
  config.read_only, config.feature_creation_enabled, config.feature_removal_enabled, config.fun,
  config.cloud_recommendation, config.version_check_enabled, config.show_feature_description_in_list,
  config.confirm_fully_enable, config.confirm_disable
].compact
config.disable_fully_enable.nil?
