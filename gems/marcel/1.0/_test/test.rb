require "marcel"
require "pathname"
require "stringio"

# Magic bytes sniffing alone
Marcel::MimeType.for Pathname.new("example.gif")
#  => "image/gif"

File.open "example.gif" do |file|
  Marcel::MimeType.for file
end
#  => "image/gif"

# Magic bytes with filename fallback
Marcel::MimeType.for Pathname.new("unrecognisable-data"), name: "example.pdf"
#  => "application/pdf"

# File extension alone
Marcel::MimeType.for extension: ".pdf"
#  => "application/pdf"

# Magic bytes, declared type, and filename together
Marcel::MimeType.for Pathname.new("unrecognisable-data"), name: "example", declared_type: "image/png"
#  => "image/png"

# Safe fallback to application/octet-stream
Marcel::MimeType.for StringIO.new(File.read "unrecognisable-data")
#  => "application/octet-stream"
