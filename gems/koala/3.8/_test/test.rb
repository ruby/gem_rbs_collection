require "koala"

Koala.configure do |config|
  config.access_token = "token"
  config.app_secret = "secret"
  config.app_id = "1234"
  config.app_access_token = "app-token"
  config.api_version = "v19.0"
  config.oauth_callback_url = "https://example.com/callback"
  config.preserve_form_arguments = true
  config.graph_server = "graph.facebook.com"
  config.dialog_host = "www.facebook.com"
  config.mask_tokens = true
  config.rate_limit_hook = ->(limits) { Koala::Utils.logger.info("rate limited") }
  config.host_path_matcher = /\.facebook/
  config.video_replace = "-video.facebook"
  config.beta_replace = ".beta.facebook"
end

config = Koala.config
# @type var api_version: String?
api_version = config.api_version
# @type var app_id: String | Integer | nil
app_id = config.app_id
# @type var access_token: String?
access_token = config.access_token
# @type var app_secret: String?
app_secret = config.app_secret
# @type var app_access_token: String?
app_access_token = config.app_access_token
# @type var callback: String?
callback = config.oauth_callback_url
# @type var graph_server: String
graph_server = config.graph_server
# @type var dialog_host: String
dialog_host = config.dialog_host
config.preserve_form_arguments.nil?
config.mask_tokens.nil?
config.rate_limit_hook.nil?
config.host_path_matcher.source
config.video_replace.upcase
config.beta_replace.upcase
Koala.config.api_version = "v20.0"
Koala.config.rate_limit_hook = proc { |limits| Koala::Utils.logger.info("rate limited #{limits}") }

Koala::Utils.logger = Logger.new($stdout)
Koala::Utils.logger.error("message")
Koala::VERSION.upcase

api = Koala::Facebook::API.new("page-token")
signed_api = Koala::Facebook::API.new("page-token", "secret", ->(limits) { Koala::Utils.logger.info("rate limited") })
Koala::Facebook::API.new
api.access_token&.upcase
api.app_secret&.upcase
api.rate_limit_hook.nil?

