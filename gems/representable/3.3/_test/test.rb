require "representable/json"
require "representable/xml"
require "representable/yaml"
require "representable/decorator"
require "representable/json/collection"

class Song
  # @dynamic title, title=, track, track=, composers, composers=
  attr_accessor :title, :track, :composers

  def initialize(title = nil, track = nil)
    @title = title
    @track = track
  end
end

class SongRepresenter < Representable::Decorator
  include Representable::JSON

  self.representation_wrap = :song
  property :title
  property :track, as: :number
  collection :composers, render_empty: false
  nested :details do
    property :track
  end
end

class SongXMLRepresenter < Representable::Decorator
  include Representable::XML

  property :title, attribute: true
  collection :composers, as: :composer
end

class SongYAMLRepresenter < Representable::Decorator
  include Representable::YAML

  property :title
end

module SongHashRepresenter
  include Representable::Hash

  property :title
  hash :extra, render_nil: false
end

class SongsRepresenter < Representable::Decorator
  include Representable::JSON::Collection

  items decorator: SongRepresenter, class: Song
end

song = Song.new("Roxanne", 1)
song.composers = ["Sting"]

representer = SongRepresenter.new(song)
# @type var json: String
json = representer.to_json
representer.to_json(wrap: false, user_options: { admin: true })
# @type var hash: Hash[untyped, untyped] | Array[untyped]
hash = representer.to_hash(exclude: [:track])
representer.render
SongRepresenter.new(Song.new).from_json(json)
SongRepresenter.new(Song.new).from_hash({ "song" => { "title" => "Roxanne" } })
SongRepresenter.new(Song.new).parse(json)
representer.represented
representer.decorated
SongRepresenter.prepare(song).to_hash
SongRepresenter.represent([song])
SongsRepresenter.new([song]).to_json
SongRepresenter.for_collection.new([song]).represented

# @type var xml: String
xml = SongXMLRepresenter.new(song).to_xml
SongXMLRepresenter.new(Song.new).from_xml(xml)
SongXMLRepresenter.new(song).to_node
SongXMLRepresenter.remove_namespaces!

# @type var yaml: String
yaml = SongYAMLRepresenter.new(song).to_yaml
SongYAMLRepresenter.new(Song.new).from_yaml(yaml)
SongYAMLRepresenter.new(song).to_ast

# @type var prepared: Song
prepared = SongHashRepresenter.prepare(Song.new("Message in a Bottle"))
SongHashRepresenter.represent(prepared)

# @type var definition: Declarative::Definitions::Definition?
definition = SongRepresenter.definitions.get(:title)
SongRepresenter.representable_attrs.remove(:track)
# @type var name: String
name = Representable::Definition.new(:title, as: "Title").name
Representable::Definition.new(:title) { |options| options[:render_nil] = true }.merge!(as: "name").setter
# @type var format: singleton(Representable::Hash)
format = SongRepresenter.format_engine
# @type var binding: Representable::Hash::Binding
binding = Representable::Hash::Binding.build_for(Representable::Definition.new(:title))
binding.read({ "title" => "Roxanne" }, "title")
binding.write({}, "Roxanne", "title")
binding.skipable_empty_value?(nil)
# @type var generic: Representable::Binding
generic = Representable::Hash::Binding.build(Representable::Definition.new(:track))
generic.name
