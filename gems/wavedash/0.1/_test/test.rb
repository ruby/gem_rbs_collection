# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "wavedash"

str = "こんにちは\u{301C}"

Wavedash.destination_encoding = 'eucjp-ms'

Wavedash.normalize(str) # => "こんにちは～"

Wavedash.invalid?(str) # => true
