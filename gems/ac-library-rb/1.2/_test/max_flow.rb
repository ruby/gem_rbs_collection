require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/max_flow.md
graph = AcLibraryRb::MaxFlow.new(10)
graph.add_edge(0, 1, 5)
graph.add_edge(1, 3, 5)
graph.flow(0, 3, 2)
graph.flow(0, 3)
graph.min_cut(0)
graph.get_edge(0)
graph.edges
graph.change_edge(0, 6, 5)
