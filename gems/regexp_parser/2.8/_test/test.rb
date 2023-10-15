# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "regexp_parser"

regex = /a?(b+(c)d)*(?<name>[0-9]+)/i
Regexp::Parser.parse(regex, 'ruby/2.1') do |token|
  puts token.inspect
end
Regexp::Parser.parse(
  'a+ # Recognizes a and A...',
  options: ::Regexp::EXTENDED | ::Regexp::IGNORECASE
)