# These calls reach the Graph API, so they are only defined here.
# @type var call_graph_api: ^() -> void
call_graph_api = lambda do
  api.get_object("me")
  api.get_object(123, { fields: "first_name,last_name", "locale" => "ja" }, { request: { timeout: 10 } })
  # @type var name: String
  name = api.get_object("me", fields: "name") do |result|
    case result
    when Hash then String(result["name"])
    else ""
    end
  end
  api.get_object_metadata("me") do |metadata|
    case metadata
    when Hash then metadata.keys
    else []
    end
  end
  api.get_objects(["me", "arsduo"], fields: "id")
  api.get_objects("me,arsduo")
  api.put_object("me", "feed", message: "hi")
  api.delete_object("1234")

  # @type var feed: Koala::Facebook::API::GraphCollection
  feed = api.get_connections("me", "feed")
  api.get_connection("me", "photos", { limit: 5 }, { http_component: :headers })
  api.put_connections("me", "feed", message: "I am writing on my wall!")
  api.delete_connections("me", "feed")
  api.get_picture_data("me", type: :large)
  api.put_picture("https://example.com/image.jpg", { message: "photo" }, "me", { beta: true })
  api.put_picture("/tmp/image.jpg", "image/jpeg", { message: "photo" }, 1234)
  api.put_picture(File.open("/tmp/image.jpg"))
  api.put_video("/tmp/movie.mp4", "video/mp4", { description: "video" })
  api.put_video("https://example.com/movie.mp4")
  api.put_wall_post("Hello")
  api.put_wall_post("Hello", { name: "link name", link: "https://example.com" }, "page-id", { http_component: :response })
  api.put_comment("1234_5678", "nice post")
  api.put_like("1234_5678")
  api.delete_like("1234_5678")
  api.search("coffee", type: "place", center: "37.76,-122.427", distance: 1000)
  # @type var page_token: String?
  page_token = api.get_page_access_token("page-id")
  api.get_page_access_token("page-id", {}, {}) { |token| token.to_s }
  api.debug_token("input-token")
  api.set_app_restrictions("1234", { "age_min" => 21 }, { access_token: "app-token" })
  api.graph_call("me/feed", { limit: 1 }, "post", { http_component: :response })
  # @type var response: Koala::HTTPService::Response
  response = api.graph_call("me", {}, "get", { http_component: :response })
  response.status.zero?
  response.body.upcase
  response.headers.keys
  response.data

  # @type var first_page: Koala::Facebook::API::GraphCollection
  first_page = api.get_connections("me", "feed")
  first_page.size
  first_page.first
  # @type var paging: Hash[String, String]?
  paging = first_page.paging
  # @type var summary: Hash[String, untyped]?
  summary = first_page.summary
  first_page.api.access_token
  first_page.raw_response.keys
  first_page.headers.keys
  # @type var next_collection: Koala::Facebook::API::GraphCollection?
  next_collection = first_page.next_page
  first_page.next_page(since: 1_379_593_891)
  first_page.previous_page
  first_page.previous_page("limit" => 5)
  # @type var next_params: [String, Hash[String | Symbol, String]]?
  next_params = first_page.next_page_params
  first_page.previous_page_params
  if next_params
    api.get_page(next_params)
  end
  # @type var parsed: [String, Hash[String | Symbol, String]]
  parsed = Koala::Facebook::API::GraphCollection.parse_page_url("https://graph.facebook.com/me/feed?limit=5")
  parsed[0].upcase
  parsed[1].keys

  # @type var batch_results: Array[untyped]
  batch_results = api.batch do |batch_api|
    # @type var batch_api: Koala::Facebook::GraphBatchAPI
    batch_api.get_object("me")
    batch_api.put_wall_post("Making a post in a batch.")
    batch_api.get_connections("me", "photos") do |photos|
      case photos
      when Array then photos.size
      else 0
      end
    end
  end
  # @type var batch_client: Koala::Facebook::GraphBatchAPI
  batch_client = api.batch({ http_component: :response })
  batch_client.get_object("me", {}, { access_token: "other" })
  batch_client.graph_call("me", {}, "get").nil?
  batch_client.original_api.access_token
  # @type var executed: Array[untyped]
  executed = batch_client.execute
  batch_client.execute({ http_component: :status })
  # @type var base_api: Koala::Facebook::API
  base_api = batch_client
  base_api.access_token
  batch_results.size
  executed.size

  oauth = Koala::Facebook::OAuth.new("1234", "secret", "https://example.com/callback")
  Koala::Facebook::OAuth.new("1234", "secret")
  Koala::Facebook::OAuth.new(1234)
  Koala::Facebook::OAuth.new
  oauth.app_id
  oauth.app_secret&.upcase
  oauth.oauth_callback_url&.upcase
  # @type var cookie_info: Hash[String, untyped]?
  cookie_info = oauth.get_user_info_from_cookies({ "fbsr_1234" => "signed" })
  oauth.get_user_info_from_cookie({ "fbs_1234" => "unsigned" })
  # @type var code_url: String
  code_url = oauth.url_for_oauth_code(permissions: "email,user_posts", state: Random.urandom(16).unpack1("H*").to_s)
  oauth.url_for_oauth_code(permissions: ["email", "publish_actions"], callback: "https://example.com")
  # @type var token_url: String
  token_url = oauth.url_for_access_token("code", redirect_uri: "https://example.com")
  # @type var dialog_url: String
  dialog_url = oauth.url_for_dialog("feed", link: "https://example.com")
  # @type var client_code: String
  client_code = oauth.generate_client_code("access-token")
  # @type var token_info: Hash[String, untyped]
  token_info = oauth.get_access_token_info("code", redirect_uri: "https://example.com")
  # @type var user_token: String?
  user_token = oauth.get_access_token("code")
  oauth.get_app_access_token_info.keys
  # @type var app_token: String?
  app_token = oauth.get_app_access_token(use_ssl: true)
  oauth.exchange_access_token_info("short-lived")["access_token"]
  # @type var long_lived: String?
  long_lived = oauth.exchange_access_token("short-lived")
  # @type var signed: Hash[String, untyped]
  signed = oauth.parse_signed_request("signature.payload")
  signed["user_id"]

  updates = Koala::Facebook::RealtimeUpdates.new(app_id: "1234", secret: "secret")
  Koala::Facebook::RealtimeUpdates.new
  updates.app_id
  updates.secret&.upcase
  # @type var updates_token: String
  updates_token = updates.app_access_token
  # @type var updates_api: Koala::Facebook::API
  updates_api = updates.api
  updates.subscribe("user", "first_name, last_name", "https://example.com/hook", "verify")
  updates.subscribe("user", ["first_name", "email"], "https://example.com/hook", nil, { use_ssl: true })
  updates.unsubscribe("user")
  updates.unsubscribe
  updates.list_subscriptions
  # @type var challenge: String | false
  challenge = Koala::Facebook::RealtimeUpdates.meet_challenge({ "hub.mode" => "subscribe" }, "verify")
  Koala::Facebook::RealtimeUpdates.meet_challenge({ "hub.mode" => "subscribe" }) { |token| token == "verify" }
  # @type var valid: bool?
  valid = updates.validate_update("{}", { "X-Hub-Signature" => "sha1=abc" })

  begin
    api.get_object("me")
  rescue Koala::Facebook::AuthenticationError => e
    # @type var auth_error: Koala::Facebook::ClientError
    auth_error = e
    auth_error.fb_error_code
  rescue Koala::Facebook::ClientError, Koala::Facebook::ServerError => e
    # @type var api_error: Koala::Facebook::APIError
    api_error = e
    # @type var status: Integer?
    status = api_error.http_status
    # @type var response_body: String
    response_body = api_error.response_body
    # @type var error_type: String?
    error_type = api_error.fb_error_type
    # @type var error_code: Integer?
    error_code = api_error.fb_error_code
    # @type var error_subcode: Integer?
    error_subcode = api_error.fb_error_subcode
    # @type var error_message: String?
    error_message = api_error.fb_error_message
    api_error.fb_error_user_msg&.upcase
    api_error.fb_error_user_title&.upcase
    api_error.fb_error_trace_id&.upcase
    api_error.fb_error_debug_trace_id&.upcase
    api_error.fb_error_debug&.upcase
    api_error.fb_error_rev&.upcase
    api_error.fb_buc_usage
    api_error.fb_ada_usage
    api_error.fb_app_usage
    api_error.message.upcase
  rescue Koala::Facebook::BadFacebookResponse, Koala::Facebook::OAuthTokenRequestError => e
    e.http_status
  rescue Koala::Facebook::OAuthSignatureError, Koala::Facebook::AppSecretNotDefinedError, Koala::KoalaError => e
    e.message
  end
end

error = Koala::Facebook::APIError.new(400, '{"error": {"message": "bad"}}')
Koala::Facebook::APIError.new(nil, nil, "Delete requires an access token")
Koala::Facebook::ClientError.new(400, "", { "message" => "bad", "code" => 190 })
error.fb_error_message = "changed"
error.http_status = 401
error.response_body = "{}"
error.fb_error_type = "OAuthException"
error.fb_error_code = 190
error.fb_error_subcode = 460
error.fb_error_user_msg = "msg"
error.fb_error_user_title = "title"
error.fb_error_trace_id = "trace"
error.fb_error_debug_trace_id = "trace"
error.fb_error_debug = "debug"
error.fb_error_rev = "rev"
error.fb_buc_usage = {}
error.fb_ada_usage = {}
error.fb_app_usage = {}

# @type var batch: Koala::Facebook::GraphBatchAPI
batch = Koala::Facebook::GraphBatchAPI.new(api)
batch.original_api.access_token
