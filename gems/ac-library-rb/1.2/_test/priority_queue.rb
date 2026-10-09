require "ac-library-rb"

# https://github.com/universato/ac-library-rb/blob/main/document_ja/priority_queue.md
# @type var empty_pq: AcLibraryRb::PriorityQueue[Integer]
empty_pq = AcLibraryRb::PriorityQueue.new
empty_pq.empty?

pq = AcLibraryRb::PriorityQueue.new([1, -1, 100])
pq.pop
pq.pop
pq.pop

pq = AcLibraryRb::PriorityQueue.new([1, -1, 100]) { |x, y| x < y }
pq.pop
pq.pop
pq.pop

pq.push(10)
pq.get
pq.empty?
pq.heap
