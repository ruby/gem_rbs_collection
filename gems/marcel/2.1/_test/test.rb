require "marcel"
require "pathname"
require "stringio"
require "tempfile"

# Magic bytes sniffing alone
# @type var from_path: String
from_path = Marcel::MimeType.for Pathname.new("example.gif")
#  => "image/gif"

File.open "example.gif" do |file|
  # @type var from_file: String
  from_file = Marcel::MimeType.for file
end
#  => "image/gif"

# Magic bytes with filename fallback
Marcel::MimeType.for Pathname.new("unrecognisable-data"), name: "example.pdf"
#  => "application/pdf"

# File extension alone
# @type var from_extension: String
from_extension = Marcel::MimeType.for extension: ".pdf"
#  => "application/pdf"

# Magic bytes, declared type, and filename together
Marcel::MimeType.for Pathname.new("unrecognisable-data"), name: "example", declared_type: "image/png"
#  => "image/png"

# Safe fallback to application/octet-stream
Marcel::MimeType.for StringIO.new(File.read "unrecognisable-data")
#  => "application/octet-stream"

# String content, nil hints
Marcel::MimeType.for "GIF89a", name: nil, extension: nil, declared_type: nil
Marcel::MimeType.for nil
Marcel::MimeType.for Tempfile.new, declared_type: "text/plain"

# Magic: lookups return nil when nothing matches
magic = Marcel::Magic.by_magic(StringIO.new("GIF89a"))
magic.subtype if magic
Marcel::Magic.by_extension(".gif")&.type
Marcel::Magic.by_path("example.pdf")&.mediatype
Marcel::Magic.all_by_magic(Tempfile.new).map(&:type)

# @type var by_magic: Marcel::Magic?
by_magic = Marcel::Magic.by_magic(Pathname.new("example.gif"))
# @type var all_by_magic: Array[Marcel::Magic]
all_by_magic = Marcel::Magic.all_by_magic("GIF89a")
# @type var by_extension: Marcel::Magic?
by_extension = Marcel::Magic.by_extension(:gif)
# @type var by_path: Marcel::Magic?
by_path = Marcel::Magic.by_path(Pathname.new("example.pdf"))

# A reader whose read takes only the length
class LengthOnlyReader
  def initialize(data)
    @io = StringIO.new(data)
  end

  def read(length)
    @io.read(length)
  end

  def rewind
    @io.rewind
  end
end
Marcel::Magic.by_magic(LengthOnlyReader.new("GIF89a"))

# @type var gif: Marcel::Magic
gif = Marcel::Magic.new("image/gif")
# @type var type: String
type = gif.type
# @type var extensions: Array[String]
extensions = gif.extensions
# @type var canonical: Marcel::Magic
canonical = gif.canonical
# @type var image: bool
image = gif.image?
gif.text?
gif.audio?
gif.video?
gif.child_of?("image/gif")
gif.comment
gif.to_s
gif == "image/gif"
gif.eql?(Marcel::Magic.new("image/gif"))
# @type var hash: Integer
hash = gif.hash

# @type var by_type: Marcel::Magic
by_type = Marcel::Magic.by_type("image/gif")
Marcel::Magic.by_type(nil)
# @type var canonical_type: String
canonical_type = Marcel::Magic.canonical("image/GIF")
Marcel::Magic.canonical(nil)
# @type var child: bool
child = Marcel::Magic.child?("image/svg+xml", "application/xml")

# Registering and removing types
Marcel::Magic.add("application/x-my-thing", extensions: "mtg", parents: "application/json")
Marcel::Magic.add("canonical/type", aliases: "alias/type", extensions: %w[canonical], magic: [[0, "magic"], [0..16, /magic/, [[8, "x"]]]])
Marcel::Magic.canonicalize("alias/type", instead_of: "canonical/type")
Marcel::Magic.remove("application/x-my-thing")
Marcel::MimeType.extend "text/custom", extensions: %w[customtxt]
Marcel::MimeType.extend "text/custom2", extensions: "c2", aliases: nil, parents: ["text/plain"], magic: [[0, "C2"]]
Marcel::MimeType.canonicalize "text/custom3", instead_of: "text/custom2"

# @type var binary: String
binary = Marcel::MimeType::BINARY
# @type var version: String
version = Marcel::VERSION
# @type var extension_types: Hash[String, String]
extension_types = Marcel::EXTENSIONS
# @type var type_extensions: Hash[String, Array[String]]
type_extensions = Marcel::TYPE_EXTS
# @type var type_parents: Hash[String, Array[String]]
type_parents = Marcel::TYPE_PARENTS
# @type var type_aliases: Hash[String, String]
type_aliases = Marcel::TYPE_ALIASES
Marcel::MAGIC.first&.first

# Magic rules and options held in variables
rules = [[0, "x"], [0..4, /y/, [[8, "z"]]]]
Marcel::MimeType.extend "text/a", magic: rules
options = { extensions: %w[a], magic: [[0, "x"]] }
Marcel::Magic.add "text/b", options

# Nilable arguments
maybe_type = ENV["MIME_TYPE"]
# @type var maybe_canonical: String?
maybe_canonical = Marcel::Magic.canonical(maybe_type)
# @type var maybe_magic: Marcel::Magic?
maybe_magic = Marcel::Magic.by_type(maybe_type)
