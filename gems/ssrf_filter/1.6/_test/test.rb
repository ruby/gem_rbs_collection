require "ssrf_filter"
require "net/http"
require "uri"
require "ipaddr"

# These calls resolve host names and connect, so they are type checked but never run.
# @type var fetch_pages: ^() -> void
fetch_pages = -> do
  # @type var response: Net::HTTPResponse
  response = SsrfFilter.get("https://example.com/")
  response.code.to_i
  response.body

  SsrfFilter.get(URI("https://example.com/path"), max_redirects: 0, allow_unfollowed_redirects: true)

  SsrfFilter.get(
    "https://example.com/",
    scheme_whitelist: %w[https],
    max_redirects: 3,
    headers: { "Accept" => "text/css" },
    params: { "page" => 1, q: "a" },
    sensitive_headers: %w[authorization],
    on_cross_origin_redirect: :raise,
    http_options: { open_timeout: 5, read_timeout: 10.5, ignore_eof: false }
  )

  SsrfFilter.post(
    "https://example.com/hook",
    body: "a=1",
    headers: { "Content-Type" => "application/x-www-form-urlencoded" },
    request_proc: ->(request) { request["X-Request-Id"] = "abc" }
  )

  SsrfFilter.post("https://example.com/hook", resolver: ->(hostname) { SsrfFilter::DEFAULT_RESOLVER.call(hostname) })
  SsrfFilter.post("https://example.com/hook", resolver: proc { |hostname| SsrfFilter::DEFAULT_RESOLVER.call(hostname) })

  # @type var post_options: Hash[Symbol, untyped]
  post_options = {
    body: "{}",
    headers: { "Content-Type" => "application/json" },
    max_redirects: 5,
    allow_unfollowed_redirects: true,
    http_options: { open_timeout: 5, read_timeout: 5 }
  }
  add_trace_header = ->(request) { request["X-Trace"] = "1" } #: ^(Net::HTTPGenericRequest) -> untyped
  post_options[:request_proc] = add_trace_header
  SsrfFilter.post("https://example.com/hook", post_options)

  SsrfFilter.put("https://example.com/item", body: "x")
  SsrfFilter.delete("https://example.com/item")
  SsrfFilter.patch("https://example.com/item", body: "x")
  SsrfFilter.head("https://example.com/item")

  SsrfFilter.get("https://example.com/big") do |res|
    # @type var status: String
    status = res.code
    res["content-type"]&.downcase
    res.each_header { |name, value| name + value }
    res.read_body
  end

  begin
    SsrfFilter.get("http://localhost/")
  rescue SsrfFilter::InvalidUriScheme, SsrfFilter::PrivateIPAddress, SsrfFilter::UnresolvedHostname => e
    # @type var error: SsrfFilter::Error
    error = e
    error.message.upcase
  rescue SsrfFilter::TooManyRedirects, SsrfFilter::CRLFInjection, SsrfFilter::CredentialLeakage
    nil
  rescue SsrfFilter::Error => e
    e.message
  end

  # @type var addresses: Array[IPAddr]
  addresses = SsrfFilter::DEFAULT_RESOLVER.call("example.com")
  addresses.select(&:ipv4?)
end

# @type var blacklist: Array[IPAddr]
blacklist = SsrfFilter::IPV4_BLACKLIST
blacklist.any? { |range| range.include?(IPAddr.new("10.0.0.1")) }
SsrfFilter::IPV6_BLACKLIST.map(&:to_s)
SsrfFilter::NAT64_LOCAL_PREFIX.include?(IPAddr.new("64:ff9b:1::1"))

# @type var schemes: Array[String]
schemes = SsrfFilter::DEFAULT_SCHEME_WHITELIST
schemes.include?("http")
SsrfFilter::DEFAULT_ALLOW_UNFOLLOWED_REDIRECTS.!
SsrfFilter::DEFAULT_MAX_REDIRECTS + 1
SsrfFilter::DEFAULT_SENSITIVE_HEADERS.first
SsrfFilter::DEFAULT_ON_CROSS_ORIGIN_REDIRECT == :strip
SsrfFilter::VERSION.upcase

# @type var request_class: singleton(Net::HTTPRequest)
request_class = SsrfFilter::VERB_MAP.fetch(:get)
request_class.new(URI("https://example.com/")).path
SsrfFilter::VERB_MAP.key?(:post)
