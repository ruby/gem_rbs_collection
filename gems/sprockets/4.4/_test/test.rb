require "sprockets"
require "logger"
require "digest/sha2"

# @type var version: String
version = Sprockets::VERSION

Sprockets.register_mime_type "text/x-note", extensions: [".note"], charset: :unicode
Sprockets.register_preprocessor("text/x-note") { |input| String(input[:data]).upcase }

env = Sprockets::Environment.new(".") do |e|
  e.logger = Logger.new($stderr)
end
env.append_path "app/assets/javascripts"
env.prepend_path "vendor/assets"
# @type var paths: Array[String]
paths = env.paths
# @type var root: String
root = env.root
env.version = "2.0"
env.cache = Sprockets::Cache::FileStore.new("tmp/cache")
env.cache = Sprockets::Cache::MemoryStore.new
# @type var cache: Sprockets::Cache
cache = env.cache
# @type var digest_class: singleton(Digest::Class)
digest_class = env.digest_class
env.digest_class = Digest::SHA512
env.gzip = false
env.export_concurrent = false
env.css_compressor = :sass
env.js_compressor = nil
# @type var context_class: singleton(Sprockets::Context)
context_class = env.context_class

env.register_mime_type "text/x-custom", extensions: [".custom"]
env.register_transformer "text/x-custom", "application/javascript", ->(input) { { data: String(input[:data]) } }
env.register_postprocessor "application/javascript", ->(input) { nil }
env.register_bundle_processor("text/css") { |input| String(input[:data]) }
env.register_bundle_metadata_reducer "text/css", :selector_count, 0, :+
env.register_compressor "application/javascript", :mine, ->(input) { String(input[:data]).strip }
env.register_dependency_resolver("custom") { |_env, uri| uri.length }
env.add_dependency "custom:1"
env.register_pipeline(:none) { |_env, _type, _file_type| [] }
env.register_exporter "*/*", Sprockets::Exporters::ZlibExporter
env.unregister_exporter Sprockets::Exporters::ZlibExporter

# @type var asset: Sprockets::Asset?
asset = env["application.js"]
if asset
  # @type var logical_path: String
  logical_path = asset.logical_path
  # @type var digest_path: String
  digest_path = asset.digest_path
  # @type var source: String
  source = asset.to_s
  # @type var length: Integer
  length = asset.bytesize
  # @type var content_type: String?
  content_type = asset.content_type
  # @type var metadata: Hash[Symbol, untyped]
  metadata = asset.metadata
  asset.write_to("public/assets/#{digest_path}")
end

# @type var found: Sprockets::Asset
found = env.find_asset!("application.js")
env.find_asset("application", accept: "application/javascript", pipeline: :source)
# @type var linked: Enumerator[Sprockets::Asset, nil]
linked = env.find_all_linked_assets("application.js")

# @type var uri: String?
uri, _deps = env.resolve("application.js")

# @type var cached: Sprockets::CachedEnvironment
cached = env.cached
cached.find_asset("application.js")

# @type var response: [Integer, Hash[String, String], Sprockets::Asset | Array[String]]
response = env.call({ "REQUEST_METHOD" => "GET", "PATH_INFO" => "/application.js" })

manifest = Sprockets::Manifest.new(env, "public/assets", "public/assets/manifest.json")
# @type var compiled: Array[String]
compiled = manifest.compile("application.js", ["application.css"])
# @type var assets: Hash[String, String]
assets = manifest.assets
# @type var files: Hash[String, Hash[String, untyped]]
files = manifest.files
# @type var sources: Enumerator[String, void]
sources = manifest.find_sources("application.js")
manifest.clean(1, 600)
manifest.clobber
Sprockets::Manifest.new("public/assets/manifest.json").assets

class MyContext < Sprockets::Context
  def asset_path(path, options = {})
    "/assets/#{path}"
  end
end

begin
  env.find_asset!("missing.js")
rescue Sprockets::FileNotFound => e
  e.message
end
