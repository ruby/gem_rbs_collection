# Test APIs for creating a new cop
# ref: https://docs.rubocop.org/rubocop/development.html
module RuboCop
  module Cop
    class SimplifyNotEmptyWithAny < Base
      extend TargetRubyVersion
      minimum_target_ruby_version 2.7
      maximum_target_ruby_version 2.6

      requires_gem "my-gem", ">= 1.2.3", "< 4.5.6"

      extend AutoCorrector
      include IgnoredNode

      MSG = 'Use `.any?` and remove the negation part.'.freeze
      RESTRICT_ON_SEND = [:!].freeze

      # @dynamic not_empty_call?
      def_node_matcher :not_empty_call?, <<~PATTERN
        (send (send $(...) :empty?) :!)
      PATTERN

      def on_send(node)
        if target_gem_version("my-gem") < "2.0"
          # ...
        else
          # ...
        end

        expression = not_empty_call?(node)
        return unless expression

        add_offense(node) do |corrector|
          next if part_of_ignored_node?(node)

          corrector.replace(node, "#{expression.source}.any?")
        end

        ignore_node(node)
      end
    end
  end
end
