require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/two_sat.md
ts = AcLibraryRb::TwoSat.new(2)
ts.add_clause(0, true, 1, false)
ts.satisfiable?
ts.answer
