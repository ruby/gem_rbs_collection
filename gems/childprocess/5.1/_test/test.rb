# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "childprocess"
require "logger"

process = ChildProcess.build("ruby", "-e", "puts 1")
process.io.inherit!
process.io.stdout = File.open(File::NULL, "w")
process.io.stderr = $stderr
process.environment["a"] = "b"
process.environment["c"] = nil
process.environment[:d] = 1
process.cwd = Dir.pwd
process.leader = true
process.detach = false
process.duplex = true
process.start
process.io.stdin&.close
process.alive?
process.exited?
process.started?
process.crashed?
process.pid&.succ
code = process.wait
code&.succ
process.exit_code&.succ

other = ChildProcess.new("sleep", "10").start
begin
  other.poll_for_exit(0.5)
rescue ChildProcess::TimeoutError
  other.stop
end
other.stop(1)

logger = Logger.new($stderr)
logger.level = Logger::DEBUG
ChildProcess.logger = logger
ChildProcess.logger = nil
ChildProcess.logger.info("hello")

ChildProcess.platform
ChildProcess.platform_name.upcase
ChildProcess.os == :linux
ChildProcess.arch.upcase
ChildProcess.unix? || ChildProcess.windows? || ChildProcess.linux? || ChildProcess.jruby?
ChildProcess.posix_spawn = false
ChildProcess.posix_spawn?
ChildProcess.posix_spawn_chosen_explicitly?
ChildProcess.close_on_exec(File.open(__FILE__))
ChildProcess::VERSION.upcase
ChildProcess::AbstractProcess::POLL_INTERVAL.ceil
