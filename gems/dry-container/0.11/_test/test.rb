require "dry-container"

module TestContainer
  extend Dry::Container::Mixin

  register(:item) { "item" }
  register(:memoized, memoize: true) { "memoized" }

  namespace(:nested) do
    register(:item) { "nested item" }
  end
end

TestContainer.resolve(:item) #=> "item"
TestContainer[:memoized] #=> "memoized"
TestContainer.key?(:item) #=> true
TestContainer.keys #=> ["item", "memoized", "nested.item"]

TestContainer.each_key { |key| key }
TestContainer.each { |key, value| [key, value] }

module OtherContainer
  extend Dry::Container::Mixin

  register(:other_item) { "other" }
end
TestContainer.merge(OtherContainer, namespace: :other)

ns = Dry::Container::Namespace.new(:imported) do
  register(:item) { "imported item" }
end
TestContainer.import(ns)

TestContainer.freeze
TestContainer.frozen? #=> true

container = Dry::Container.new
container.register(:item) { "item" }
container.resolve(:item) #=> "item"
