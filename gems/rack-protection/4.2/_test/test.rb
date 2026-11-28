require "rack/protection"

class HelloApp
  def call(_env)
    [200, { "content-type" => "text/html" }, ["hello"]]
  end
end

app = HelloApp.new

# @type var stack: Rack::_Application
stack = Rack::Protection.new(app, use: %i[authenticity_token referrer_policy], except: [:remote_token])
stack.call({ "REQUEST_METHOD" => "GET", "PATH_INFO" => "/" })
Rack::Protection.new(app)
Rack::Protection::VERSION.split(".")

# @type var env: Rack::env
env = { "REQUEST_METHOD" => "POST", "PATH_INFO" => "/", "rack.session" => {} }

# @type var token: String
token = Rack::Protection::AuthenticityToken.token(env["rack.session"])
Rack::Protection::AuthenticityToken.token({}, path: "/form", method: :post)
Rack::Protection::AuthenticityToken.random_token.length

csrf = Rack::Protection::AuthenticityToken.new(app, authenticity_param: "_csrf", allow_if: ->(_env) { false })
csrf.mask_authenticity_token({}, path: "/form", method: "POST").length
csrf.accepts?(env.merge("HTTP_X_CSRF_TOKEN" => token))
Rack::Protection::AuthenticityToken.default_options(key: "csrf.token", authenticity_param: "_csrf")

# @type var response: Rack::response
response = csrf.call(env)
response[0].to_i

base = Rack::Protection::RemoteReferrer.new(app, reaction: :report, logging: false)
base.options[:reaction]
base.default_options[:status]
base.app
# @type var safe: bool
safe = base.safe?(env)
# @type var referrer: String?
referrer = base.referrer(env)
# @type var origin_header: String?
origin_header = base.origin(env)
# @type var has_session: bool
has_session = base.session?(env)
base.session(env)
base.empty_referrer_allowed?(env)
# @type var random: String
random = base.random_string
# @type var digest: String
digest = base.encrypt("value")
base.secure_compare("a", "b")
# @type var html: bool
html = base.html?({ "content-type" => "text/html; charset=utf-8" })
base.debug(env, "debug")
base.warn(env, "warn")
base.instrument(env)
base.report(env)
base.drop_session(env)
base.react(env)
# @type var denied: [Integer, Hash[String, String], Array[String]]
denied = base.deny(env)
denied[2].first
base.default_reaction(env)

# @type var policy: String
policy = Rack::Protection::ContentSecurityPolicy.new(app, script_src: "'self'", upgrade_insecure_requests: true).csp_policy
# @type var frame_options: String
frame_options = Rack::Protection::FrameOptions.new(app, frame_options: :deny).frame_options
# @type var hsts: String
hsts = Rack::Protection::StrictTransport.new(app, include_subdomains: true).strict_transport
Rack::Protection::ReferrerPolicy.new(app).call(env)
Rack::Protection::XSSHeader.new(app).call(env)
# @type var cleaned: String
cleaned = Rack::Protection::PathTraversal.new(app).cleanup("/foo/../bar")

tossing = Rack::Protection::CookieTossing.new(app, session_key: "rack.session")
# @type var bad: Array[String]
bad = tossing.bad_cookies({ "HTTP_COOKIE" => "rack.session=1; rack.session=2" })
bad.size
# @type var paths: Array[String]
paths = tossing.cookie_paths("/a/b")
tossing.empty_cookie("example.com", "/")[:expires].to_i
tossing.session_key.length
tossing.redirect(env)
tossing.remove_bad_cookies(Rack::Request.new(env), Rack::Response.new)

escaper = Rack::Protection::EscapedParams.new(app, escape: :html)
Rack::Protection::EscapedParams.escape_html("<b>").length
# @type var escaped: Hash[String, untyped]
escaped = escaper.escape_hash({ "a" => "<b>" })
escaped["a"]
# @type var escaped_string: String
escaped_string = escaper.escape("<b>")
escaper.escape(["<b>"]).first
escaper.escape(nil)
escaper.escape_string("<b>").length
escaper.handle({ "a" => "<b>" })

Rack::Protection::FormToken.new(app).accepts?(env)
Rack::Protection::RemoteToken.new(app).accepts?(env)
# @type var host_ok: bool
host_ok = Rack::Protection::HostAuthorization.new(app, permitted_hosts: ["example.com", ".example.org"]).accepts?(env)
origin = Rack::Protection::HttpOrigin.new(app, permitted_origins: ["https://example.com"])
# @type var base_url: String
base_url = origin.base_url(env)
origin.accepts?(env)
Rack::Protection::IPSpoofing.new(app).accepts?(env)
hijacking = Rack::Protection::SessionHijacking.new(app)
hijacking.accepts?(env)
hijacking.encode(nil).length

json = Rack::Protection::JsonCsrf.new(app)
# @type var json_response: Rack::response
json_response = json.call(env)
# @type var vector: bool
vector = json.has_vector?(Rack::Request.new(env), { "content-type" => "application/json" })
json.react_and_close(env, ["body"])
json.close_body(["body"])
json.react(env)
