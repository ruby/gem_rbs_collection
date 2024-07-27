require "mini_magick"

MiniMagick::Error
MiniMagick::Invalid
MiniMagick::TimeoutError

MiniMagick.imagemagick7?
MiniMagick.cli_version

MiniMagick.version == "5.0"

MiniMagick::Tool.new("mogrify", foo: "FOO") do |mogrify|
  mogrify.resize "100x100" # steep:ignore
  mogrify << 1
  mogrify.merge!(["-foo", 1, nil])
  mogrify.+("Perspective", "0,0,4,5 89,0,45,46")
  mogrify.stack do |stack|
    stack << "wand.gif"
  end
  mogrify.stdin
  mogrify.stdout
  mogrify.xc
  mogrify.canvas("khaki")
  mogrify.executable
  mogrify.call
end

mogrify = MiniMagick::Tool.new("mogrify", foo: "FOO")
mogrify.call
