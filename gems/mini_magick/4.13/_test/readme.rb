require "mini_magick"

image = MiniMagick::Image.open("input.jpg")
image.path #=> "/var/folders/k7/6zx6dx6x7ys3rv3srh0nyfj00000gn/T/magick20140921-75881-1yho3zc.jpg"
image.resize "100x100"
image.format "png"
image.write "output.png"

image = MiniMagick::Image.open("http://example.com/image.jpg")
image.contrast
image.write("from_internets.jpg")

image = MiniMagick::Image.new("input.jpg")
image.path #=> "input.jpg"
image.resize "100x100"

# Combine options
image.combine_options do |b|
  b.resize "250x200>"
  b.rotate "-90"
  b.flip
end

image = MiniMagick::Image.new("input.jpg") do |b|
  b.resize "250x200>"
  b.rotate "-90"
  b.flip
end

# Attributes
image.type        #=> "JPEG"
image.width       #=> 250
image.height      #=> 300
image.dimensions  #=> [250, 300]
image.size        #=> 3451 (in bytes)
image.colorspace  #=> "DirectClass sRGB"
image.exif        #=> {"DateTimeOriginal" => "2013:09:04 08:03:39", ...}
image.resolution  #=> [75, 75]
image.signature   #=> "60a7848c4ca6e36b8e2c5dea632ecdc29e9637791d2c59ebf7a54c0c6a74ef7e"

image["%[gamma]"]

# Pixels
image = MiniMagick::Image.open("image.jpg")
pixels = image.get_pixels
# pixels[3][2][1] # Comment out for coverage

image = MiniMagick::Image.open("image.jpg")
image.crop "20x30+10+5"
image.colorspace "Gray"
pixels = image.get_pixels

# Pixels To Image
image = MiniMagick::Image.open('/Users/rabin/input.jpg')
pixels = image.get_pixels
depth = 8
dimension = [image.width, image.height]
map = 'rgb'
image = MiniMagick::Image.get_image_from_pixels(pixels, dimension, map, depth ,'jpg')
image.write('/Users/rabin/output.jpg')

# Composite
first_image  = MiniMagick::Image.new("first.jpg")
second_image = MiniMagick::Image.new("second.jpg")
result = first_image.composite(second_image) do |c|
  c.compose "Over"    # OverCompositeOp
  c.geometry "+20+20" # copy second_image onto first_image from (20, 20)
end
result.write "output.jpg"

# Layers/Frames/Pages
gif = MiniMagick::Image.open('/Users/rabin/input.gif')
pdf = MiniMagick::Image.open('/Users/rabin/input.pdf')
psd = MiniMagick::Image.open('/Users/rabin/input.psd')
gif.frames #=> [...]
pdf.pages  #=> [...]
psd.layers #=> [...]

gif.frames.each_with_index do |frame, idx|
  frame.write("frame#{idx}.jpg")
end

# Image validation
image.valid?
image.validate!
