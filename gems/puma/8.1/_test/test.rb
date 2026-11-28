require "puma"
require "puma/configuration"
require "puma/launcher"
require "puma/cli"
require "puma/control_cli"
require "puma/plugin"
require "rack/handler/puma"

app = ->(_env) { [200, { "content-type" => "text/plain" }, ["OK"]] }

# @type var config: Puma::Configuration
config = Puma::Configuration.new({ log_requests: false }) do |user_config, _file_config, _default_config|
  user_config.port 3000
  user_config.bind "tcp://127.0.0.1:9293"
  user_config.workers 2
  user_config.workers :auto
  user_config.threads 1, 5
  user_config.threads "5"
  user_config.environment "production"
  user_config.preload_app!
  user_config.pidfile "tmp/pids/puma.pid"
  user_config.state_path "tmp/pids/puma.state"
  user_config.worker_timeout 60
  user_config.plugin :tmp_restart
  user_config.activate_control_app "unix:///tmp/pumactl.sock", auth_token: "secret"
  user_config.activate_control_app "tcp://127.0.0.1:9294", { no_token: true }
  user_config.ssl_bind "127.0.0.1", 9295, cert: "cert.pem", key: "key.pem", verify_mode: "none"
  user_config.ssl_bind "127.0.0.1", "9296", { cert_pem: "...", key_pem: "..." }
  user_config.stdout_redirect "log/stdout.log", "log/stderr.log", true
  user_config.force_shutdown_after :immediately
  user_config.set_remote_address header: "X-Forwarded-For"
  user_config.supported_http_methods :any
  user_config.app app
  user_config.app { |env| [200, { "content-length" => "2" }, [env.size.to_s]] }
  user_config.lowlevel_error_handler { |error, _env, status| [status, { "content-type" => "text/plain" }, [error.message]] }
  user_config.log_formatter { |str| "[app] #{str}" }

  user_config.before_fork { }
  user_config.before_worker_boot { |index| index + 1 }
  user_config.before_worker_boot(:db) { |index, data| data[:index] = index }
  user_config.before_worker_shutdown(:db) { |_index, data| data.clear }
  user_config.after_worker_shutdown { |worker| worker.process_status&.success? }
  user_config.before_restart { |launcher| launcher.stats }
  user_config.after_booted { }
  user_config.before_thread_start { |control| control.update_thread_pool_min_max(min: 1, max: control.max_threads) }
  user_config.out_of_band { }
  user_config.single { }
  user_config.cluster { }
end

# @type var options: Puma::UserFileDefaultOptions
options = config.clamp
options[:binds]
options.all_of(:binds).size
# @type var env_name: String
env_name = config.environment
env_name.upcase
# @type var final: Hash[Symbol, untyped]
final = config.final_options
final[:workers]

# @type var launcher: Puma::Launcher
launcher = Puma::Launcher.new(config, log_writer: Puma::LogWriter.stdio, events: Puma::Events.new)
# @type var stats: Hash[Symbol, untyped]
stats = launcher.stats
stats[:started_at]
launcher.restart
launcher.phased_restart
# @type var reforked: bool
reforked = launcher.refork
launcher.stop

# @type var server: Puma::Server
server = Puma::Server.new(app, nil, { min_threads: 0, max_threads: 4 })
server.add_tcp_listener "127.0.0.1", 0
# @type var thread: Thread
thread = server.run
# @type var ports: Array[Integer | String]
ports = server.connected_ports
server.update_thread_pool_min_max(min: 1, max: 8)
server.stats[:running]
server.stop(true)
thread.join

# @type var json: String
json = Puma.stats
# @type var stats_hash: Hash[Symbol, untyped]
stats_hash = Puma.stats_hash

# @type var log_writer: Puma::LogWriter
log_writer = Puma::LogWriter.strings
log_writer.log "booted"
log_writer.debug { "details" }

events = Puma::Events.new
events.after_booted { puts "booted" }
events.register(:state) { |state| puts state }

# @type var plugin_class: singleton(Puma::Plugin)
plugin_class = Puma::Plugin.create do
  name
end
plugin_class.new.in_background { puts "running" }

class MyPlugin < Puma::Plugin
  def start(launcher)
    in_background { launcher.log_writer.log "running" }
  end

  def config(dsl)
    dsl.workers 1
  end
end
Puma::Plugins.register("my_plugin", MyPlugin)

# @type var cli: Puma::CLI
cli = Puma::CLI.new(["--port", "3000", "config.ru"])
cli.launcher.connected_ports
Puma::ControlCLI.new(["--state", "tmp/pids/puma.state", "stats"]).run

version = Puma::Const::PUMA_VERSION
version.split(".")
reforked && json && stats_hash && ports && log_writer
