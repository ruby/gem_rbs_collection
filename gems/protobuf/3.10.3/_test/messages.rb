module Messages
  class User < Protobuf::Message; end
  class Address < Protobuf::Message; end

  class User
    optional :string, :first_name, 1
    optional :string, :last_name, 2
    optional ::Messages::Address, :address, 3
    optional :bool, :is_active, 4
  end

  class Address
    optional :string, :street, 1
    optional :string, :city, 2
    optional ::Enum::States, :state, 3
    optional :int32, :zip_code, 4
  end

  user = User.new

  user.field?(:first_name)
  user.field?(:address)
  user.field?(:last_name)
  user.respond_to_has_and_present?(:last_name)

  user.encode
  user.encode_to(STDERR)
  user.encode_to([])
  user.encode_to(30)

  User.decode("")
  User.decode_from(STDIN)
  User.decode_from("")

  user.to_hash.___error___
  user.to_json.___error___
end
