require 'ulid'

p ULID.generate.bytes
p ULID.generate(Time.now).bytes
p ULID.generate_bytes.bytes
p ULID.generate_bytes(Time.now).bytes
