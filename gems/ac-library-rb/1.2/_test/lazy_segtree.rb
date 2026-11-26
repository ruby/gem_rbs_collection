require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/lazy_segtree.md
# Range maximum with range addition; -Infinity is the identity.
# @type var op: ^(Float, Float) -> Float
op = ->(x, y) { x > y ? x : y }
# @type var mapping: ^(Float, Float) -> Float
mapping = ->(f, x) { f + x }
# @type var composition: ^(Float, Float) -> Float
composition = ->(f, g) { f + g }
v = [1.0, 2.0, 3.0, 4.0, 5.0]
e = -Float::INFINITY
id = 0.0

seg = AcLibraryRb::LazySegtree.new(v, op, e, mapping, composition, id)
seg = AcLibraryRb::LazySegtree.new(v, e, id, op, mapping, composition)
seg.set(2, 10.0)
seg.get(2)
seg.prod(1, 4)
seg.all_prod
seg.apply(2, 1.0)
seg.apply(1, 4, 2.0)
seg.range_apply(0, 5, 3.0)
seg.max_right(0) { |x| x <= 10.0 }
seg.min_left(5) { |x| x <= 10.0 }
