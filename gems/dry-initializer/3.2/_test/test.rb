require "dry-initializer"

class User
  extend Dry::Initializer

  # @dynamic initialize, name, role, admin, phone, tel

  param  :name,  :to_s.to_proc
  param  :role,  default: proc { "customer" }
  option :admin, default: proc { false }
  option :phone, optional: true
  option :telefon, optional: true, as: :tel
  option :token, optional: true, reader: :private
  option :password, optional: true, reader: false
end

user = User.new "Vladimir", "admin", admin: true
user.name
user.role
user.admin
user.phone
user.tel

config = User.dry_initializer
config.attributes(user).keys
config.public_attributes(user).fetch(:name)
config.params.map(&:source)
config.options.map(&:target)
config.definitions.fetch(:name).optional
config.definitions.fetch(:role).default
config.extended_class
config.parent
config.null

class Admin < User
  # @dynamic initialize, permissions

  param :permissions, default: proc { [] }
end

Admin.new("Joe").permissions
Admin.dry_initializer.parent&.extended_class

class Article
  extend Dry::Initializer[undefined: false]

  # @dynamic initialize, tags, author

  option :tags, [:to_s.to_proc], optional: true

  option :author, optional: true do
    option :name, :to_s.to_proc
  end
end

Article.new(tags: :ruby, author: { name: "Joe" }).tags

class Container
  # @dynamic initialize, name, admin

  include Dry::Initializer.define -> do
    param  :name, :to_s.to_proc
    option :admin, default: proc { false }
  end
end

Container.new("Joe", admin: true).name

class Point < Dry::Initializer::Struct
  # @dynamic x, y

  option :x
  option :y
end

Point.new(x: 1, "y" => 2).to_h.fetch("x")
Point.call(x: 1, y: 2)

class IntegerDispatcher
  def call(integer: false, **opts)
    integer ? opts.merge(type: :to_i.to_proc) : opts
  end
end

Dry::Initializer::Dispatchers << IntegerDispatcher.new
