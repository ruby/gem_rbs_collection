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

# Magic: lookups return nil when nothing matches
magic = Marcel::Magic.by_magic(StringIO.new("GIF89a"))
magic.subtype if magic
Marcel::Magic.by_extension(".gif")&.type
Marcel::Magic.by_path("example.pdf")&.mediatype
Marcel::Magic.all_by_magic(Tempfile.new).map(&:type)
