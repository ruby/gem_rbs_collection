require "omniauth-oauth2"

class ExampleOAuth2 < OmniAuth::Strategies::OAuth2
  option :name, "example"
  option :client_options, { site: "https://provider.example.com", authorize_url: "/oauth/authorize" }

  uid { raw_info["id"] }

  info do
    { name: raw_info["name"], email: raw_info["email"] }
  end

  extra do
    { raw_info: raw_info }
  end

  credentials do
    { "token" => String(access_token) }
  end

  def raw_info
    { "id" => "1", "name" => "Taro", "email" => "taro@example.com" }
  end

  def authorize_params
    params = super
    params[:prompt] = "consent"
    params
  end

  def token_params
    super.merge(audience: "https://api.example.com")
  end

  def oauth_client
    client
  end
end

# @type var build_strategy: ^() -> ExampleOAuth2
build_strategy = -> { ExampleOAuth2.new(nil, "id", "secret") }

# @type var handle_callback_error: ^(OmniAuth::Strategies::OAuth2::CallbackError) -> Array[String | Symbol | nil]
handle_callback_error = lambda do |error|
  error.error = :invalid_credentials
  error.error_reason = "denied"
  error.error_uri = "https://provider.example.com/errors"
  [error.error, error.error_reason, error.error_uri]
end

strategy = build_strategy.call
strategy.access_token = nil
strategy.access_token
strategy.oauth_client
strategy.token_params.keys

# @type var build_authorize_keys: ^() -> Array[untyped]
build_authorize_keys = -> { strategy.authorize_params.keys }
