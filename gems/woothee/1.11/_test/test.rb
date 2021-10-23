# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "woothee"

result = Woothee.parse("Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)")

result[:name] # => "Internet Explorer"
result[:category] # => :pc
result[:os] # => "Windows 7"
result[:os_version] # => "NT 6.1"
result[:version] # => "8.0"
result[:vendor] # => "Microsoft"

Woothee.is_crawler("Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)") # => false
