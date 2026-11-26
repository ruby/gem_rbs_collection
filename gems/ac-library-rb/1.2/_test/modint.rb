require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/modint.md
AcLibraryRb::ModInt.set_mod(11)
AcLibraryRb::ModInt.mod

a = ModInt(10)
b = 3.to_m

p a + b
p 1 + a
p a - b
p b - a
p a * b
p b.inv
p a / b

a += b
a -= b
a *= b
a /= b

p ModInt(2)**4
puts a
p AcLibraryRb::ModInt.raw(3)

AcLibraryRb::ModInt.mod = 11
a = AcLibraryRb::ModInt.new(10)
AcLibraryRb::ModInt.new
5.to_m
"2".to_m
a.val
a.to_i
a.pow(4)
