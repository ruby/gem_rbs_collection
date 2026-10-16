# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "msgpack"
require "stringio"

# Serializing and deserializing
msg = [1, 2, 3].to_msgpack
MessagePack.unpack(msg)
packed = MessagePack.pack({ "a" => 1 })
MessagePack.load(packed, symbolize_keys: true)
MessagePack.dump(nil.to_msgpack)
"str".to_msgpack(StringIO.new)

# Streaming serialization
io = StringIO.new
pk = MessagePack::Packer.new(io)
pk.write_array_header(2).write(1).write("e2").flush
pk.full_pack

packer = MessagePack::Packer.new(compatibility_mode: true)
packer.write_map_header(1).write_string("key").write_int(1)
packed_string = packer.to_s
packer.reset
packer.write_ext(1, "payload").full_pack

# Streaming deserialization
u = MessagePack::Unpacker.new(StringIO.new(packed_string), symbolize_keys: true)
u.each do |obj|
  obj
end

u = MessagePack::Unpacker.new
u.feed_each(packed_string) { |obj| obj }
u.feed(packed_string).read_map_header + 1

# Extension types
class MyClass
  def to_msgpack_ext
    ""
  end

  def self.from_msgpack_ext(_data)
    new
  end
end

pk = MessagePack::Packer.new(io)
pk.register_type(0x01, MyClass, :to_msgpack_ext)
pk.register_type(0x02, MyClass) { |_obj| "" }
pk.type_registered?(MyClass)

uk = MessagePack::Unpacker.new
uk.register_type(0x01, MyClass, :from_msgpack_ext)
uk.register_type(0x02) { |data| MyClass.from_msgpack_ext(data) }

MessagePack::DefaultFactory.register_type(0x00, Symbol)
MessagePack::DefaultFactory.register_type(
  MessagePack::Timestamp::TYPE,
  Time,
  packer: MessagePack::Time::Packer,
  unpacker: MessagePack::Time::Unpacker
)

class Point
  def x
    @x
  end

  def y
    @y
  end

  def initialize(x, y)
    @x = x
    @y = y
  end
end

factory = MessagePack::Factory.new
# @type var point_packer: ^(Point, MessagePack::Packer) -> void
point_packer = ->(point, packer) {
  packer.write(point.x)
  packer.write(point.y)
}
# @type var point_unpacker: ^(MessagePack::Unpacker) -> Point
point_unpacker = ->(unpacker) {
  Point.new(unpacker.read, unpacker.read)
}
factory.register_type(0x01, Point, packer: point_packer, unpacker: point_unpacker, recursive: true)
factory.load(factory.dump(Point.new(12, 34)))
factory.packer.write(1).full_pack
factory.unpacker(symbolize_keys: true).feed(packed_string).full_unpack

# Pooling
pool = factory.pool(5)
pool.load(pool.dump(Point.new(12, 34)))
size = pool.packer { |pk| pk.write(1).size }
size + 1

# Timestamp
ts = MessagePack::Timestamp.new(1, 2)
MessagePack::Timestamp.from_msgpack_ext(ts.to_msgpack_ext).sec + ts.nsec

# Errors
begin
  MessagePack.unpack("\xc1")
rescue MessagePack::MalformedFormatError, MessagePack::UnpackError => e
  e.message
end
