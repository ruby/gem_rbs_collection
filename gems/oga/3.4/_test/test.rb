# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "oga"

Oga.parse_xml("")
Oga.parse_xml("", strict: true)
Oga.parse_html("")
doc = Oga.parse_html(File.open("path"))

doc.xpath('').each do |node|
  if node.is_a?(Oga::XML::Element)
    node.get('attr')
  end
end
doc.at_xpath('')
doc.css('').each do |elem|
  elem.css('')[0]&.text
end
