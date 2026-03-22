# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "lint_roller"

module BananaRoller
  class Plugin < LintRoller::Plugin
    # `config' is a Hash of options passed to the plugin by the user
    def initialize(config = {})
      @alternative = config["alternative"] ||= "chocolate"
    end

    def about
      LintRoller::About.new(
        name: "banana_roller",
        version: "1.0", # or, in a gem, probably BananaRoller::VERSION
        homepage: "https://github.com/example/banana_roller",
        description: "Configuration of banana-related code"
      )
    end

    # `context' is an instance of LintRoller::Context provided by the runner
    def supported?(context)
      context.engine == :rubocop
    end

    # `context' is an instance of LintRoller::Context provided by the runner
    def rules(context)
      LintRoller::Rules.new(
        type: :path,
        config_format: :rubocop,
        value: Pathname.new(__dir__).join("../../config/default.yml") # steep:ignore
      )
    end
  end
end
