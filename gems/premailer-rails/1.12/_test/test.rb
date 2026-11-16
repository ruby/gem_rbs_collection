require "premailer/rails"

# Configuration
Premailer::Rails.config[:generate_text_part] = false
Premailer::Rails.config.merge!(remove_ids: true, adapter: :nokogiri, strategies: [:filesystem, :network])
# @type var config: Hash[Symbol, untyped]
config = Premailer::Rails.config
config.fetch(:strategies)
Premailer::Rails.config = { strategies: [:filesystem] }

Premailer::Rails.register_interceptors
# @type var version: String
version = Premailer::Rails::VERSION
version.upcase

# Hook
message = Mail.new
# @type var processed: Mail::Message
processed = Premailer::Rails::Hook.perform(message)
Premailer::Rails::Hook.delivering_email(message)
Premailer::Rails::Hook.previewing_email(message)
processed.subject

# Custom loader (anything responding to load can be listed as a strategy)
module CustomStylesheetStrategy
  def self.load(url)
    url.empty? ? nil : "body { color: red; }"
  end
end
Premailer::Rails.config[:strategies] = [CustomStylesheetStrategy]

# CustomizedPremailer
Premailer::Rails::CustomizedPremailer.superclass

# CustomizedPremailer always reads its argument as an HTML string
premailer = Premailer::Rails::CustomizedPremailer.new("<p>Hello</p>")
# @type var html: String
html = premailer.to_inline_css
# @type var plaintext: String
plaintext = premailer.to_plain_text
[html.upcase, plaintext.upcase]

# CSSHelper.cache accepts anything responding to [] and []=
class CustomStylesheetCache
  def initialize
    @store = {}
  end

  def [](url)
    @store[url]
  end

  def []=(url, css)
    @store[url] = css unless css.empty?
  end
end
Premailer::Rails::CSSHelper.cache = CustomStylesheetCache.new
Premailer::Rails::CSSHelper.cache["/a.css"] = "a { color: red; }"
# @type var cached: String?
cached = Premailer::Rails::CSSHelper.cache["/a.css"]
cached&.upcase

# CSSLoaders
# @type var uri: URI::Generic?
uri = Premailer::Rails::CSSLoaders::NetworkLoader.uri_for_url("https://assets.example.com/a.css")
uri&.host
Premailer::Rails::CSSLoaders::FileSystemLoader.file_name("/a.css").upcase
