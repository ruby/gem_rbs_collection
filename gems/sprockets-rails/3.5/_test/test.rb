require "sprockets/railtie"

class TestView < ActionView::Base
  include Sprockets::Rails::Helper
end

Sprockets::Rails::VERSION.upcase
Sprockets::Rails.deprecator.warn("deprecated")

view = TestView.new(ActionView::LookupContext.new([]), {}, nil)

# @type var path: String
path = view.compute_asset_path("application.js", type: :javascript)
path.upcase

# @type var resolved: String?
resolved = view.resolve_asset_path("application.js")
resolved = view.resolve_asset_path("application.js", true)
resolved&.upcase

# @type var digest_path: String?
digest_path = view.asset_digest_path("application.js")
digest_path = view.asset_digest_path("application.js", debug: true)
digest_path&.upcase

# @type var integrity: String?
integrity = view.asset_integrity("application.js")
integrity = view.asset_integrity(:application, type: :javascript)
integrity&.upcase

# @type var tags: ActiveSupport::SafeBuffer
tags = view.javascript_include_tag("application", :vendor, "data-turbo-track": "reload", integrity: true)
tags = view.stylesheet_link_tag("application", media: "all", debug: false)
tags = view.stylesheet_link_tag("application", media: "all", "data-turbolinks-track" => true)
tags = view.javascript_include_tag("application", { "defer" => true })
tags.html_safe?

view.using_sprockets4?

error = Sprockets::Rails::Helper::AssetNotPrecompiledError.new("foo.js")
error.message.upcase

# @type var helper_error: StandardError
helper_error = Sprockets::Rails::Helper::AssetNotFound.new("missing")
helper_error = Sprockets::Rails::Helper::AssetNotPrecompiled.new("missing")
helper_error = Sprockets::Rails::LoggerSilenceError.new("no silence")
helper_error = Sprockets::Railtie::ManifestNeededError.new
helper_error.message

# @type var app: ^(Rack::env) -> Rack::response
app = ->(_env) { [200, { "content-type" => "text/plain" }, ["ok"]] }
quiet = Sprockets::Rails::QuietAssets.new(app)
_status, _headers, _body = quiet.call({ "PATH_INFO" => "/assets/application.js" })

# @type var input: Hash[Symbol, untyped]
input = { environment: Rails.application.assets, data: "a { background: url(foo.png) }", filename: "a.css", metadata: {} }
# @type var processed: Hash[Symbol, untyped]
processed = Sprockets::Rails::AssetUrlProcessor.call(input)
processed[:data]

# @type var mapped: { data: String }
mapped = Sprockets::Rails::SourcemappingUrlProcessor.call({ environment: Rails.application.assets, data: "//# sourceMappingURL=foo.js.map", name: "foo", filename: "foo.js" })
mapped[:data].upcase

Sprockets::Rails::AssetUrlProcessor::REGEX.match?("url(foo.png)")
Sprockets::Rails::Helper::VIEW_ACCESSORS.map(&:to_s)

# @type var loose: bool
loose = Sprockets::Railtie::LOOSE_APP_ASSETS.call("logo.png", "/app/assets/images/logo.png")

application = Rails.application
application.assets_manifest = nil
# @type var app_manifest: Sprockets::Manifest?
app_manifest = application.assets_manifest
app_manifest&.files
# @type var precompiled: bool
precompiled = application.asset_precompiled?("application.js")
# @type var precompiled_assets: Set[String]
precompiled_assets = application.precompiled_assets
precompiled_assets = application.precompiled_assets(true)

# @type var manifest: Sprockets::Manifest
manifest = Sprockets::Railtie.build_manifest(application)
manifest.assets
# @type var railtie: Sprockets::Railtie
railtie = Sprockets::Railtie.instance
# @type var env: Sprockets::Environment | Sprockets::CachedEnvironment
env = railtie.build_environment(application)
env = railtie.build_environment(application, true)
env = Sprockets::Railtie.build_environment(application)
env.find_asset("application.js")
