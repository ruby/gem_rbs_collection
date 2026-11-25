# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "uber/version"
require "uber/callable"
require "uber/option"
require "uber/options"
require "uber/inheritable_attr"
require "uber/delegates"
require "uber/builder"

Uber::VERSION.upcase

class Tags
  include Uber::Callable

  def call(_context, *_args)
    [:comment]
  end
end

with_proc = Uber::Option[->(options) { "proc: #{options}" }]
Uber::Option[:name_of_method]
Uber::Option["Static value"]
Uber::Option[Tags.new]
Uber::Option[->(options) { "#{options} #{self}" }, instance_exec: true]
with_proc.call(1) if with_proc.is_a?(Proc)
Uber::Option[Tags.new].is_a?(Uber::Callable)

options = Uber::Options.new(tags: Tags.new, expires_in: 300, ttl: :time_to_live, track: ->(i) { [i] })
options.evaluate(Object.new, 1).size
options.eval(:expires_in)
options.size
options.eval(:track, Object.new, 1)

class Song
  # @dynamic self.properties, self.properties=
  extend Uber::InheritableAttr

  inheritable_attr(:properties).to_proc
  inheritable_attr "guests", clone: false
end

Uber::InheritableAttr.inherit_for(Class.new(Song), :properties)
Song.properties = [:title]
Song.properties&.size
Uber::InheritableAttr::Clone.call([:title]).push(:track)
Uber::InheritableAttr::Clone.call(:title, Uber::InheritableAttr::Clone.uncloneable + [Array]).upcase

class Album
  extend Uber::InheritableAttribute

  inheritable_attr :tracks
end

class SongDecorator
  extend Uber::Delegates

  delegates :@song, :title, :id
  delegates("@song", "artist").instance_method(:artist)

  def initialize(song)
    @song = song
  end
end

class Admin; end

class User
  include Uber::Builder
  extend Uber::Builder::DSL
  extend Uber::Builder::Build

  builds do |options|
    Admin if User.admin?(options)
  end

  builds :builder_method
  builds ->(options) { Admin if User.admin?(options) }

  def self.builder_method(_options)
    nil
  end

  def self.admin?(options)
    options == { admin: true }
  end
end

User.build!(User, {})
User.builders.size
User.builds { |options| self if User.admin?(options) }.size

my_builders = Uber::Builder::Builders.new
my_builders << ->(options) { Admin if User.admin?(options) }
my_builders << :builder_method
my_builders.call(User, admin: true)
