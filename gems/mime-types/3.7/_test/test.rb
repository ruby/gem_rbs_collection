require "mime/types"
require "logger"

# @type var version: String
version = MIME::Types::VERSION
version = MIME::Type::VERSION

# @type var found: Array[MIME::Type]
found = MIME::Types["text/plain"]
found = MIME::Types[:"text/plain"]
found = MIME::Types[/^image/, complete: true]
found = MIME::Types["text/html", registered: true]
found = MIME::Types.type_for("citydesk.xml")
found = MIME::Types.type_for(%w[citydesk.xml citydesk.gif])
found = MIME::Types.of("file.json")

# @type var count: Integer
count = MIME::Types.count

MIME::Types.each { |t| t.content_type }
# @type var enum: Enumerator[MIME::Type, untyped]
enum = MIME::Types.each
MIME::Types.select(&:registered?)

text = MIME::Types["text/plain"].first or raise
found = MIME::Types[text]

# @type var str: String
str = text.content_type
str = text.simplified
str = text.media_type
str = text.raw_media_type
str = text.sub_type
str = text.raw_sub_type
str = text.encoding
str = text.default_encoding
str = text.i18n_key
str = text.to_s
str = text.to_str
str = text.to_json
str = text.inspect

# @type var maybe_str: String?
maybe_str = text.preferred_extension
maybe_str = text.friendly
maybe_str = text.friendly(:en)
maybe_str = text.use_instead
maybe_str = text.docs
maybe_str = MIME::Type.simplified("x-appl/x-zip", remove_x_prefix: true)
maybe_str = MIME::Type.simplified(text)
maybe_str = MIME::Type.i18n_key("x-appl/x-zip")

# @type var match: MatchData?
match = MIME::Type.match("text/plain")

# @type var strings: Array[String]
strings = text.extensions
strings = text.xref_urls

# @type var flag: bool
flag = text.binary?
flag = text.ascii?
flag = text.obsolete?
flag = text.registered?
flag = text.provisional?
flag = text.complete?
flag = text.like?("text/x-plain")
flag = text.eql?(text)
flag = text == "text/plain"

# @type var maybe_flag: bool?
maybe_flag = text.signature?

# @type var order: Integer?
order = text <=> "text/html"
# @type var priority: Integer?
priority = text.priority_compare(text)
# @type var hash_value: Integer
hash_value = text.hash

# @type var xrefs: MIME::Types::Container | Hash[String, Array[String]]
xrefs = text.xrefs
xrefs.keys
xrefs.each { |key, values| values.to_a }
# @type var container: MIME::Types::Container
container = MIME::Types::Container.new(text.xrefs)
container = MIME::Types::Container.new("rfc" => ["rfc2046"])
# @type var set: Set[untyped]
set = container["rfc"]

# @type var hash: Hash[String, untyped]
hash = text.to_h

# @type var translations: Hash[String, String]
translations = text.friendly("en" => "Text File")

type = MIME::Type.new("content-type" => "x-appl/x-zip") do |t|
  t.extensions = %w[zip zp]
  t.preferred_extension = "zip"
  t.encoding = "base64"
  t.docs = "Zip archives"
  t.obsolete = true
  t.use_instead = "application/zip"
  t.registered = false
  t.provisional = false
  t.signature = true
  t.xrefs = { "rfc" => ["rfc1234"] }
end
type.add_extensions("zipx", %w[zipy], nil)
type = MIME::Type.new(type)
type < text

registry = MIME::Types.new
# @type var added: Array[untyped]
added = registry.add(type, :silent)
added = MIME::Types.add(type, true)
strings = registry.add_type(type, true)
registry.each { |t| t.simplified }
count = registry.count

# @type var loader: MIME::Types::Loader
loader = MIME::Types::Loader.new
str = loader.path
# @type var loaded: MIME::Types
loaded = loader.container
loaded = loader.load(columnar: false)
loaded = MIME::Types::Loader.load

cache_file = "mime.cache"
# @type var written: Integer?
written = MIME::Types::Cache.save(registry, cache_file)
# @type var cached: MIME::Types?
cached = MIME::Types::Cache.load(cache_file)

MIME::Types.logger = Logger.new($stderr)
MIME::Types.logger = nil
MIME::Types.logger.debug("message")

begin
  MIME::Type.new("content-type" => "invalid")
rescue MIME::Type::InvalidContentType => e
  str = e.to_s
end
