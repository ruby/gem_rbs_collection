require "json_schemer"
require "pathname"
require "uri"

schema_hash = {
  "type" => "object",
  "required" => ["abc"],
  "properties" => {
    "abc" => { "type" => "integer", "minimum" => 11 }
  }
}

schemer = JSONSchemer.schema(schema_hash)
schemer.valid?({ "abc" => 11 }) #: bool
schemer.valid?({ "abc" => 10 }, access_mode: "read") #: bool

# classic output: an Enumerator of Hash errors
errors = schemer.validate({ "abc" => 10 })
# @type var first_error: Hash[String, untyped]?
first_error = errors.first
first_error&.fetch("type")
# @type var messages: Array[String]
messages = errors.map { |error| error.fetch("error") }
messages.first&.upcase
errors.to_a.each do |error|
  error["data_pointer"]
  error["details"]
end

# @type var resolved: Array[JSONSchemer::error]
resolved = schemer.validate({}, resolve_enumerators: true)
resolved.size

# @type var basic: Hash[String, untyped]
basic = schemer.validate({ "abc" => 10 }, output_format: "basic")
basic.fetch("valid")

# @type var flag: Hash[String, untyped]
flag = schemer.validate({ "abc" => 10 }, output_format: "flag", access_mode: "write")
flag.key?("valid")

# schema as a JSON string and with symbol keys
JSONSchemer.schema('{ "type": "integer" }').valid?(1)
JSONSchemer.schema({ type: "string" }).valid?("one")

# schema file
# @type var load_schema_file: ^() -> JSONSchemer::Schema
load_schema_file = -> { JSONSchemer.schema(Pathname.new("schema.json")) }

# schema validation
JSONSchemer.valid_schema?({ "$id" => "valid" }) #: bool
JSONSchemer.valid_schema?(schema_hash, meta_schema: JSONSchemer.draft7) #: bool
schema_errors = JSONSchemer.validate_schema({ "$id" => "#invalid" })
# @type var schema_messages: Array[String]
schema_messages = schema_errors.map { |error| error.fetch("error") }
schema_messages.first&.length
# @type var schema_basic: Hash[String, untyped]
schema_basic = JSONSchemer.validate_schema({ "$id" => "#invalid" }, output_format: "basic")
schema_basic.keys
# @type var schema_array: Array[JSONSchemer::error]
schema_array = JSONSchemer.validate_schema({ "$id" => "#invalid" }, resolve_enumerators: true)
schema_array.size
schemer.valid_schema? #: bool
schemer.validate_schema.to_a.size
# @type var own_schema_basic: Hash[String, untyped]
own_schema_basic = schemer.validate_schema(output_format: "detailed")
own_schema_basic.size
# @type var own_schema_array: Array[JSONSchemer::error]
own_schema_array = schemer.validate_schema(resolve_enumerators: true)
own_schema_array.size

# subschemas and bundling
defs_schemer = JSONSchemer.schema({ "type" => "integer", "$defs" => { "foo" => { "type" => "string" } } })
sub_schemer = defs_schemer.ref("#/$defs/foo")
sub_schemer.validate(1).to_a.size
defs_schemer.bundle
defs_schemer.value
defs_schemer.root.valid?(1)
defs_schemer.parent&.valid?(1)

# options
refs = {
  URI("http://example.com/schema/one") => { "type" => "integer" }
}

JSONSchemer.schema(
  schema_hash,
  meta_schema: "https://json-schema.org/draft/2020-12/schema",
  format: true,
  formats: {
    "int32" => proc { |instance, _format| Integer === instance && instance.bit_length <= 32 },
    "email" => false,
    "even" => ->(instance, _format) { Integer === instance && instance.even? }
  },
  content_encodings: {
    "urlsafe" => proc { |instance| [true, String(instance).reverse] },
    "strict" => ->(instance) { [String(instance).empty?, instance] }
  },
  content_media_types: {
    "text/csv" => proc { |instance| [true, String(instance).split(",")] }
  },
  insert_property_defaults: :symbol,
  before_property_validation: proc { |data, property, _property_schema, _parent| Hash(data)[property] ||= 42 },
  after_property_validation: [
    proc { |data, property, _property_schema, _parent| Hash(data)[property] },
    ->(data, property, _property_schema, _parent) { Hash(data).delete(property) }
  ],
  ref_resolver: refs.to_proc,
  regexp_resolver: "ecma",
  output_format: "classic",
  resolve_enumerators: false,
  access_mode: nil
)

