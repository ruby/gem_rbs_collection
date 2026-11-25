require "rb-inotify"

INotify::VERSION.upcase
INotify::Notifier::NON_RECURSIVE.upcase

dir = "watched"
Dir.mkdir(dir) unless Dir.exist?(dir)

begin
  notifier = INotify::Notifier.new
  notifier.fd + 1
  notifier.to_io.fileno

  watcher = notifier.watch(dir, :create, :moved_from, :moved_to)
  watcher.notifier.fd
  watcher.path.upcase
  watcher.flags.include?(:create)

  notifier.watch(dir, :delete, :recursive, :mask_add) do |event|
    event.name.upcase
    event.absolute_name.upcase
    event.flags.include?(:isdir)
    event.size + 1
    event.notifier.fd
    event.related.each { |related| related.name.upcase }
    event.watcher&.path&.upcase
  end

  File.write(File.join(dir, "file"), "")
  notifier.read_events.each do |event|
    event.flags.size
  end

  thread = Thread.new { notifier.run }
  notifier.stop
  thread.join
  notifier.process
  watcher.close
  notifier.close
rescue INotify::QueueOverflowError => e
  e.message.upcase
end
