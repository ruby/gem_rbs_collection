# frozen_string_literal: true

require "xpath"
require "xpath/version"

XPath::VERSION.upcase

expression = XPath.generate { |x| x.descendant(:ul)[x.attr(:id) == "foo"] }
expression.to_xpath.upcase
expression.to_s.upcase
expression.to_xpath(:exact).upcase

XPath.descendant(:p)[XPath.attr(:id) == :foo].to_s.upcase
XPath.descendant(:p)[1].to_s.upcase
XPath.descendant(:p, :div).where(nil).to_s.upcase
XPath.child(:li).where(XPath.text.contains("foo")).to_s.upcase
XPath.anywhere(:div).axis(:"following-sibling", :p).to_s.upcase
XPath.css("#moar p").descendant(:p).to_s.upcase
XPath.function(:boolean, XPath.function(:true) == XPath.function(:false)).to_s.upcase
XPath.text.method(:"string-length").to_s.upcase
XPath.text.substring(2, 4).string_length.normalize_space.to_s.upcase
XPath.attr(:id).is("foo").to_s.upcase
XPath.attr(:id).binary_operator(:"=", "foo").to_s.upcase
XPath.attr(:class).contains_word("fish").to_s.upcase
XPath.attr(:id).starts_with("foo").and(XPath.attr(:id).ends_with("bar")).to_s.upcase
XPath.attr(:id).one_of("foo", "bar").to_s.upcase
XPath.attr(:title).uppercase.lowercase.to_s.upcase
XPath.descendant(:p).position.equals(XPath.last).to_s.upcase
(XPath.position.plus(1) > 2).to_s.upcase
(!XPath.attr(:id).equals("foo")).to_s.upcase
(~XPath.attr(:id)).to_s.upcase
((XPath.attr(:id) != "bar") | XPath.attr(:id).inverse).to_s.upcase
XPath.descendant(:p).next_sibling(:ul, :p).previous_sibling.to_s.upcase
XPath.ancestor(:div).self_axis(:div).parent.following_sibling(:p).to_s.upcase
XPath.descendant(:p).count.qname.to_s.upcase
XPath.current.expression.to_s
XPath.current.arguments.size

union = XPath.descendant(:p) + XPath.descendant(:div)
union.to_xpath.upcase
union.to_s(:exact).upcase
union.expressions.size
union.arguments.size
union.expression.to_s
union.each { |e| e.to_xpath.upcase }
union.each.next.to_xpath.upcase
union.map(&:to_xpath).size
XPath::Union.new(XPath.descendant(:a), union).to_xpath.upcase

XPath::Literal.new("foo").value.upcase
XPath::Expression.new(:css, XPath.current, XPath::Literal.new("p")).to_xpath.upcase

XPath::Renderer.render(expression, nil).upcase
XPath::Renderer.render(union, :exact).upcase
XPath::Renderer.new(:exact).render(expression).upcase

module MyXPaths
  include XPath

  def foo_link
    descendant(:a)[attr(:id) == "foo"]
  end
end
