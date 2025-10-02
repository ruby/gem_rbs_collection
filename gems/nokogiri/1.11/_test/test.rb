# https://nokogiri.org/#how-to-use-nokogiri

require 'nokogiri'

# Fetch and parse HTML document
doc = Nokogiri::HTML(<<~HTML)
<body>
  <nav>
    <ul class="menu">
      <li><a href="#">hello</a></li>
    </ul>
  </nav>

  <article>
    <h2>hello</h2>
  </article>
</body>
HTML

# Search for nodes by css
doc.css('nav ul.menu li a', 'article h2').each do |link|
  puts link.content
end

# Search for nodes by xpath
doc.xpath('//nav//ul//li/a', '//article//h2').each do |link|
  puts link.content
end

# Or mix and match
doc.search('nav ul.menu li a', '//article//h2').each do |link|
  puts link.content
end

# Create nodes
doc.create_element('h1', 'hello') { |e| puts e }
doc.create_text_node('hello') { |e| puts e }
doc.create_comment('hello') { |e| puts e }
doc.create_cdata('<hello>') { |e| puts e }

# Create nodes without using blocks
puts doc.create_element('h1', 'hello')
puts doc.create_text_node('hello')
puts doc.create_comment('hello')
puts doc.create_cdata('<hello>')

# Test improved type signatures

# Test XML parsing and document methods
xml_doc = Nokogiri::XML(<<~XML)
<?xml version="1.0" encoding="UTF-8"?>
<root>
  <element id="first" class="test">Content</element>
  <element id="second">More content</element>
</root>
XML

# Test Document#root -> Element?
root_element = xml_doc.root
puts root_element.name if root_element

# Test Document#version -> String?
version = xml_doc.version
puts version if version

# Test Document#encoding -> String?
encoding = xml_doc.encoding
puts encoding if encoding

# Test Node#element_children -> NodeSet (aliased as elements)
children = root_element.element_children if root_element
children.each { |child| puts child.name } if children

elements = root_element.elements if root_element
elements.each { |el| puts el.name } if elements

# Test Node#[] -> String? (attribute accessor)
if root_element
  first_el = root_element.elements.first
  if first_el
    id_value = first_el["id"]
    puts id_value if id_value

    class_value = first_el["class"]
    puts class_value if class_value

    missing_value = first_el["missing"]
    puts missing_value if missing_value
  end
end

# Test Node#attribute -> Attr?
if root_element
  first_el = root_element.elements.first
  if first_el
    id_attr = first_el.attribute("id")
    puts id_attr.name if id_attr
    puts id_attr.value if id_attr

    missing_attr = first_el.attribute("nonexistent")
    puts missing_attr if missing_attr
  end
end

# Test Node#attributes -> Hash[String, Attr]
if root_element
  first_el = root_element.elements.first
  if first_el
    attrs = first_el.attributes
    attrs.each do |name, attr|
      puts "#{name}: #{attr.value}"
    end
  end
end

# Test Node#at -> Node?
found_node = root_element.at("//element[@id='first']") if root_element
puts found_node.name if found_node

not_found = root_element.at("//missing") if root_element
puts not_found if not_found

# Test Node#xpath -> NodeSet
if root_element
  node_set = root_element.xpath("//element")
  node_set.each { |node| puts node.name }
end

# Test NodeSet#at -> Node?
if root_element
  node_set = root_element.xpath("//element")
  first_from_set = node_set.at("[1]")
  puts first_from_set.name if first_from_set
end
