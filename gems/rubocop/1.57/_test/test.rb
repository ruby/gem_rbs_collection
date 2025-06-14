# Test APIs for creating a new cop
# ref: https://docs.rubocop.org/rubocop/development.html
module RuboCop
  module Cop
    class SimplifyNotEmptyWithAny < Base
      extend AutoCorrector
      include IgnoredNode

      MSG = 'Use `.any?` and remove the negation part.'.freeze
      RESTRICT_ON_SEND = [:!].freeze

      # @dynamic not_empty_call?
      def_node_matcher :not_empty_call?, <<~PATTERN
        (send (send $(...) :empty?) :!)
      PATTERN

      def on_send(node)
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
