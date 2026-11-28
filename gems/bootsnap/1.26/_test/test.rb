require "bootsnap"

Bootsnap::VERSION.upcase
Bootsnap::RUBY_CACHE_KEY.upcase

Bootsnap.instrumentation = ->(event, path) { puts "#{event} #{path}" }
Bootsnap.instrumentation = nil
Bootsnap.log!
Bootsnap.logger = $stderr.method(:puts)
Bootsnap.log_stats!

Bootsnap.setup(
  cache_dir: "tmp/cache",
  ignore_directories: ["node_modules"],
  development_mode: true,
  load_path_cache: true,
  compile_cache_iseq: true,
  compile_cache_yaml: true,
  readonly: false,
  revalidation: false,
  config_path: "config/bootsnap.rb"
)
Bootsnap.setup(cache_dir: Pathname("tmp/cache"))

# @type var cache_dir: String?
cache_dir = Bootsnap.cache_dir
cache_dir&.upcase

# @type var loaded: bool?
loaded = Bootsnap.load_config("config/bootsnap.rb")
Bootsnap.load_config(nil)

Bootsnap.enable_frozen_string_literal(app_only: true)
Bootsnap.enable_frozen_string_literal

# @type var bundler: bool
bundler = Bootsnap.bundler?

# @type var lpc: Bootsnap::LoadPathCache::Cache?
lpc = Bootsnap::LoadPathCache.load_path_cache
if lpc
  # @type var found: String | false | BasicObject | nil
  found = lpc.find("json")
  lpc.push_paths($LOAD_PATH, "lib")
  lpc.unshift_paths($LOAD_PATH, "lib")
  lpc.reinitialize
end

# @type var lfi: Bootsnap::LoadPathCache::LoadedFeaturesIndex?
lfi = Bootsnap::LoadPathCache.loaded_features_index
if lfi
  # @type var known: bool
  known = lfi.key?("json")
  # @type var cursor: Integer?
  cursor = lfi.cursor("json")
  if cursor
    # @type var feature: String?
    feature = lfi.identify("json", cursor)
    lfi.register("json", feature)
  end
  lfi.purge("json")
  lfi.purge_multi(["json"])
end

# @type var enabled: bool
enabled = Bootsnap::LoadPathCache.enabled?
# @type var supported: bool?
supported = Bootsnap::LoadPathCache.supported?

store = Bootsnap::LoadPathCache::Store.new("tmp/cache/store", readonly: false)
# @type var size: Integer
size = store.transaction do
  store.set("a", [1, ["b.rb"]])
  store.fetch("c") { [0, ["d.rb"]] }
  # @type var entry: Array[untyped]
  entry = store.get("a")
  entry.size
end
cache = Bootsnap::LoadPathCache::Cache.new(store, ["lib"], development_mode: true)
cache.find("bootsnap") == Bootsnap::LoadPathCache::FALLBACK_SCAN

begin
  store.transaction { store.transaction { nil } }
rescue Bootsnap::LoadPathCache::Store::NestedTransactionError
  nil
end

Bootsnap::CompileCache.setup(cache_dir: "tmp/cache/compile-cache", iseq: true, yaml: true, readonly: true, revalidation: true)
# @type var compile_supported: bool
compile_supported = Bootsnap::CompileCache.supported?

Bootsnap::CompileCache::ISeq.compiler_selector = lambda { |path|
  if path.start_with?("/app/")
    Bootsnap::CompileCache::ISeq::FROZEN_STRING_LITERAL
  else
    Bootsnap::CompileCache::ISeq::DEFAULT
  end
}
Bootsnap::CompileCache::ISeq.compiler_selector = nil
Bootsnap::CompileCache::ISeq.default_compiler = Bootsnap::CompileCache::ISeq::DEFAULT

# @type var compiler: Bootsnap::CompileCache::ISeq::Compiler
compiler = Bootsnap::CompileCache::ISeq.default_compiler
compiler.namespace&.upcase
compiler = Bootsnap::CompileCache::ISeq::Compiler.new("-custom", { frozen_string_literal: true })
compiler.update_options

# @type var iseq: RubyVM::InstructionSequence?
iseq = Bootsnap::CompileCache::ISeq.fetch("app/models/user.rb")
iseq&.eval
# @type var precompiled: bool?
precompiled = Bootsnap::CompileCache::ISeq.precompile("app/models/user.rb")
# @type var coverage: bool
coverage = Bootsnap::CompileCache::ISeq.coverage_supported?("4.0.4")
Bootsnap::CompileCache::ISeq.cache_dir&.upcase

begin
  Bootsnap.default_setup
rescue RuntimeError
  nil
end

# @type var with_gems: Integer
with_gems = Bootsnap::ExplicitRequire.with_gems("msgpack") { 1 }

# @type var unloaded: nil
unloaded = Bootsnap.unload_cache!
