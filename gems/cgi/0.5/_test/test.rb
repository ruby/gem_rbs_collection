# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "cgi"
cgi = CGI.new
cgi.out("text/plain") { "string" }

CGI.escape("'Stop!' said Fred") #=> "%27Stop%21%27+said+Fred"
CGI.unescape("%27Stop%21%27+said+Fred")  #=> "'Stop!' said Fred"

CGI.escapeURIComponent("'Stop!' said Fred") #=> "%27Stop%21%27%20said%20Fred"
CGI.escape_uri_component("'Stop!' said Fred") #=> "%27Stop%21%27%20said%20Fred"

CGI.unescapeURIComponent("%27Stop%21%27+said%20Fred") #=> "'Stop!'+said Fred"
CGI.unescape_uri_component("%27Stop%21%27+said%20Fred") #=> "'Stop!'+said Fred"

CGI.escapeHTML('Usage: foo "bar" <baz>') #=> "Usage: foo &quot;bar&quot; &lt;baz&gt;"
CGI.escape_html('Usage: foo "bar" <baz>') #=> "Usage: foo &quot;bar&quot; &lt;baz&gt;"

CGI.unescapeHTML("Usage: foo &quot;bar&quot; &lt;baz&gt;") #=> "Usage: foo \"bar\" <baz>"
CGI.unescape_html("Usage: foo &quot;bar&quot; &lt;baz&gt;") #=> "Usage: foo \"bar\" <baz>"

CGI.escapeElement('<BR><A HREF="url"></A>', "A", "IMG") #=> "<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt"
CGI.escapeElement('<BR><A HREF="url"></A>', ["A", "IMG"]) #=> "<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt"
CGI.escape_element('<BR><A HREF="url"></A>', "A", "IMG") #=> "<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt"
CGI.escape_element('<BR><A HREF="url"></A>', ["A", "IMG"]) #=> "<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt"

CGI.unescapeElement("<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt", "A", "IMG") #=> "<BR><A HREF=\"url\"></A&gt"
CGI.unescapeElement("&lt;BR&gt;&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt;", ["A", "IMG"]) #=> "&lt;BR&gt;<A HREF=\"url\"></A>"
CGI.unescape_element("<BR>&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt", "A", "IMG") #=> "<BR><A HREF=\"url\"></A&gt"
CGI.unescape_element("&lt;BR&gt;&lt;A HREF=&quot;url&quot;&gt;&lt;/A&gt;", ["A", "IMG"]) #=> "&lt;BR&gt;<A HREF=\"url\"></A>"

cookies = CGI::Cookie.parse("raw_cookie_string")
