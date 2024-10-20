require "mini_magick"

## Usage

image = MiniMagick::Image.open("input.jpg")
image.path # steep:ignore
image.resize "100x100" # steep:ignore
image.format "png" # steep:ignore
image.write "output.png" # steep:ignore

image = MiniMagick::Image.open("http://example.com/image.jpg")
image.contrast # steep:ignore
image.write("from_internets.jpg")

image = MiniMagick::Image.new("input.jpg")
image.path  #=> "input.jpg"
image.resize "100x100" # steep:ignore

### Combine options

image.combine_options do |b|
  b.resize "250x200>" # steep:ignore
  b.rotate "-90" # steep:ignore
  b.flip # steep:ignore
end # the command gets executed

image = MiniMagick::Image.new("input.jpg") do |b|
  b.resize "250x200>" # steep:ignore
  b.rotate "-90" # steep:ignore
  b.flip # steep:ignore
end # the command gets executed

### Attributes

image.type        #=> "JPEG"
image.width       #=> 250
image.height      #=> 300
image.dimensions  #=> [250, 300]
image.size        #=> 3451 (in bytes)
image.colorspace  #=> "DirectClass sRGB"
image.exif        #=> {"DateTimeOriginal" => "2013:09:04 08:03:39", ...}
image.resolution  #=> [75, 75]
image.signature   #=> "60a7848c4ca6e36b8e2c5dea632ecdc29e9637791d2c59ebf7a54c0c6a74ef7e"

image["%[gamma]"] # "0.9"

image.data

### Pixels

image = MiniMagick::Image.open("image.jpg")
pixels = image.get_pixels
# pixels[3][2][1] # the green channel value from the 4th-row, 3rd-column pixel

image = MiniMagick::Image.open("image.jpg")
image.crop "20x30+10+5" # steep:ignore
image.colorspace "Gray" # steep:ignore
pixels = image.get_pixels

### Pixels To Image

image = MiniMagick::Image.open('/Users/rabin/input.jpg')
pixels = image.get_pixels
depth = 8
dimension = [image.width, image.height]
map = 'rgb'
image = MiniMagick::Image.get_image_from_pixels(pixels, dimension, map, depth ,'jpg')
image.write('/Users/rabin/output.jpg')

### Configuration

MiniMagick.configure do |config|
  config.timeout = nil # number of seconds IM commands may take
  config.errors = true # raise errors non nonzero exit status
  config.warnings = true # forward warnings to standard error
  config.tmpdir = Dir.tmpdir # alternative directory for tempfiles
  config.logger = Logger.new($stdout) # where to log IM commands
  config.cli_prefix = nil # add prefix to all IM commands
end

### Composite

first_image  = MiniMagick::Image.new("first.jpg")
second_image = MiniMagick::Image.new("second.jpg")
result = first_image.composite(second_image) do |c|
  c.compose "Over" # steep:ignore
  c.geometry "+20+20" # steep:ignore
end
result.write "output.jpg"

### Layers/Frames/Pages

gif = MiniMagick::Image.open('/Users/rabin/input.gif')
pdf = MiniMagick::Image.open('/Users/rabin/input.pdf')
psd = MiniMagick::Image.open('/Users/rabin/input.psd')
gif.frames #=> [...]
pdf.pages  #=> [...]
psd.layers #=> [...]

gif.frames.each_with_index do |frame, idx|
  frame.write("frame#{idx}.jpg")
end

### Image validation

image.valid?
image.validate! # raises MiniMagick::Invalid if image is invalid

### Logging

MiniMagick.logger.level = Logger::DEBUG

## Tools

MiniMagick.convert do |convert|
  convert << "input.jpg"
  convert.resize("100x100") # steep:ignore
  convert.negate # steep:ignore
  convert << "output.jpg"
end

convert = MiniMagick.convert
convert << "input.jpg"
convert.resize("100x100") # steep:ignore
convert.negate # steep:ignore
convert << "output.jpg"
convert.call

### Appending

MiniMagick.convert do |convert|
  convert << "input.jpg"
  convert.merge! ["-resize", "500x500", "-negate"]
  convert << "output.jpg"
end

### "Plus" options

MiniMagick.convert do |convert|
  convert << "input.jpg"
  convert.+
  # convert.repage.+
  # convert.distort.+("Perspective", "more args")
end

### Stacks

MiniMagick.convert do |convert|
  convert << "wand.gif"

  convert.stack do |stack|
    stack << "wand.gif"
    stack.rotate(30) # steep:ignore
    stack.foo("bar", "baz") # steep:ignore
  end
  # or
  convert.stack("wand.gif", { rotate: 30, foo: ["bar", "baz"] })

  convert << "images.gif"
end

### STDIN and STDOUT

identify = MiniMagick.identify
identify.stdin # alias for "-"
identify.call(stdin: "")

content = MiniMagick.convert do |convert|
  convert << "input.jpg"
  convert.auto_orient # steep:ignore
  convert.stdout # alias for "-"
end

## Configuring

### GraphicsMagick

MiniMagick.configure do |config|
  config.cli_prefix = "gm"
end

### Changing temporary directory

MiniMagick.configure do |config|
  config.tmpdir = File.join(Dir.tmpdir, "/my/new/tmp_dir")
end

### Avoiding raising errors

MiniMagick.configure do |config|
  config.errors = false
end

MiniMagick.identify(errors: false) do |b|
  b.help # steep:ignore
end
