require "graphql"

# generated codes
module Types
  class BaseObject < GraphQL::Schema::Object
  end
  class BaseEdge < Types::BaseObject
  end
  class BaseConnection < Types::BaseObject
    include GraphQL::Types::Relay::ConnectionBehaviors
  end
  class BaseArgument < GraphQL::Schema::Argument
  end
  class BaseField < GraphQL::Schema::Field
    argument_class Types::BaseArgument
  end
  class BaseObject < GraphQL::Schema::Object
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
    field_class Types::BaseField
  end
  class BaseEdge < Types::BaseObject
    include GraphQL::Types::Relay::EdgeBehaviors
  end
  class BaseEnum < GraphQL::Schema::Enum
  end
  class BaseInputObject < GraphQL::Schema::InputObject
    argument_class Types::BaseArgument
  end
  module BaseInterface
    include GraphQL::Schema::Interface
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)

    field_class Types::BaseField
  end
  class BaseScalar < GraphQL::Schema::Scalar
  end
  class BaseUnion < GraphQL::Schema::Union
    edge_type_class(Types::BaseEdge)
    connection_type_class(Types::BaseConnection)
  end
  module NodeType
    include Types::BaseInterface
    include GraphQL::Types::Relay::NodeBehaviors
  end

  # sample query
  class QueryType < Types::BaseObject
    include GraphQL::Types::Relay::HasNodeField
    include GraphQL::Types::Relay::HasNodesField
    field :ping, String, null: false, description: "ping"
    def ping = context[:ping].pong
  end
end

module Mutations
  class BaseMutation < GraphQL::Schema::RelayClassicMutation
    argument_class Types::BaseArgument
    field_class Types::BaseField
    input_object_class Types::BaseInputObject
    object_class Types::BaseObject
  end

  # sample mutation
  class Ping < BaseMutation
    description "ping"
    argument :arg1, String, required: true, description: "arg1"
    argument :arg2, Boolean, required: true, description: "arg2"
  end
end

# sample schema
class MySchema < GraphQL::Schema
  rescue_from(StandardError) do |err|
    raise "error!"
  end
end
