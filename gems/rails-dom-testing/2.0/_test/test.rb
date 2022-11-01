# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rails-dom-testing"

module Test
  include Rails::Dom::Testing::Assertions
  def assert(test, message)
    raise message unless test
  end

  def test_case
    assert_dom_equal '<a href="http://www.example.com">Apples</a>', '<a href="http://www.examples.com">Apples</a>'
  end
end
