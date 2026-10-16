require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/fenwick_tree.md
fw = AcLibraryRb::FenwickTree.new(5)
fw = AcLibraryRb::FenwickTree.new([1, 2, 3, 4, 5])
fw.add(2, 10)
fw.sum(1, 4)
fw._sum(3)
