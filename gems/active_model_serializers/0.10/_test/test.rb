require "active_model_serializers"

module Test
  class Author < ActiveModelSerializers::Model
    # @dynamic name, name=, initialize
    attributes :name
  end

  class Category < ActiveModelSerializers::Model
    # @dynamic name, name=, initialize
    attributes :name
  end

  class Article < ActiveModelSerializers::Model
    # @dynamic title, title=, body, body=, tags, tags=, author, author=, category, category=, initialize
    attributes :title, :body, :tags, :author, :category
  end

  class Tag < ActiveModelSerializers::Model
    # @dynamic name, name=, initialize
    attributes :name
  end

  class ArticleSerializer < ActiveModel::Serializer
    type :article

    attribute :title
    attribute :title, key: :name
    attributes :body, :tag_names

    def tag_names
      object.tags.map(&:name)
    end

    has_many :tags, serializer: TagSerializer
    has_one :author
    belongs_to :category
  end

  class TagSerializer < ActiveModel::Serializer
    type :tag

    attribute :name
  end

  resource = Article.new(title: "Hello", body: "World", tags: [Tag.new(name: "foo"), Tag.new(name: "bar")], author: Author.new(name: "John"), category: Category.new(name: "Tech"))
  ArticleSerializer.new(resource).as_json

  serialization = ActiveModelSerializers::SerializableResource.new(resource)
  serialization.to_json
  serialization.as_json

  serialization_json = ActiveModelSerializers::SerializableResource.new(resource, adapter: :json)
  serialization_json.to_json
end
