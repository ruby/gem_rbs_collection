require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/convolution.md
conv = AcLibraryRb::Convolution.new
conv = AcLibraryRb::Convolution.new(998244353)
conv = AcLibraryRb::Convolution.new(998244353, 3)

a = [1, 2, 3]
b = [4, 5, 6]
c = conv.convolution(a, b)
