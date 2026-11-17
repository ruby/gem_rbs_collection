require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/dsu.md
d = AcLibraryRb::DSU.new(5)
p d.groups
p d.same(2, 3)
p d.size(2)

d.merge(2, 3)
p d.groups
p d.same(2, 3)
p d.size(2)
p d.leader(2)

uf = AcLibraryRb::UnionFind.new(5)
uf.unite(2, 3)
