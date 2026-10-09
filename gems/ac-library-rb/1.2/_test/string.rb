require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/string.md
s = "banana"
a = [1, 0, 2, 0, 2, 0]
extend AcLibraryRb
# @type self: AcLibraryRb
sa = suffix_array(s)
suffix_array(a)
suffix_array(a, 2)
lcp_array(s, sa)
z_algorithm(s)
z_algorithm(a)
