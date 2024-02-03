# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "oga"

html = <<HTML
<html>
<body>
<ul id="list" data-attr="b">
  <li data-attr="a">list1</li>
  <li>list2</li>
</ul>
</body>
</html>
HTML

Oga.parse_xml("")
Oga.parse_xml("", strict: true)
Oga.parse_html(File.open("path"))
doc = Oga.parse_html(html)

doc.xpath("//li").each do |node|
  if node.is_a?(Oga::XML::Element)
    puts node.get("data-attr")
  end
end
doc.at_xpath("//ul")
puts doc.at_css("#list")&.get("data-attr")
doc.css("#list").each.with_index { |e, i| p e, i }
doc.each_node.with_index{ |n, i| p n, i }
doc.at_css("li")&.each_ancestor&.with_index{ |n, i| p n, i }
