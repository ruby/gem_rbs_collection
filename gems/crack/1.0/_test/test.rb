require "crack"

# @type var version: String
version = Crack::VERSION

# @type var json: untyped
json = Crack::JSON.parse('{"name": "crack", "tags": ["xml", "json"], "count": 1}')
json = Crack::JSON.parse("[1, 2.5, null, true]")

begin
  Crack::JSON.parse("{: 1}")
rescue Crack::ParseError => e
  e.message
end

# @type var exceptions: Array[singleton(Exception)]
exceptions = Crack::JSON.parser_exceptions

# @type var xml: untyped
xml = Crack::XML.parse('<user login="grep"><name>Crack</name><age type="integer">3</age></user>')
xml = Crack::XML.parse("   ")

# @type var rexml_hash: Hash[String, untyped]
rexml_hash = Crack::REXMLParser.parse("<a>text</a>")

# @type var parser: Crack::XML::_Parser
parser = Crack::XML.parser
parser.parse("<a/>")

class MyXMLParser
  def self.parse(xml)
    { "raw" => xml }
  end
end

Crack::XML.parser = MyXMLParser
Crack::XML.parser = nil
Crack::XML.parser = Crack::REXMLParser

# @type var snake: String
snake = Crack::Util.snake_case("CNNNews")

# @type var attrs: String
attrs = Crack::Util.to_xml_attributes({ one: "ONE", "two" => 2 })

class UtilUser
  include Crack::Util

  def run
    snake_case("MerbCore") + to_xml_attributes({ a: 1 })
  end
end
UtilUser.new.run

# @type var typecasts: Hash[String, ^(String?) -> untyped]
typecasts = REXMLUtilityNode.typecasts
# @type var upcase: ^(String?) -> String?
upcase = ->(value) { value&.upcase }
REXMLUtilityNode.typecasts = typecasts.merge("upcase" => upcase)
# @type var available: Array[String]
available = REXMLUtilityNode.available_typecasts
REXMLUtilityNode.available_typecasts = available + ["upcase"]

text = Crack::REXMLParser.parse('<a id="1">text</a>')["a"]
case text
when REXMLUtiliyNodeString
  # @type var text_attributes: Hash[String, String]
  text_attributes = text.attributes
  text.attributes = { "id" => "2" }
end

REXMLUtilityNode.new("user", { "type" => "integer" })
REXMLUtilityNode.new("user")
