require "rake"

# @type var ext: String
ext = "lib/foo.rb".ext("rbs")
ext = "lib/foo.rb".ext

# @type var path: String
path = "src/foo.c".pathmap("%{^src,obj}X.o")
path = "src/foo.c".pathmap(nil)
path = "src/foo.c".pathmap
path = "src/foo.TXT".pathmap("%X%{.*,*}x") { |match| match.downcase }
