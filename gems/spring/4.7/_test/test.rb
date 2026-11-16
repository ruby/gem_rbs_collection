require "pathname"
require "spring/version"
require "spring/configuration"
require "spring/watcher"
require "spring/commands"
require "spring/commands/rake"

# Spring.watch raises Spring::MissingApplication outside of a Rails application
configure_watch = lambda do
  Spring.watch(".ruby-version", "tmp/restart.txt")
  Spring.watch(Pathname.new("config/credentials"))
  Spring.watch(%w[Gemfile Gemfile.lock])
  [".rbenv-vars", "tmp/caching-dev.txt"].each { |path| Spring.watch(path) }
end
configure_watch.arity

Spring.application_root = "./test/dummy"
root = Spring.application_root
root&.upcase
Spring.application_root = nil

Spring.quiet = true
Spring.quiet = nil
quiet = Spring.quiet
quiet ? 1 : 0

Spring.after_fork do
  1 + 1
end

Spring.after_environment_load do
  1 + 1
end

Spring.dangerously_allow_disabling_reloading = true
reloading = Spring.dangerously_allow_disabling_reloading
reloading ? 1 : 0

Spring::VERSION.upcase

Spring::Commands::Rake.environment_matchers["spec"] = "test"
Spring::Commands::Rake.environment_matchers[/^perf/] = "test"
Spring::Commands::Rake.environment_matchers[:default] = "development"
Spring::Commands::Rake.environment_matchers = { default: "test" }
Spring::Commands::Rake.environment_matchers.fetch(:default).upcase
