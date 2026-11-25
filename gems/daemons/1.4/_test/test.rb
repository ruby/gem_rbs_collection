require "daemons"

# Wrapper scripts
Daemons.run("myserver.rb", app_name: "myserver", ARGV: ["start", "--", "-v"], dir_mode: :script, dir: "pids", multiple: true, monitor: true)
Daemons.run_proc("myproc", ARGV: ["run"], ontop: true) do
  puts "working"
end
if (group = Daemons.group)
  group.app_name.upcase
end
Daemons.controller&.app_name&.upcase

# Daemons.call / Daemons.new
app = Daemons.call(app_name: "worker", ontop: true) { puts "in the daemon" }
app.group.applications.size
app.pid.pid&.to_s
app.running?
app.stop(true)
app.stop
unstarted = Daemons.new(multiple: true) { sleep 1 }
unstarted.start
unstarted.show_status
unstarted.show_status_callback = :default_show_status
# @type var callback: ^(Daemons::Application) -> void
callback = ->(a) { puts a.pid.pid }
unstarted.show_status_callback = callback
unstarted.zap
unstarted.options[:app_name]
unstarted.logfilename.upcase
unstarted.output_logfilename.upcase
unstarted.logfile&.upcase
unstarted.output_logfile&.upcase
unstarted.logdir&.upcase
unstarted.pidfile_dir&.upcase
unstarted.script&.upcase

Daemons.daemonize(app_name: "self", log_output: true, backtrace: true)

# Application groups
group = Daemons::ApplicationGroup.new("myapp", dir_mode: :normal, dir: "/tmp", multiple: true)
group.dir_mode = :system
group.dir.upcase
group.multiple
group.setup.each(&:running?)
application = group.new_application(ontop: true)
application.app_argv = ["--verbose"]
application.controller_argv&.join(" ")
group.pidfile_dir&.upcase
group.show_status
group.stop_all(true)
group.zap_all
group.running?
group.monitor&.stop

# Controller
command, controller_part, app_part = Daemons::Controller.split_argv(["start", "-t", "--", "-v"])
command&.upcase
controller_part.size
app_part.size
controller = Daemons::Controller.new({ app_name: "myapp", script: "myapp.rb" }, ["status"])
result = controller.catch_exceptions { 42 }
result&.succ
Daemons::Optparse.new(controller).parse(["-t", "--force_kill_waittime", "10"])[:ontop]

# Pid files
pid_file = Daemons::PidFile.new("/tmp", "myapp", true, ".n")
pid_file.pid = Process.pid
pid_file.filename.upcase
pid_file.number&.succ
pid_file.pid&.succ
pid_file.exist?
Daemons::PidFile.find_files("/tmp", "myapp", true) { |pid, file| puts "#{pid} #{file}" }.each(&:upcase)
Daemons::PidFile.existing("/tmp/myapp.pid").zap
Daemons::Pid.running?(pid_file.pid)
Daemons::Pid.dir(:normal, "pids", nil)&.upcase
pid_mem = Daemons::PidMem.existing(Process.pid)
pid_mem.pid = nil
pid_mem.running?

# Errors
begin
  Daemons.run("myserver.rb")
rescue Daemons::SystemError => e
  e.system_error
rescue Daemons::Exception => e
  e.message
end

# Daemonize
Daemonize.simulate("/tmp/out.log", "myapp")
Daemonize.call_as_daemon(-> { sleep 1 }, nil, "child").succ
