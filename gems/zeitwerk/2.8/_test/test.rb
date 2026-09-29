# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "zeitwerk"
require "pathname"

module MyGem
end

class DebugLogger
  def debug(message) = puts(message)
end

gem_loader = Zeitwerk::Loader.for_gem
gem_loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
gem_loader.setup
Zeitwerk::Loader.for_gem_extension(MyGem)

loader = Zeitwerk::Loader.new
loader.tag = "my_app"
loader.tag = :my_app
loader.tag.upcase
loader.push_dir("app/models")
loader.push_dir(Pathname("app/services"), namespace: MyGem)
loader.ignore("lib/generators", Pathname("lib/tasks"), ["lib/tmp"])
loader.collapse("app/models/concerns")
loader.do_not_eager_load("app/models/legacy")
loader.nsfile = "namespace.rb"
loader.nsfile = nil

loader.inflector.inflect("html_parser" => "HTMLParser")
loader.inflector = Zeitwerk::GemInflector.new(__FILE__)
loader.inflector = Zeitwerk::NullInflector.new
loader.inflector.camelize("users_controller", "/app/users_controller.rb").upcase

loader.logger = ->(msg) { puts msg }
loader.logger = DebugLogger.new
loader.log!
Zeitwerk::Loader.default_logger = method(:puts)

loader.on_setup { puts "set up" }
loader.on_load("MyGem::Client") { |klass, abspath| p klass, abspath.upcase }
loader.on_load { |cpath, value, abspath| p cpath.upcase, value, abspath }
loader.on_unload("MyGem::Client") { |klass, _abspath| p klass }
loader.on_unload { |cpath, _value, _abspath| p cpath }

loader.enable_reloading
loader.setup
loader.reload if loader.reloading_enabled?

loader.eager_load
loader.eager_load(force: true)
loader.eager_load_dir("app/models")
loader.eager_load_namespace(MyGem)
loader.load_file(Pathname("app/models/user.rb"))

loader.dirs.each { |dir| dir.upcase }
loader.dirs(namespaces: true).each { |dir, namespace| p dir.upcase, namespace.name }
loader.all_expected_cpaths.each { |abspath, cpath| p abspath, cpath }
loader.cpath_expected_at("app/models/user.rb")&.upcase

Zeitwerk::Loader.eager_load_all
Zeitwerk::Loader.eager_load_namespace(MyGem)
Zeitwerk::Loader.all_dirs.map(&:upcase)

begin
  loader.reload
rescue Zeitwerk::ReloadingDisabledError, Zeitwerk::SetupRequired => e
  e.message
rescue Zeitwerk::NameError => e
  e.name
end

Zeitwerk::VERSION.upcase
