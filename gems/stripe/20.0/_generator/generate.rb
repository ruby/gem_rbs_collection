# Generates gems/stripe/<version>/stripe/**/*.rbs from the Sorbet RBI files
# in stripe-ruby. The hand-written part lives in ../stripe.rbs and is not touched.
#
#   ruby _generator/generate.rb <stripe-version>
#   ruby _generator/generate.rb --src-dir <stripe-ruby-checkout> [--spec <openapi.spec3.json>]
#
# Inputs:
# - stripe-ruby at the release tag, rather than the released gem, because the
#   gem ships only part of rbi/ (e.g. stripe_event_notification_handler.rbi).
# - The public OpenAPI spec (stripe/openapi latest/openapi.spec3.json) at the
#   tag named by stripe-ruby's OPENAPI_VERSION. The RBI is generated from the
#   SDK flavour of the spec, which also carries deprecated and unreleased
#   fields; the public one matches what https://docs.stripe.com/api documents.
#
# Policy:
# - Only what the public spec documents is kept: resources missing from it and
#   fields missing from their schema are dropped.
# - Doc comments, instance variables and private methods are dropped.
# - Types follow what the SDK returns at runtime where the RBI disagrees
#   (Hash fields are StripeObjects, event payloads are untyped).
# - `*Params` classes (subclasses of Stripe::RequestParams) are dropped, and
#   `(XxxParams | Hash[untyped, untyped])` arguments collapse to the Hash side.
#   Typed params can be re-added later as overloads on request.
# - Methods without a sig (e.g. inner_class_types) are skipped by
#   `rbs prototype rbi`, which is intended: they are SDK internals.

require "rbs"
require "json"
require "net/http"
require "optparse"
require "fileutils"
require "tmpdir"

REPO = "https://github.com/stripe/stripe-ruby.git"
SPEC_URL = "https://raw.githubusercontent.com/stripe/openapi/%s/latest/openapi.spec3.json"
GEM_DIR = File.expand_path("..", __dir__)
OUT_DIR = File.join(GEM_DIR, "stripe")

M = RBS::AST::Members
D = RBS::AST::Declarations
T = RBS::Types

REQUEST_PARAMS = RBS::TypeName.parse("::Stripe::RequestParams")
REQUEST_OPTS = T::Alias.new(name: RBS::TypeName.parse("::Stripe::request_opts"), args: [], location: nil)
COLLECTIONS = %w[::Stripe::ListObject ::Stripe::SearchResultObject ::Stripe::V2::ListObject].map { RBS::TypeName.parse(_1) }.freeze
INTERNAL_SINGLETON_METHODS = %i[inner_class_types field_remappings].freeze
# Present on every resource for deleted objects, but only in deleted_* schemas.
IMPLICIT_FIELDS = %i[deleted].freeze

def parse_options(argv)
  opts = {}
  OptionParser.new do |o|
    o.on("--src-dir DIR") { opts[:src_dir] = _1 }
    o.on("--spec FILE") { opts[:spec] = _1 }
  end.parse!(argv)
  opts[:version] = argv[0]
  abort "usage: generate.rb (<stripe-version> | --src-dir DIR) [--spec FILE]" unless opts[:src_dir] || opts[:version]
  opts
end

def with_src_dir(opts)
  return yield opts[:src_dir] if opts[:src_dir]
  Dir.mktmpdir do |tmp|
    system("git", "-c", "advice.detachedHead=false", "clone", "--quiet", "--depth", "1", "--branch", "v#{opts[:version]}", REPO, tmp, exception: true)
    yield tmp
  end
end

def load_spec(opts, src)
  return JSON.parse(File.read(opts[:spec])) if opts[:spec]
  tag = File.read(File.join(src, "OPENAPI_VERSION")).strip
  res = Net::HTTP.get_response(URI(format(SPEC_URL, tag)))
  raise "failed to fetch spec #{tag}: #{res.code}" unless res.is_a?(Net::HTTPSuccess)
  JSON.parse(res.body)
end

def class_type(name)
  T::ClassInstance.new(name: name, args: [], location: nil)
end

def container?(decl)
  decl.is_a?(D::Class) || decl.is_a?(D::Module)
end

# Applies the block to every class/module, passing its absolute name.
def map_containers(decls, namespace = RBS::Namespace.root, &block)
  decls.map do |d|
    next d unless container?(d)
    name = d.name.with_prefix(namespace).absolute!
    d = d.update(members: map_containers(d.members, name.to_namespace, &block))
    block.call(d, name)
  end
end

