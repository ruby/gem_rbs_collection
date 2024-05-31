listener = Listen.to('dir/path/to/listen', ignore: /\.txt/) { |modified, added, removed| }
listener.start
listener.ignore! /\.pkg/ # overwrite all patterns and only ignore pkg extension.
listener.ignore /\.rb/   # ignore rb extension in addition of pkg.
sleep
