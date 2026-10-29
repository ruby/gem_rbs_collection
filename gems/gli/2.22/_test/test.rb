require "gli"

class TodoApp
  extend GLI::App

  program_desc "Manage a todo list"
  program_long_desc "A longer description of the todo list"
  version "1.0.0"
  subcommand_option_handling :normal
  arguments :strict
  sort_help :manually
  wrap_help_text :verbatim
  synopsis_format :compact
  hide_commands_without_desc true
  preserve_argv
  autocomplete_commands false

  accept(Integer) { |value| value.to_i }

  desc "Be verbose"
  switch [:v, :verbose], negatable: false

  desc "Location of the list"
  default_value "~/.todo"
  arg_name "path"
  flag [:f, :file]

  flag :format, desc: "Output format", must_match: ["json", "text"], default_value: "text"

  desc "Add a task"
  arg "task_name"
  arg "priority", :optional
  command :add do |c|
    c.desc "Due date"
    c.flag :due, type: String, required: true
    c.switch :urgent, desc: "Mark as urgent"
    c.example "todo add 'Buy milk'", desc: "Add a task"

    c.action do |global_options, options, args|
      args.first&.upcase
      options.fetch(:due)
      global_options.key?(:verbose)
    end
  end

  desc "List tasks"
  command [:list, :ls] do |c|
    c.command :done do |sub|
      sub.action do |_global_options, _options, args|
        args.size
      end
    end
    c.default_command :done
  end

  command :all => [:add, :list]

  default_command :list

  pre do |global_options, command, _options, _args|
    command.name.to_s
    global_options.key?(:file)
  end

  post do |_global_options, command, _options, _args|
    command.names_and_aliases.size
  end

  around do |_global_options, _command, _options, _args, code|
    code.call
  end

  on_error do |exception|
    !exception.message.empty?
  end
end

exit_code = TodoApp.run(["add", "Buy milk"])
exit_code + 1
TodoApp.commands.fetch(:add).description&.upcase
TodoApp.flags.each_value { |flag| flag.argument_name.upcase }
TodoApp.switches.each_value { |switch| switch.negatable? }

begin
  TodoApp.exit_now!("bad input", 2)
rescue GLI::CustomExit => e
  e.exit_code + 1
end

GLI::Commands::Help.skips_pre = false
GLI::VERSION.split(".")
