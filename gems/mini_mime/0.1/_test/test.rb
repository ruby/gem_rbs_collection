require "mini_mime"

MiniMime.lookup_by_filename("foo.txt")
MiniMime.lookup_by_extension("txt")
MiniMime.lookup_by_content_type("text/plain")

raise unless info = MiniMime.lookup_by_filename("foo.txt")

info.extension
info.content_type
info.encoding
info[0]
info.binary?

MiniMime.lookup_by_filename("foo") #=> nil
