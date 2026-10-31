require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/scc.md
graph = AcLibraryRb::SCC.new(6)
graph.add_edge(1, 4)
graph.scc
