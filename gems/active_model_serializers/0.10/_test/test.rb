require "active_model_serializers"

module Test
  class Article < ActiveModelSerializers::Model
    # @dynamic title, title=, body, body=, tags, tags=, initialize
    attributes :title, :body, :tags
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
  end

  resource = Article.new(title: "Hello", body: "World", tags: [Tag.new(name: "foo"), Tag.new(name: "bar")])
  ArticleSerializer.new(resource).as_json

  serialization = ActiveModelSerializers::SerializableResource.new(resource)
  serialization.to_json
  serialization.as_json

  serialization_json = ActiveModelSerializers::SerializableResource.new(resource, adapter: :json)
  serialization_json.to_json
end
