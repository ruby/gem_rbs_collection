require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/min_cost_flow.md
graph = AcLibraryRb::MinCostFlow.new(10)
graph.add_edge(0, 1, 5, 2)
graph.add_edge(1, 3, 5, 3)
graph.flow(0, 3)
graph.get_edge(0)
graph.edges

graph = AcLibraryRb::MinCostFlow.new(10)
graph.add_edge(0, 1, 5, 2)
graph.add_edge(1, 3, 5, 3)
graph.flow(0, 3, 2)

graph = AcLibraryRb::MinCostFlow.new(10)
graph.add_edge(0, 1, 5, 2)
graph.add_edge(1, 3, 5, 3)
graph.slope(0, 3)

graph = AcLibraryRb::MinCostFlow.new(10)
graph.add_edge(0, 1, 5, 2)
graph.add_edge(1, 3, 5, 3)
graph.slope(0, 3, 2)
