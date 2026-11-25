require "declarative"

class Model
  extend Declarative::Schema

  def self.default_nested_class
    Model
  end
end

module Linkable
end

class Song < Model
  defaults render_nil: true do |name, _options|
    { as: name.to_s.upcase }
  end
  feature Linkable

  property :id
  property :artist, cool: true do
    property :name
    attr_accessor :nested_flag
  end
end

Song.definitions.get(:artist)&.[](:nested)
Song.definitions.each { |definition| definition[:name] }
Song.definition_class.new(:title)

definitions = Declarative::Definitions.new(Declarative::Definitions::Definition)
definition = definitions.add(:title, as: "Title")
definition.merge!(render_nil: true)
definition.merge(as: "TITLE").fetch(:as)
definitions.get("title")&.[](:as)
definitions.each.map { |d| d[:name] }
names = definitions.map { |d| d[:name] } # @type var names: Array[untyped]
found = definitions.find { |d| d.equal?(definitions.get(:id)) } # @type var found: Declarative::Definitions::Definition?
first = definitions.first # @type var first: Declarative::Definitions::Definition?
definitions.each_with_index { |d, i| [d.merge({}), i + 1] }
definitions.group_by { |d| d[:name] }.each_value { |list| list.first }

defaults = Declarative::Defaults.new
defaults.merge!(a: 1).merge!(list: Declarative::Variables::Append([1])) { |name, _options| { as: name.to_s } }
defaults.call(:title, {}).fetch(:a)
Declarative::Defaults.wrap_arrays(list: [1])

options = Declarative::Variables.merge(
  { id: 1, connections: { first: 1 } },
  { connections: Declarative::Variables::Merge(second: 2) }
)
options.fetch(:connections)

heritage = Declarative::Heritage.new
heritage.record(:property, :id, {}).record(:feature, Linkable) { nil }
heritage.call(Song) { |cfg| cfg[:args] }

module Mixin
  extend Declarative::Heritage::DSL
  extend Declarative::Heritage::Included
end
Mixin.heritage.size

Declarative::DeepDup.call({ a: [1] })
Declarative::DeepDup.call([1, { b: 2 }])
Declarative::DeepDup.call(1) + 1
Declarative::VERSION.upcase

