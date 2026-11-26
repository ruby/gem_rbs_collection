require "http-cookie"
require "stringio"
require "uri"

# @type var cookie: HTTP::Cookie
cookie = HTTP::Cookie.new("uid", "a12345", domain: "example.org", path: "/", for_domain: true)
expired = HTTP::Cookie.new("name" => "sid", "value" => "x", "Domain" => "example.org")

# @type var str: String
str = cookie.name
str = cookie.value
str = cookie.cookie_value
str = cookie.set_cookie_value
str = cookie.to_s

# @type var maybe_str: String?
maybe_str = cookie.domain
maybe_str = cookie.path

# @type var bool: bool
bool = cookie.for_domain?
bool = cookie.expired?
bool = cookie.session?
bool = cookie.valid_for_uri?("http://example.org/")
bool = cookie.acceptable_from_uri?(URI("http://www.example.org/"))
bool = HTTP::Cookie.path_match?("/admin/", "/admin/index")

cookie.secure = true
cookie.httponly = false
cookie.max_age = 3600
cookie.expires = Time.now + 60

# @type var max_age: Integer?
max_age = cookie.max_age

# @type var expires: Time?
expires = cookie.expires

cookie = cookie.expire!

expired.origin = "http://example.org/path/"
# @type var origin: URI::Generic?
origin = expired.origin

# @type var order: Integer
order = cookie <=> expired

# @type var attrs: Hash[Symbol, untyped]
attrs = cookie.to_h

# @type var cookies: Array[HTTP::Cookie]
cookies = HTTP::Cookie.parse("a=b; Domain=example.com; Path=/, c=d", "http://example.com/", logger: nil) do |c|
  c.name.upcase
end
str = HTTP::Cookie.cookie_value(cookies)

# @type var pairs: Hash[String, String]
pairs = HTTP::Cookie.cookie_value_to_hash("a=b; c=d")

# @type var jar: HTTP::CookieJar
jar = HTTP::CookieJar.new
jar = jar.add(cookie)
jar = jar << expired
cookies = jar.parse("x=y; Path=/", URI("http://example.org/")) { |c| c.name == "x" }
cookies = jar.cookies("http://example.org/")
jar = jar.each("http://example.org/") { |c| c.value.upcase }

# @type var enum: Enumerator[HTTP::Cookie, HTTP::CookieJar]
enum = jar.each
bool = jar.empty?

io = StringIO.new
jar = jar.save(io, :cookiestxt, session: true)
jar = jar.save(io, format: :yaml)
jar = jar.save("cookies.txt", HTTP::CookieJar::CookiestxtSaver.new(header: nil), { session: true })
io.rewind
jar = HTTP::CookieJar.new(store: :hash).load(io, :cookiestxt)
jar = jar.delete(cookie).cleanup(true).clear

# @type var store: HTTP::CookieJar::HashStore
store = HTTP::CookieJar::HashStore.new(gc_threshold: 10)
store = store.add(cookie).each { |c| c.name.upcase }
bool = HTTP::CookieJar.new(store: store).store.empty?

# @type var store_class: singleton(HTTP::CookieJar::AbstractStore)
store_class = HTTP::CookieJar::AbstractStore.implementation(:hash)

# @type var saver_class: singleton(HTTP::CookieJar::AbstractSaver)
saver_class = HTTP::CookieJar::AbstractSaver.implementation(:yaml)
saver_class.new(session: true)
