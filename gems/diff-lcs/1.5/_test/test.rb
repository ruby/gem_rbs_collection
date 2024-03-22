require 'diff/lcs'

seq1 = %w(a b c e h j l m n p)
seq2 = %w(b c d e f j k l m r s t)
seq3 = 'hoge'
seq4 = 'hoga'

lcs = Diff::LCS.LCS(seq1, seq2)
lcs = Diff::LCS.LCS(seq3, seq4)
