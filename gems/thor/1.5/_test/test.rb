require "thor"
require "thor/group"
require "thor/actions"

class CLI < Thor
  class_option :test_framework, :default => :test_unit
  class_option :verbose, type: :boolean, aliases: "-v", group: :runtime, desc: "Verbose output"
  class_options force: :boolean

  package_name "cli"
  default_command :example
  map "-e" => :example
  map %w[--ex] => :example
  check_unknown_options! except: :example
  stop_on_unknown_option! :example
  disable_required_check! :example

  desc "usage", "description"
  long_desc "long description", wrap: false
  option :message, type: :string, desc: "description", required: false, aliases: "-m", default: "Hello"
  method_option :count, { type: :numeric, default: 1 }
  method_options color: :boolean
  exclusive :message, :count
  at_least_one do
    option :one
    option :two
  end
  def example(*args)
    say "example"
    say "example", :green, true
    say_status :create, "file", :blue
    message = options[:message]
  end

  desc ["multi ARG", "multi --all"], "multiple usages", hide: true
  def multi(arg = nil)
    # @type var answer: String?
    answer = ask("Name?", :green, default: "Bob")
    # @type var yes: bool
    yes = yes?("Continue?")
    # @type var no: bool
    no = no?("Stop?", [:red, :bold])
    print_table([["a", "b"], ["c", 1]], indent: 2)
    print_in_columns(%w[a b c])
    print_wrapped("long text", indent: 2)
    # @type var colored: String
    colored = set_color("text", :red, :bold)
    # @type var collision: bool?
    collision = file_collision("README") { "new content" }
    # @type var padded: Integer
    padded = with_padding { 1 }
    error "error"
  end

  no_commands do
    def helper
    end
  end
end

class Sub < Thor
  namespace :sub
  desc "list", "list things"
  def list
  end
end

CLI.subcommand "sub", Sub
CLI.register Sub, "other", "other COMMAND", "other commands"

# @type var commands: Hash[String, Thor::Command]
commands = CLI.commands
# @type var all_commands: Hash[String, Thor::Command]
all_commands = CLI.all_commands
command = commands.fetch("example")
# @type var name: String
name = command.name
# @type var description: String?
description = command.description
# @type var usage: String | Array[String] | nil
usage = command.usage
# @type var hidden: bool
hidden = command.hidden?
# @type var formatted: String
formatted = command.formatted_usage(CLI, false, false)
# @type var class_options: Hash[Symbol | String | Array[Symbol | String], Thor::Option]
class_options = CLI.class_options
option = class_options.fetch(:verbose)
# @type var aliases: Array[String]
aliases = option.aliases
# @type var boolean: bool
boolean = option.boolean?
# @type var namespace: String
namespace = Sub.namespace
# @type var group: String
group = CLI.group
# @type var default: String
default = CLI.default_command
# @type var subcommands: Array[String]
subcommands = CLI.subcommands
# @type var subcommand_classes: Hash[String, singleton(Thor)]
subcommand_classes = CLI.subcommand_classes
# @type var printable: Array[[String, String]]
printable = CLI.printable_commands
# @type var mappings: Hash[String | Symbol, String | Symbol]
mappings = CLI.map
# @type var exit_on_failure: bool
exit_on_failure = CLI.exit_on_failure?
CLI.start(%w[example])
CLI.start(%w[help], shell: Thor::Shell::Basic.new)
cli = CLI.new([], { message: "hi" }, {})
# @type var opts: Hash[String | Symbol, untyped]
opts = cli.options
# @type var chain: Array[Symbol]
chain = cli.current_command_chain
# @type var shell: Thor::Shell::Basic
shell = cli.shell

class Generator < Thor::Group
  include Thor::Actions

  source_root "templates"
  add_runtime_options!
  argument :name, type: :string, desc: "the name", default: "app"
  desc "Generates an app"

  def create_files
    # @type var root: String
    root = destination_root
    # @type var created: String
    created = create_file "README", "hello", verbose: false
    create_file("LICENSE") { "MIT" }
    copy_file "a.txt", "b.txt", mode: :preserve
    # @type var rendered: String
    rendered = template "a.tt", "a.rb", { force: true }
    empty_directory "lib"
    directory "dir", "out", exclude_pattern: /\.bak\z/
    insert_into_file "README", "more\n", after: "hello"
    append_to_file("README") { "end\n" }
    prepend_to_file "README", "start\n"
    inject_into_class "app.rb", "App", "  def x; end\n"
    gsub_file "README", /hello/, "bye"
    gsub_file("README", "bye") { |match| match.upcase }
    comment_lines "README", /bye/
    uncomment_lines "README", "bye"
    chmod "README", 0o644
    remove_file "README"
    # @type var inside_result: Integer
    inside_result = inside("lib") { |dir| dir.size }
    # @type var ran: String | bool | nil
    ran = run "echo hi", capture: true
  end
end

Generator.invoke CLI, verbose: false
Generator.start(%w[app])
# @type var group_desc: String?
group_desc = Generator.desc
# @type var paths: Array[String]
paths = Generator.source_paths_for_search
# @type var source_root: String?
source_root = Generator.source_root

basic = Thor::Shell::Basic.new
basic.padding = 2
# @type var padding: Integer
padding = basic.padding
# @type var muted: Integer
muted = basic.mute { 1 }
# @type var mute: bool
mute = basic.mute?
basic.indent(2) { basic.say("indented") }
basic.say_error("oops", :red)
# @type var width: Integer
width = Thor::Shell::Terminal.terminal_width

begin
  CLI.start(%w[nope], debug: true)
rescue Thor::UndefinedCommandError => e
  # @type var missing: String
  missing = e.command
end

# @type var new_command: Thor::Command
new_command = Thor::Command.new(:build, "Builds", nil, nil, "build TARGET")
# @type var hidden_command: Thor::HiddenCommand
hidden_command = Thor::HiddenCommand.new("secret", "Hidden", nil, nil, "secret")
# @type var dynamic_command: Thor::DynamicCommand
dynamic_command = Thor::DynamicCommand.new("dyn")
new_command.run(CLI.new, [])
