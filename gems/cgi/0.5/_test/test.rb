# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "cgi"
cgi = CGI.new
cgi.out("text/plain") { "string" }

cookies = CGI::Cookie.parse("raw_cookie_string")
