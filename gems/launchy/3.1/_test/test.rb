require "launchy"

# @type var result: untyped
result = Launchy.open("https://example.com", dry_run: true)
Launchy.open("https://example.com", { dry_run: true, host_os: "linux", application: "browser" })
Launchy.open("https://example.com") do |error|
  warn error.message
end

# @type var app: singleton(Launchy::Application)
app = Launchy.app_for_uri_string("https://example.com")
app = Launchy.app_for_uri(Addressable::URI.parse("https://example.com"))

# @type var named: singleton(Launchy::Application)?
named = Launchy.app_for_name("browser")

# @type var uri: Addressable::URI
uri = Launchy.string_to_uri("example.com")

Launchy.debug = true
Launchy.dry_run = "true"
Launchy.application = "browser"
Launchy.host_os = "darwin"
Launchy.path = "/usr/bin:/bin"

# @type var debug: bool
debug = Launchy.debug?

# @type var host_os: String?
host_os = Launchy.host_os

Launchy.log "message"
Launchy.reset_global_options

# @type var executable: String?
executable = Launchy::Application.find_executable("ruby")

browser = Launchy::Application::Browser.new
# @type var cmd_and_args: [String, Array[String]]
cmd_and_args = browser.cmd_and_args("https://example.com")
browser.open(uri, { dry_run: true })

# @type var family: Launchy::Detect::HostOsFamily
family = Launchy::Detect::HostOsFamily.detect("linux")
family.nix?

# @type var desktop: singleton(Launchy::Detect::NixDesktopEnvironment)
desktop = Launchy::Detect::NixDesktopEnvironment.detect
desktop.browsers.each { |argv| argv.valid? }

# @type var os: String
os = Launchy::Detect::HostOs.new.to_s

begin
  Launchy.open("unknown://thing")
rescue Launchy::Error => e
  e.message
end

# @type var version: String
version = Launchy::VERSION
Launchy::Version.to_a
