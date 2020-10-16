listener = Listen.to('dir/path/to/listen') { |modified, added, removed| puts 'handle changes here...' }

listener.start
listener.paused? # => false
listener.processing? # => true

listener.pause   # stops processing changes (but keeps on collecting them)
listener.paused? # => true
listener.processing? # => false

# listener.unpause # resumes processing changes ("start" would do the same)
listener.stop    # stop both listening to changes and processing them
