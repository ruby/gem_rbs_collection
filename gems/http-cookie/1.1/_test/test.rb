require "http-cookie"
require "stringio"
require "uri"

cookie = HTTP::Cookie.new("uid", "a12345", domain: "example.org", path: "/", for_domain: true)
cookie.name.upcase
cookie.value.upcase
cookie.domain&.upcase
cookie.path&.upcase
cookie.for_domain?
cookie.secure = true
cookie.httponly = false
cookie.max_age = 3600
cookie.max_age&.succ
cookie.expires = Time.now + 60
cookie.expires&.year
cookie.expired?
cookie.session?
cookie.cookie_value.upcase
cookie.set_cookie_value.upcase
cookie.to_s.upcase
cookie.to_h[:name]
cookie.valid_for_uri?("http://example.org/")
cookie.acceptable_from_uri?(URI("http://www.example.org/"))
cookie.expire!.expired?

expired = HTTP::Cookie.new("name" => "sid", "value" => "x", "Domain" => "example.org")
expired.origin = "http://example.org/path/"
expired.origin&.host
(cookie <=> expired).zero?

cookies = HTTP::Cookie.parse("a=b; Domain=example.com; Path=/, c=d", "http://example.com/", logger: nil) do |c|
  c.name.upcase
end
HTTP::Cookie.cookie_value(cookies).upcase
HTTP::Cookie.cookie_value_to_hash("a=b; c=d")["a"]&.upcase
HTTP::Cookie.path_match?("/admin/", "/admin/index")

jar = HTTP::CookieJar.new
jar.add(cookie)
jar << expired
jar.parse("x=y; Path=/", URI("http://example.org/")) { |c| c.name == "x" }
jar.cookies("http://example.org/").map(&:name)
jar.each("http://example.org/") { |c| c.value.upcase }
jar.each.map(&:name)
jar.empty?
jar.count

io = StringIO.new
jar.save(io, :cookiestxt, session: true)
jar.save(io, format: :yaml)
jar.save("cookies.txt", HTTP::CookieJar::CookiestxtSaver.new(header: nil), { session: true })
io.rewind
HTTP::CookieJar.new(store: :hash).load(io, :cookiestxt)
jar.delete(cookie).cleanup(true).clear

store = HTTP::CookieJar::HashStore.new(gc_threshold: 10)
store.add(cookie).each { |c| c.name.upcase }
HTTP::CookieJar.new(store: store).store.empty?
HTTP::CookieJar::AbstractStore.implementation(:hash).new
HTTP::CookieJar::AbstractSaver.implementation(:yaml).new(session: true)
