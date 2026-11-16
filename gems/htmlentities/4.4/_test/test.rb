require "htmlentities"

coder = HTMLEntities.new
coder_html4 = HTMLEntities.new("html4")
coder_expanded = HTMLEntities.new(:expanded)

# @type var decoded: String
decoded = coder.decode("&lt;p&gt;caf&eacute; &#233; &#xe9;&lt;/p&gt;")
decoded.upcase

# @type var encoded: String
encoded = coder.encode("<café>")
encoded.upcase

coder.encode("<café>", :basic).upcase
coder.encode("café", :named).upcase
coder.encode("<café>", :basic, :decimal).upcase
coder_html4.encode("<café>", :basic, :hexadecimal).upcase
coder_expanded.encode("<café>", :basic, :named, :decimal).upcase
coder_expanded.encode(123).upcase
coder_html4.decode(:amp).upcase

# @type var flavors: Array[String]
flavors = HTMLEntities::FLAVORS
flavors.first

begin
  HTMLEntities.new("html5")
rescue HTMLEntities::UnknownFlavor => e
  e.message.upcase
end

begin
  coder.encode("x", :decimal, :hexadecimal)
rescue HTMLEntities::InstructionError => e
  e.message.upcase
end