def each_container(decls, namespace = RBS::Namespace.root, &block)
  decls.each do |d|
    next unless container?(d)
    name = d.name.with_prefix(namespace).absolute!
    block.call(d, name)
    each_container(d.members, name.to_namespace, &block)
  end
end

def map_method_types(decl)
  decl.update(overloads: decl.overloads.map { |o| o.update(method_type: yield(o.method_type)) })
end

# Comment-only lines are removed before parsing so no doc ends up in the RBS.
def parse(path, parser)
  parser.parse(File.read(path).gsub(/^\s*#.*\n/, ""))
  parser.decls
end

def drop_non_public(decls)
  map_containers(decls) do |d, _|
    visibility = :public
    members = d.members.filter_map do |m|
      case m
      when M::Private then visibility = :private; nil
      when M::Public then visibility = :public; nil
      when M::InstanceVariable, M::ClassInstanceVariable, M::ClassVariable then nil
      when M::MethodDefinition
        next if (m.visibility || visibility) == :private
        next if m.singleton? && INTERNAL_SINGLETON_METHODS.include?(m.name)
        m
      when M::Attribute
        (m.visibility || visibility) == :private ? nil : m
      else m
      end
    end
    d.update(members: members)
  end
end

## Params

def params_class?(decl)
  decl.is_a?(D::Class) && decl.super_class&.name&.absolute! == REQUEST_PARAMS
end

def collect_params(files)
  found = []
  files.each_value { |decls| each_container(decls) { |d, name| found << name if params_class?(d) } }
  found.to_set
end

def drop_params(decls)
  decls.filter_map do |d|
    next if params_class?(d)
    next d unless container?(d)
    members = drop_params(d.members)
    d.update(members: members) unless members.empty? && d.is_a?(D::Module)
  end
end

def strip_params_type(type, params)
  case type
  when T::Union
    rest = type.types
      .reject { _1.is_a?(T::ClassInstance) && params.include?(_1.name.absolute!) }
      .map { strip_params_type(_1, params) }
    rest.size == 1 ? rest[0] : T::Union.new(types: rest, location: type.location)
  when T::ClassInstance
    raise "bare params type remains: #{type}" if params.include?(type.name.absolute!)
    type
  else
    type.respond_to?(:map_type) ? type.map_type { strip_params_type(_1, params) } : type
  end
end

def rewrite_params(decls, params)
  map_containers(drop_params(decls)) do |d, _|
    d.update(members: d.members.map do |m|
      case m
      when M::MethodDefinition then map_method_types(m) { |mt| mt.map_type { strip_params_type(_1, params) } }
      when M::Attribute then m.update(type: strip_params_type(m.type, params))
      else m
      end
    end)
  end
end

## opts

def type_opts(decls)
  map_containers(decls) do |d, _|
    d.update(members: d.members.map do |m|
      next m unless m.is_a?(M::MethodDefinition)
      map_method_types(m) do |mt|
        f = mt.type
        retype = ->(params) { params.map { _1.name == :opts && _1.type.is_a?(T::Bases::Any) ? _1.map_type { REQUEST_OPTS } : _1 } }
        mt.update(type: f.update(required_positionals: retype.(f.required_positionals), optional_positionals: retype.(f.optional_positionals)))
      end
    end)
  end
end

## Services

# Service RBIs declare sub-service readers without a sig (`attr_reader :customers`),
# which would make `client.v1.customers` untyped. The Ruby source assigns each
# one as `@customers = Stripe::CustomerService.new(@requestor)`, so read it there.
def type_service_readers(decls, rb_path)
  return decls unless File.exist?(rb_path)
  types = File.read(rb_path).scan(/@(\w+) = ([A-Z][\w:]*)\s*\.new\(/).to_h do |ivar, klass|
    [ivar.to_sym, class_type(RBS::TypeName.parse("::#{klass}"))]
  end
  map_containers(decls) do |d, _|
    d.update(members: d.members.map do |m|
      m.is_a?(M::AttrReader) && m.type.is_a?(T::Bases::Any) && types[m.name] ? m.update(type: types[m.name]) : m
    end)
  end
end

## Events

# lib/stripe/events has no RBI, but stripe_event_notification_handler.rbi refers
# to its classes, and users dispatch on them with `instance_of?`. Only the
# notification's related_object (id and url) has a type worth stating: what
# fetch_related_object returns depends on the event type, which neither the
# source nor the public spec spells out, so it stays untyped for callers to
# annotate. Nested *EventData classes only back the untyped `data` reader.
def event_decls(rb_path)
  source = File.read(rb_path)
  notification_related = source[/def related_object_class\s+([A-Z][\w:]*)/, 1]
  notification_related = notification_related ? "::#{notification_related}" : "::Stripe::V2::Core::RelatedObject"
  untyped = T::Bases::Any.new(location: nil)

  map_containers(parse(rb_path, RBS::Prototype::RB.new)) do |d, _|
    next d unless d.is_a?(D::Class) && d.super_class
    related =
      case d.super_class.name.to_s.delete_prefix("::")
      when "Stripe::V2::Core::EventNotification" then class_type(RBS::TypeName.parse(notification_related))
      when "Stripe::V2::Core::Event" then untyped
      end
    next d unless related

    d.update(members: d.members.filter_map do |m|
      next if m.is_a?(D::Class)
      if m.is_a?(M::AttrReader) && m.name == :related_object
        m.update(type: related)
      elsif m.is_a?(M::MethodDefinition) && m.name == :fetch_related_object
        map_method_types(m) { |mt| mt.update(type: mt.type.with_return_type(untyped)) }
      else
        m
      end
    end)
  end
end

## Blocks

# Sorbet's T::Boolean block results become `bool`, but a block's result is only
# tested for truthiness (RBS/Style/BlockReturnBoolish).
def boolish_block_returns(decls)
  boolish = T::Alias.new(name: RBS::TypeName.parse("::boolish"), args: [], location: nil)
  map_containers(decls) do |d, _|
    d.update(members: d.members.map do |m|
      next m unless m.is_a?(M::MethodDefinition)
      map_method_types(m) do |mt|
        block = mt.block
        next mt unless block && block.type.return_type.is_a?(T::Bases::Bool)
        mt.update(block: T::Block.new(type: block.type.with_return_type(boolish), required: block.required, self_type: block.self_type))
      end
    end)
  end
end

## Hash fields

# The RBI types map-like fields (metadata, currency_options, ...) as Hash after
# the spec, but the SDK turns every response Hash into a StripeObject: keys are
# Symbols, and Hash-only methods such as fetch, key? or dig raise NoMethodError.
def hash_fields_as_stripe_object(decls)
  stripe_object = class_type(RBS::TypeName.parse("::Stripe::StripeObject"))
  to_stripe_object = lambda do |type|
    case type
    when T::Optional then type.map_type { to_stripe_object.(_1) }
    when T::ClassInstance then type.name.to_s == "::Hash" ? stripe_object : type
    else type
    end
  end
  map_containers(decls) do |d, _|
    d.update(members: d.members.map do |m|
      next m unless getter?(m)
      map_method_types(m) { |mt| mt.update(type: mt.type.with_return_type(to_stripe_object.(mt.type.return_type))) }
    end)
  end
end

# event.data.object holds whichever resource the event is about (e.g. a
# Stripe::Checkout::Session), and Stripe's webhook samples call methods on it
# without narrowing first, so it is left for callers to annotate.
UNTYPED_GETTERS = {
  RBS::TypeName.parse("::Stripe::Event::Data") => %i[object],
}.freeze

def untype_getters(decls)
  map_containers(decls) do |d, name|
    names = UNTYPED_GETTERS[name] or next d
    d.update(members: d.members.map do |m|
      next m unless m.is_a?(M::MethodDefinition) && names.include?(m.name)
      map_method_types(m) { |mt| mt.update(type: mt.type.with_return_type(T::Bases::Any.new(location: nil))) }
    end)
  end
end

## OpenAPI

class Spec
  attr_reader :object_classes

  def initialize(json, src)
    @json = json
    @schemas = json["components"]["schemas"]
    @paths = json["paths"].transform_keys { normalize_path(_1) }
    # Resource classes declare which schema they are via OBJECT_NAME.
    @object_classes = Dir.glob("#{src}/lib/stripe/resources/**/*.rb").filter_map do |path|
      source = File.read(path)
      object = source[/OBJECT_NAME = "([^"]+)"/, 1] or next
      modules = source.scan(/^\s*module (\w+)$/).flatten
      klass = source[/^\s*class (\w+) </, 1]
      [RBS::TypeName.parse("::#{(modules + [klass]).join("::")}"), object]
    end.to_h
    @class_by_object = @object_classes.invert
  end

  def schema(object) = @schemas[object]

  # Object schemas a property can hold, through $ref, anyOf and arrays.
  def object_schemas(prop)
    return [] unless prop
    return object_schemas(resolve(prop)) if prop["$ref"]
    return prop["anyOf"].flat_map { object_schemas(_1) } if prop["anyOf"]
    return object_schemas(prop["items"]) if prop["type"] == "array"
    prop["properties"] ? [prop] : []
  end

  # Element type of a list-shaped schema (`{ data: [...] }`), or nil.
  def list_element(prop)
    items = object_schemas(prop).filter_map { _1.dig("properties", "data", "items") }.first or return nil
    refs = items["anyOf"] || [items]
    types = refs.map { (name = _1["$ref"]&.split("/")&.last) && @class_by_object[name] }
    return nil if types.empty? || types.any?(&:nil?)
    types = types.uniq.map { class_type(_1) }
    types.size == 1 ? types[0] : T::Union.new(types: types, location: nil)
  end

  def response_element(http_method, path)
    op = @paths.dig(normalize_path(path), http_method) or return nil
    list_element(op.dig("responses", "200", "content", "application/json", "schema"))
  end

  private

  def resolve(prop) = @json.dig(*prop["$ref"].delete_prefix("#/").split("/"))

  def normalize_path(path) = path.gsub(/\{[^}]*\}|%<\w+>s/, "{}")
end

# HTTP method and path each API method calls, read from the generated Ruby
# source, keyed by [method name, singleton?].
def request_paths(rb_path)
  return {} unless File.exist?(rb_path)
  current = nil
  File.foreach(rb_path).each_with_object({}) do |line, paths|
    if (m = line.match(/^\s*def (self\.)?(\w+[?!]?)/))
      current = [m[2].to_sym, !m[1].nil?]
      next
    end
    next unless current
    if (m = line.match(/method: :(\w+)/))
      (paths[current] ||= {})[:method] ||= m[1]
    end
    if (m = line.match(/path: (?:format\()?"([^"]+)"/))
      (paths[current] ||= {})[:path] ||= m[1]
    end
  end
end

def getter?(m)
  m.is_a?(M::MethodDefinition) && m.kind == :instance &&
    m.overloads.all? { |o| o.method_type.block.nil? && o.method_type.type.empty? }
end

def collection_type?(type)
  type.is_a?(T::ClassInstance) && type.args.empty? && COLLECTIONS.include?(type.name.absolute!)
end

def specialize(type, elem)
  case type
  when T::Optional then type.map_type { specialize(_1, elem) }
  else collection_type?(type) ? type.class.new(name: type.name, args: [elem], location: type.location) : type
  end
end

def returns_collection?(m)
  m.overloads.any? { |o| t = o.method_type.type.return_type; collection_type?(t) || (t.is_a?(T::Optional) && collection_type?(t.type)) }
end

def with_element(m, elem)
  map_method_types(m) do |mt|
    mt = mt.update(type: mt.type.with_return_type(specialize(mt.type.return_type, elem)))
    next mt unless mt.block
    # search_auto_paging_each's RBI declares its block without the element.
    block_type = mt.block.type.update(required_positionals: [T::Function::Param.new(type: elem, name: nil)], return_type: T::Bases::Void.new(location: nil))
    mt.update(block: T::Block.new(type: block_type, required: mt.block.required, self_type: mt.block.self_type))
  end
end

def nested_names(type, acc = [])
  case type
  when T::ClassInstance then acc << type.name.name if type.name.namespace.relative? && type.name.namespace.empty?
  end
  type.each_type { nested_names(_1, acc) } if type.respond_to?(:each_type)
  acc
end

class Documenter
  attr_reader :dropped_fields, :dropped_classes, :unresolved

  def initialize(spec)
    @spec = spec
    @dropped_fields = []
    @dropped_classes = []
    @unresolved = []
  end

  # Drops resources the public spec doesn't have, filters fields of the rest
  # (recursing into nested classes alongside their property schemas), and fills
  # in collection element types.
  def apply(decls, paths)
    decls = map_containers(decls) do |d, name|
      object = @spec.object_classes[name]
      next type_methods(d, name, paths) unless object
      schema = @spec.schema(object)
      next (@dropped_classes << name; nil) unless schema
      filter(d, name, [schema], paths)
    end
    decls.filter_map { prune(_1) }
  end

  private

  # Dropped classes leave nils behind in their parent's members, and possibly
  # modules with nothing left in them.
  def prune(decl)
    return decl unless container?(decl)
    members = decl.members.filter_map { container?(_1) ? prune(_1) : _1 }
    decl.update(members: members) unless members.empty? && decl.is_a?(D::Module)
  end

  # Fields are left to #filter, which sees them along with their schema once
  # the enclosing resource is reached.
  def type_methods(decl, name, paths)
    decl.update(members: decl.members.map do |m|
      next m unless m.is_a?(M::MethodDefinition) && !getter?(m) && returns_collection?(m)
      type_collection(m, name) { method_element(m, paths) }
    end)
  end

  def filter(decl, name, schemas, paths)
    # A property can be an anyOf of several object schemas, and each of them
    # may define the same field differently, so keep every candidate.
    props = Hash.new { |h, k| h[k] = [] }
    schemas.each { |s| (s["properties"] || {}).each { |k, v| props[k] << v } }
    kept_nested = Set.new
    dropped_nested = Set.new

    members = decl.members.filter_map do |m|
      if getter?(m) && !IMPLICIT_FIELDS.include?(m.name)
        candidates = props.fetch(m.name.to_s, [])
        nested = m.overloads.flat_map { nested_names(_1.method_type.type.return_type) }
        if candidates.empty?
          @dropped_fields << "#{name}##{m.name}"
          dropped_nested.merge(nested)
          next
        end
        candidates.each { |prop| kept_nested.merge(nested.map { [_1, prop] }) }
        next type_collection(m, name) { candidates.lazy.filter_map { @spec.list_element(_1) }.first } if returns_collection?(m)
      elsif m.is_a?(M::MethodDefinition) && returns_collection?(m)
        next type_collection(m, name) { method_element(m, paths) }
      end
      m
    end

    nested_props = kept_nested.group_by(&:first).transform_values { |pairs| pairs.map(&:last) }
    members = members.filter_map do |m|
      next m unless m.is_a?(D::Class)
      nested_name = m.name.name
      if nested_props.key?(nested_name)
        sub = nested_props[nested_name].flat_map { @spec.object_schemas(_1) }
        sub.empty? ? m : filter(m, m.name.with_prefix(name.to_namespace).absolute!, sub, {})
      elsif dropped_nested.include?(nested_name)
        nil
      else
        m
      end
    end
    decl.update(members: members)
  end

  def method_element(m, paths)
    name = m.name == :search_auto_paging_each ? :search : m.name
    request = paths[[name, m.singleton?]] or return nil
    @spec.response_element(request[:method], request[:path]) if request[:method] && request[:path]
  end

  def type_collection(m, owner)
    elem = yield
    return with_element(m, elem) if elem
    @unresolved << "#{owner}#{m.singleton? ? "." : "#"}#{m.name}"
    m
  end
end

## Main

opts = parse_options(ARGV)
with_src_dir(opts) do |src|
  spec = Spec.new(load_spec(opts, src), src)
  rbi_root = File.join(src, "rbi")
  files = Dir.glob("#{rbi_root}/stripe/**/*.rbi").sort.to_h do |path|
    [path.delete_prefix("#{rbi_root}/").sub(/\.rbi\z/, ".rbs"), parse(path, RBS::Prototype::RBI.new)]
  end
  params = collect_params(files)
  files.transform_values! { rewrite_params(_1, params) }
  files.each_key do |rel|
    next unless rel.start_with?("stripe/services/")
    files[rel] = type_service_readers(files[rel], File.join(src, "lib", rel.sub(/\.rbs\z/, ".rb")))
  end
  Dir.glob("#{src}/lib/stripe/events/*.rb").sort.each do |path|
    files["stripe/events/#{File.basename(path, ".rb")}.rbs"] = event_decls(path)
  end
  files.transform_values! { boolish_block_returns(untype_getters(hash_fields_as_stripe_object(type_opts(drop_non_public(_1))))) }

  documenter = Documenter.new(spec)
  files.each_key do |rel|
    files[rel] = documenter.apply(files[rel], request_paths(File.join(src, "lib", rel.sub(/\.rbs\z/, ".rb"))))
  end
  files.reject! { |_, decls| decls.empty? }

  FileUtils.rm_rf(OUT_DIR)
  files.each do |rel, decls|
    dest = File.join(GEM_DIR, rel)
    FileUtils.mkdir_p(File.dirname(dest))
    File.open(dest, "w") { RBS::Writer.new(out: _1).write(decls) }
  end

  warn "params classes dropped: #{params.size}, files written: #{files.size}"
  warn "resources not in the public spec (#{documenter.dropped_classes.size}):", *documenter.dropped_classes.map { "  #{_1}" }
  warn "fields not in the public spec (#{documenter.dropped_fields.size}):", *documenter.dropped_fields.map { "  #{_1}" }
  warn "collections left as untyped elements (#{documenter.unresolved.size}):", *documenter.unresolved.map { "  #{_1}" }
end
