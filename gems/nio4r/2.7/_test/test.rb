require "nio"

# @type var engine: String
engine = NIO.engine
engine.upcase
NIO::VERSION.upcase
NIO::ENGINE.upcase
# @type var pure: bool
pure = NIO.pure?
pure = NIO.pure?(ENV)
pure = NIO.pure?({ "NIO4R_PURE" => "true" })

# @type var backends: Array[NIO::Selector::backend]
backends = NIO::Selector.backends
selector = NIO::Selector.new
NIO::Selector.new(nil).close
NIO::Selector.new(backends.first).close
# @type var backend: NIO::Selector::backend | :unknown
backend = selector.backend

reader, writer = IO.pipe
# @type var monitor: NIO::Monitor
monitor = selector.register(reader, :r)
monitor.value = "connection"
monitor.value
# @type var io: _ToIO
io = monitor.io
io.to_io
# @type var interests: NIO::interest?
interests = monitor.interests
interests = monitor.interests = :rw
interests = monitor.remove_interest(:w)
# @type var added: NIO::interest
added = monitor.add_interest(:w)
selector.registered?(reader)

writer.write("x")
# @type var ready: Array[NIO::Monitor]?
ready = selector.select(1)
ready = selector.select
ready&.each do |m|
  # @type var readiness: NIO::interest?
  readiness = m.readiness
  m.readable?
  m.writable?
  m.writeable?
end
# @type var count: Integer?
count = selector.select(0) { |m| m.io }
count = selector.select(0.5) { |m| m.readable? }

monitor.selector&.empty?
monitor.close(false)
monitor.closed?
# @type var deregistered: NIO::Monitor?
deregistered = selector.deregister(reader)
selector.register(writer, :w).close
selector.wakeup
selector.close
selector.closed?

# @type var buffer: NIO::ByteBuffer
buffer = NIO::ByteBuffer.new(16)
buffer << "hello"
# @type var size: Integer
size = buffer.position + buffer.limit + buffer.capacity + buffer.remaining
buffer.position = 1
buffer.limit = 10
buffer.full?
buffer.mark.reset.rewind.flip
# @type var byte: Integer
byte = buffer[0]
# @type var str: String
str = buffer.get(1)
str = buffer.get
buffer.clear.compact
buffer.each { |b| b + 1 }
buffer.map { |b| b.chr }
buffer.inspect.upcase

buffer.clear << "data"
buffer.flip
# @type var written: Integer
written = buffer.write_to(writer)
buffer.clear
# @type var read: Integer
read = buffer.read_from(reader)

begin
  NIO::ByteBuffer.new(1) << "too long"
rescue NIO::ByteBuffer::OverflowError, NIO::ByteBuffer::UnderflowError, NIO::ByteBuffer::MarkUnsetError => e
  e.message
end
