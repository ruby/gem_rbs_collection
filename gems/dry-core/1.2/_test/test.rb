require "dry/core"
require "dry/core/container/stub"

# @type var empty: Array[untyped]
empty = Dry::Core::Constants::EMPTY_ARRAY
empty.empty?
Dry::Core::EMPTY_HASH.empty?
Dry::Core::Constants::EMPTY_STRING.empty?
Dry::Core::Constants::EMPTY_SET.empty?
Dry::Core::Constants::EMPTY_OPTS.empty?
Dry::Core::Constants::IDENTITY.call(1)

undefined = Dry::Core::Constants::Undefined
# @type var value: Integer | Dry::Core::Constants::undefined
value = undefined
# @type var picked: Integer
picked = undefined.default(value, 2)
# @type var from_block: Integer | String
from_block = undefined.default(value) { "none" }
undefined.default(value, undefined) { 3 }
# @type var mapped: Integer | Dry::Core::Constants::undefined
mapped = undefined.map(value) { |x| x + 1 }
# @type var first: Integer | Dry::Core::Constants::undefined
first = undefined.coalesce(undefined, 1, 2)
undefined.equal?(picked)
undefined.equal?(mapped)
undefined.equal?(first)
# @type var name: String
name = undefined.to_s
name.upcase
Dry::Core::Constants::Self.call

class Settings
  extend Dry::Core::ClassAttributes

  defines :adapter, type: Symbol
  defines :timeout, coerce: proc { |v| Integer(v) }
end

class Calculator
  extend Dry::Core::Cache
  include Dry::Core::Cache::Methods

  def sum(left, right)
    # @type var result: Integer
    result = fetch_or_store(left, right) { left + right }
    result
  end
end

# @type var computed: String
computed = Calculator.fetch_or_store(:a) { "computed" }
computed.upcase
Calculator.new.sum(1, 2)

class Point
  include Dry::Core::Equalizer::Methods

  def x = @x
  def y = @y

  def initialize(x, y)
    @x = x
    @y = y
  end
end
Point.include(Dry.Equalizer(:x, :y))

# @type var same: bool
same = Point.new(1, 2) == Point.new(1, 2)
Point.new(1, 2).eql?(Point.new(1, 2))
# @type var equalizer: Dry::Core::Equalizer
equalizer = Dry::Core.Equalizer(:x, inspect: false, immutable: true)
Dry::Core::Equalizer.new(:x)

# @type var klass: Class
klass = Dry::Core::ClassBuilder.new(name: "Widget", parent: Object).call { |k| k.name }
klass.new

class Service
  extend Dry::Core::Deprecations::Interface

  def old_call; end
  def new_call; end

  deprecate :old_call, :new_call, message: "use new_call"
end
Service.extend(Dry::Core::Deprecations[:my_gem])

Dry::Core::Deprecations.warn("message", tag: :my_gem)
Dry::Core::Deprecations.announce(:old_api, "use new_api")
# @type var logger: Logger
logger = Dry::Core::Deprecations.set_logger!(Logger.new($stdout))
logger.level
Dry::Core::Deprecations.logger.warn("hello")

class Base
  extend Dry::Core::DescendantsTracker
end

# @type var descendants: Array[Class]
descendants = Base.descendants
descendants.size

class Plugin
  extend Dry::Core::Extensions

  register_extension(:json) { nil }
end

# @type var available: bool
available = Plugin.available_extension?(:json)
Plugin.load_extensions(:json)

class Report
  include Dry::Core::Memoizable
  extend Dry::Core::Memoizable::ClassInterface::Object

  def total
    1 + 1
  end
  memoize :total
end

Report.new.total

container = Dry::Core::Container.new
container.register(:name, "dry")
container.register(:lazy) { "value" }
container.register(:proc, call: false) { |x| x }
container.namespace(:db) do
  register(:url, "postgres://")
end
container.namespace(:cache) do |ns|
  ns.register(:url, "redis://")
end
# @type var resolved: String
resolved = container.resolve(:name)
container[:lazy]
container.resolve(:missing) { |key| key.to_s }
# @type var registered: bool
registered = container.key?(:name)
# @type var keys: Array[String]
keys = container.keys
container.each_key { |key| key.upcase }
container.each { |key, item| [key, item] }
container.decorate(:name) { |item| "<#{item}>" }
container.import(Dry::Core::Container::Namespace.new(:ext) { register(:a, 1) })
container.merge(Dry::Core::Container.new, namespace: :other)
# @type var stubbed: Dry::Core::Container
stubbed = container.enable_stubs!
stubbed.dup.freeze
resolved.size
keys.size
