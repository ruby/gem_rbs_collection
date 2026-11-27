require "digest/crc32"
require "digest/crc1"
require "digest/crc16_dnp"
require "digest/crc32_mpeg"
require "digest/crc8_1wire"

# @type var checksum: Integer
checksum = Digest::CRC32.checksum("hello")

# @type var packed: String
packed = Digest::CRC32.pack(checksum)

# @type var implementation: :c_ext | :pure
implementation = Digest::CRC32.implementation

crc = Digest::CRC32.new
# @type var updated: Digest::CRC32
updated = crc.update("hel")
crc << "lo"

# @type var value: Integer
value = crc.checksum

# @type var finished: String
finished = crc.finish

# @type var hex: String
hex = crc.hexdigest

# @type var initial: Integer
initial = crc.reset

# @type var lengths: Array[Integer]
lengths = [crc.block_length, crc.digest_length]

# @type var class_hex: String
class_hex = Digest::CRC16DNP.hexdigest("hello")

# @type var dnp: String
dnp = Digest::CRC16DNP.new.update("hello").finish

# @type var crc1: String
crc1 = Digest::CRC1.new.update("hello").finish

# @type var reflect: bool?
reflect = Digest::CRC::REFLECT_INPUT

# @type var width: Integer
width = Digest::CRC32::WIDTH + Digest::CRC8_1Wire::WIDTH

# @type var table: Array[Integer]
table = Digest::CRC32c::TABLE

# @type var mpeg: Digest::CRC32MPEG
mpeg = Digest::CRC32Mpeg.new

# @type var one_wire: Integer
one_wire = Digest::CRC81Wire.checksum("hello")
