# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "os"

windows = OS.windows? # @type var windows: bool
doze = OS.doze? # @type var doze: bool
jruby = OS.jruby? # @type var jruby: bool
mac = OS.mac? || OS.osx? || OS.x? # @type var mac: bool
posix = OS.posix? && OS.linux? && OS.freebsd? && OS.cygwin? && OS.iron_ruby? && OS.java? # @type var posix: bool

bits = OS.bits # @type var bits: Integer
cpus = OS.cpu_count # @type var cpus: Integer
rss = OS.rss_bytes # @type var rss: Integer

ruby = OS.ruby_bin # @type var ruby: String
null = OS.dev_null # @type var null: String
report = OS.report # @type var report: String
command = OS.open_file_command # @type var command: String
path = OS.app_config_path("myapp") # @type var path: String
host = OS.host + OS.host_cpu + OS.host_os # @type var host: String
config = OS.config # @type var config: Hash[String, String]

release = OS.parse_os_release # @type var release: Hash[Symbol, String?]
release[:ID]&.upcase

bsd = OS::Underlying.bsd? || OS::Underlying.windows? || OS::Underlying.linux? # @type var bsd: bool
docker = OS::Underlying.docker? # @type var docker: bool?
