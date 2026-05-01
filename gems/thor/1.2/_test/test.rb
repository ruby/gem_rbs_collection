# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "thor"

class CLI < Thor
  class_option :test_framework, :default => :test_unit

  desc "usage", "description"
  option :message, type: :string, desc: "description", required: false, aliases: "-m", default: "Hello"
  def example(*args)
    message = options[:message]
  end

  no_commands do
  end
end
