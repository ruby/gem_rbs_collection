require "http_accept_language"
require "action_controller"

class ApplicationController < ActionController::Base
  include HttpAcceptLanguage::AutoLocale

  def index
    parser = http_accept_language

    # @type var languages: Array[String]
    languages = parser.user_preferred_languages
    languages.first&.upcase

    # @type var preferred: String?
    preferred = parser.preferred_language_from(%w[en en-US nl-BE])
    preferred&.upcase

    # @type var compatible: Symbol?
    compatible = parser.compatible_language_from([:en, :nl])
    compatible&.to_proc

    # @type var region_compatible: String?
    region_compatible = parser.language_region_compatible_from([:en, :"nl-BE"])
    region_compatible&.upcase

    # @type var sanitized: Array[String]
    sanitized = parser.sanitize_available_locales(["ja_JP-x1", :"en-US-x4"])
    sanitized.first&.upcase

    parser.user_preferred_languages = ["en-GB"]
  end
end

class ApiController < ActionController::API
  def show
    http_accept_language.preferred_language_from(%w[en nl])
  end
end

parser = HttpAcceptLanguage::Parser.new("nl-NL,nl;q=0.9,en;q=0.8")
parser.header = "en-US"
parser.header&.upcase
parser.user_preferred_languages.first&.upcase
HttpAcceptLanguage::Parser.new(nil).user_preferred_languages.size

class PlainApp
  def call(_env)
    [200, { "content-type" => "text/plain" }, ["ok"]]
  end
end

middleware = HttpAcceptLanguage::Middleware.new(PlainApp.new)
status, = middleware.call({ "HTTP_ACCEPT_LANGUAGE" => "en" })
status