JSONSchemer.schema({ "$ref" => "http://example.com/schema/one" }, ref_resolver: refs.to_proc)
JSONSchemer.schema(schema_hash, ref_resolver: ->(uri) { refs.fetch(uri) }, regexp_resolver: ->(pattern) { Regexp.new(pattern) })
JSONSchemer.schema(schema_hash, insert_property_defaults: true, resolve_enumerators: true, output_format: "verbose")

# meta schemas
[
  JSONSchemer.draft202012,
  JSONSchemer.draft201909,
  JSONSchemer.draft7,
  JSONSchemer.draft6,
  JSONSchemer.draft4,
  JSONSchemer.openapi31,
  JSONSchemer.openapi30
].each do |meta_schema|
  meta_schema.valid?({})
end

# OpenAPI documents
document = JSONSchemer.openapi(
  {
    "openapi" => "3.1.0",
    "info" => { "title" => "example" },
    "components" => { "schemas" => { "example" => { "type" => "integer" } } }
  },
  meta_schema: "https://spec.openapis.org/oas/3.1/dialect/base",
  format: false,
  formats: {},
  ref_resolver: refs.to_proc,
  regexp_resolver: "ecma",
  output_format: "classic",
  access_mode: "read"
)
document.valid? #: bool
document.validate.to_a.size
# @type var document_array: Array[JSONSchemer::error]
document_array = document.validate(resolve_enumerators: true)
document_array.size
# @type var document_basic: Hash[String, untyped]
document_basic = document.validate(output_format: "basic")
document_basic.size
document.schema("example").valid?(1)
document.ref("#/components/schemas/example").valid?("one")

# global configuration
JSONSchemer.configure do |config|
  config.regexp_resolver = "ecma"
  config.to_a.size
  config.meta_schema = JSONSchemer.draft7
  config.format = true
  config.formats = {}
  config.content_encodings = {}
  config.content_media_types = {}
  config.before_property_validation = proc { |data, property, _property_schema, _parent| Hash(data)[property] }
  config.after_property_validation = []
  config.ref_resolver = refs.to_proc
  config.output_format = "classic"
  config.resolve_enumerators = false
  config.access_mode = nil
end
JSONSchemer.configuration.insert_property_defaults = true
JSONSchemer.configuration.insert_property_defaults #: bool | :symbol
JSONSchemer.configuration.regexp_resolver
JSONSchemer.configuration.meta_schema
JSONSchemer.configuration.format #: bool
JSONSchemer.configuration.formats.size
JSONSchemer.configuration.content_encodings.size
JSONSchemer.configuration.content_media_types.size
JSONSchemer.configuration.before_property_validation
JSONSchemer.configuration.after_property_validation
JSONSchemer.configuration.ref_resolver
JSONSchemer.configuration.output_format.upcase
JSONSchemer.configuration.resolve_enumerators #: bool
JSONSchemer.configuration.access_mode&.upcase

# error messages
schemer.validate({ "abc" => "x" }).each do |error|
  JSONSchemer::Errors.pretty(error).upcase
end

# exceptions
begin
  JSONSchemer.schema({ "$ref" => "http://example.com/unknown" }, ref_resolver: refs.to_proc).valid?(1)
rescue JSONSchemer::UnknownRef, JSONSchemer::InvalidRefResolution, JSONSchemer::InvalidRefPointer => e
  e.message.upcase
rescue JSONSchemer::UnknownFormat, JSONSchemer::UnknownVocabulary, JSONSchemer::UnknownContentEncoding, JSONSchemer::UnknownContentMediaType => e
  e.message.upcase
rescue JSONSchemer::UnknownOutputFormat, JSONSchemer::InvalidRegexpResolution, JSONSchemer::InvalidFileURI, JSONSchemer::InvalidEcmaRegexp => e
  e.message.upcase
rescue JSONSchemer::UnsupportedOpenAPIVersion => e
  e.message.upcase
end
JSONSchemer::VERSION.upcase

# "net/http" fetches any $ref over HTTP, so it is type checked but never run.
# @type var use_net_http: ^() -> void
use_net_http = -> do
  JSONSchemer.schema(schema_hash, ref_resolver: "net/http")
  JSONSchemer.configuration.ref_resolver = "net/http"
end

# Configuration.new
configuration = JSONSchemer::Configuration.new(
  meta_schema: "https://json-schema.org/draft/2020-12/schema",
  format: false,
  formats: {},
  content_encodings: {},
  content_media_types: {},
  insert_property_defaults: false,
  before_property_validation: [],
  after_property_validation: [],
  ref_resolver: refs.to_proc,
  regexp_resolver: "ecma",
  output_format: "basic",
  resolve_enumerators: false,
  access_mode: "read"
)
# @type var configuration_format: bool
configuration_format = configuration.format
configuration_format
JSONSchemer::Configuration.new.output_format.upcase
