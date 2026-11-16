require "omniauth-google-oauth2"
require "omniauth/google_oauth2/version"

version = OmniAuth::GoogleOauth2::VERSION
version.upcase

scope = OmniAuth::Strategies::GoogleOauth2::DEFAULT_SCOPE
scope.split(",")

OmniAuth::Strategies::GoogleOauth2::ALLOWED_ISSUERS.first&.upcase
OmniAuth::Strategies::GoogleOauth2::BASE_SCOPE_URL.upcase
OmniAuth::Strategies::GoogleOauth2::BASE_SCOPES.first&.upcase
OmniAuth::Strategies::GoogleOauth2::USER_INFO_URL.upcase
OmniAuth::Strategies::GoogleOauth2::AUTHORIZE_OPTIONS.first&.to_s

# Subclass that adds options, as a dedicated strategy for another Google API
class CalendarStrategy < OmniAuth::Strategies::GoogleOauth2
  option :name, "calendar"
  option :scope, "email,profile,https://www.googleapis.com/auth/calendar.readonly"
  option :prompt, "select_account"
  option :access_type, "online"
  option :hd, "example.com"

  def authorize_params
    params = super
    params[:login_hint] = "user@example.com"
    params
  end

  def request_phase
    return redirect("/login") unless on_request_path?

    super
  end

  def callback_phase
    return fail!(:unavailable) if session["blocked"]

    super
  end

  def picture
    # @type var raw: Hash[String, untyped]
    raw = raw_info
    raw["picture"]
  end
end

# Building the strategy directly with a client id and secret
# @type var inspect_strategy: ^() -> String?
inspect_strategy = lambda do
  strategy = OmniAuth::Strategies::GoogleOauth2.new(nil, "client-id", "client-secret")
  # @type var params: Hash[untyped, untyped]
  params = strategy.authorize_params
  params.keys
  info = strategy.raw_info
  String(info["email"])
end
