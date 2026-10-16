require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/segtree.md
n = 100_000
inf = (1 << 60) - 1

AcLibraryRb::Segtree.new(n, 0) { |x, y| x.gcd y }
AcLibraryRb::Segtree.new(n, 1) { |x, y| x.lcm y }
AcLibraryRb::Segtree.new(n, -inf) { |x, y| [x, y].max }
AcLibraryRb::Segtree.new(n, inf) { |x, y| [x, y].min }
AcLibraryRb::Segtree.new(n, 0) { |x, y| x | y }
AcLibraryRb::Segtree.new(n, 1) { |x, y| x * y }
AcLibraryRb::Segtree.new(n, 0) { |x, y| x + y }

seg = AcLibraryRb::Segtree.new([1, 2, 3, 4, 5], 0) { |x, y| x + y }
seg.set(2, 10)
seg.get(2)
seg.prod(1, 4)
seg.all_prod
seg.max_right(0) { |x| x <= 10 }
seg.min_left(5) { |x| x <= 10 }
