require "active_model_serializers"

module Test
  class Article < ActiveModelSerializers::Model
    attributes :title, :body, :tags
  end

  class Tag < ActiveModelSerializers::Model
    attributes :name
  end

  class ArticleSerializer < ActiveModel::Serializer
    attribute :title, key: :name
    attributes :body, :tag_names

    def tag_names
      object.tags.map(&:name)
    end
  end

  resource = Article.new(title: "Hello", body: "World", tags: [Tag.new(name: "foo"), Tag.new(name: "bar")])
  serialization = ActiveModelSerializers::SerializableResource.new(resource, serializer: ArticleSerializer)
  serialization.to_json
  serialization.as_json
end
