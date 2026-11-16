require "rack/test"
require "stringio"

class RackTestEchoApp
  def call(env)
    return [302, { "content-type" => "text/plain", "location" => "/" }, []] if "/redirect" == env["PATH_INFO"]

    [200, { "content-type" => "text/plain", "set-cookie" => "token=abc; path=/" }, ["ok"]]
  end
end

class RackTestExample
  include Rack::Test::Methods

  def app
    RackTestEchoApp.new
  end

  def run
    # @type var response: Rack::MockResponse
    response = get("/")
    response.status.to_i
    response.body.bytesize

    get("/items", { "page" => 2, tag: ["a", "b"] }, { "HTTP_ACCEPT" => "application/json", xhr: true })
    post("/items", "name" => "foo")
    post("/items", "{}", { "CONTENT_TYPE" => "application/json" })
    put("/items/1", { name: "bar" })
    patch("/items/1", { name: "baz" })
    delete("/items/1")
    options("/items")
    head("/items")
    request("/items", { method: "GET" })
    custom_request("LINK", "/items", {}, {})
    custom_request(:purge, "/items")

    get("/redirect")
    follow_redirect!.status

    get("/block") do |res|
      res.status.to_i
    end

    header("Accept", "application/json")
    header("Accept", nil)
    env("rack.session", { "user_id" => 1 })
    env("rack.session", nil)
    authorize("user", "secret")
    basic_authorize("user", "secret")

    set_cookie("locale=ja")
    set_cookie(["a=1", "b=2"], URI.parse("https://example.org/"))

    # @type var jar: Rack::Test::CookieJar
    jar = clear_cookies
    jar["token"] = "abc"
    jar[:token]&.length
    jar["token"]&.length
    jar.to_hash.keys.first&.length
    jar.delete("token")

    # @type var last: Rack::Request
    last = last_request
    last.path_info.length
    last_response.body.length
    last_response.redirect?

    # @type var session: Rack::Test::Session
    session = current_session
    session.default_host.length
  end

  def with_other_session
    # @type var length: Integer
    length = with_session(:other) do |session|
      session.get("/").body.length
    end
    length
  end
end

session = Rack::Test::Session.new(RackTestEchoApp.new)
session = Rack::Test::Session.new(RackTestEchoApp.new, "www.example.com")
mock_session = Rack::MockSession.new(RackTestEchoApp.new)
mock_session.get("/")
session.default_host.upcase
session.cookie_jar["token"]
session.cookie_jar = Rack::Test::CookieJar.new
session.after_request { session.last_response.status }
session.restore_state { session.post("/", {}).status }
session.clear_cookies.to_hash
session.get("/")
session.last_request.request_method.upcase
session.get("/redirect")
session.follow_redirect!
Rack::Test::VERSION.length
Rack::Test::DEFAULT_HOST.length
Rack::Test::MULTIPART_BOUNDARY.length
Rack::Test::START_BOUNDARY.length
Rack::Test::END_BOUNDARY.length

begin
  session.last_request
rescue Rack::Test::Error => e
  e.message
end

# @type var file: Rack::Test::UploadedFile
file = Rack::Test::UploadedFile.new(__FILE__)
file = Rack::Test::UploadedFile.new(__FILE__, "text/markdown")
file = Rack::Test::UploadedFile.new(__FILE__, "application/octet-stream", true, original_filename: "readme.bin")
file = Rack::Test::UploadedFile.new(Pathname.new(__FILE__), "text/markdown", false)
# @type var io_file: Rack::Test::UploadedFile
io_file = Rack::Test::UploadedFile.new(StringIO.new("data"), "text/plain", original_filename: "data.txt")
io_file.original_filename.upcase
io_file.read
file.original_filename.upcase
file.content_type = "image/png"
file.content_type.upcase
file.path.length
file.local_path.length
file.tempfile.rewind
file.read&.length
file.rewind
file.size
file.eof?
file.binmode
Rack::Test::UploadedFile.new(__FILE__).append_to(+"")
session.post("/photos", { "photo" => file })
file.close
