require "ruby-vips"

# Configuration
Vips.block_untrusted(true)
Vips.block("VipsForeignLoadOpenslide", true)
Vips.block("VipsForeign", false)
Vips.cache_set_max(0)
Vips.cache_set_max_mem(1024)
Vips.cache_set_max_files(10)
Vips.concurrency_set(2)
Vips.vector_set(true)
# @type var cache_max: Integer
cache_max = Vips.cache_max
cache_max + Vips.cache_max_mem + Vips.cache_max_files + Vips.concurrency
Vips.vector? ? 1 : 0
# @type var version: String
version = Vips.version_string
version.upcase
# @type var recent: bool
recent = Vips.at_least_libvips?(8, 13)
Vips.version(0).succ
# @type var suffixes: Array[String]
suffixes = Vips.get_suffixes
suffixes.first
Vips::LIBRARY_VERSION.upcase

# Loading and saving
# @type var image: Vips::Image
image = Vips::Image.new_from_file("photo.jpg", access: :sequential)
image = Vips::Image.new_from_file("anim.gif[n=-1]")
buffer = File.binread("photo.png")
image = Vips::Image.new_from_buffer(buffer, "")
image = Vips::Image.new_from_buffer(buffer, "", fail: true)
image = Vips::Image.new_from_memory_copy("\x00" * 16, 2, 2, 4, :uchar)
image = Vips::Image.new_from_memory("\x00" * 16, 2, 2, 4, :uchar)
image = Vips::Image.new_from_array([[1, 2], [3, 4]])
image = Vips::Image.new_from_array([[1, 2], [3, 4]], 2, 0.5)
image = Vips::Image.matrix_from_array(2, 1, [1, 2])
image = Vips::Image.pngload_buffer(buffer)
image = Vips::Image.jpegload_buffer(buffer, autorotate: true)
image = Vips::Image.thumbnail("photo.jpg", 100)
image = Vips::Image.thumbnail("photo.jpg", 100, height: 200, size: :down, crop: :centre)
image = Vips::Image.thumbnail_buffer(buffer, 100, height: 100)
image = Vips::Image.black(10, 20, bands: 4)
image = Vips::Image.black(10, 10)
image = Vips::Image.text("<b>hello</b>", width: 100, height: 50, wrap: :"word-char")
image = image.new_from_image([255, 255, 255, 127])
image = image.new_from_image(0)

# @type var png: String
png = image.write_to_buffer(".png", strip: true)
png.bytesize
image.write_to_file("out.jpg", Q: 90, interlace: true)
# @type var raw: String
raw = image.write_to_memory
raw.bytesize

# Properties
# @type var w: Integer
w = image.width
# @type var h: Integer
h = image.height
w + h + image.bands + image.size.first + image.size.last
image.format.to_proc
image.interpretation == :srgb
image.coding.to_proc
image.filename.upcase
image.xres.floor
image.yres.floor
image.has_alpha? ? 1 : 0

# Metadata
# @type var fields: Array[String]
fields = image.get_fields
fields.first
image.get("exif-ifd0-Orientation")
image.get_typeof("icc-profile-data").succ
image.mutate do |mutable|
  # @type var names: Array[String]
  names = mutable.get_fields
  names.each { |field| mutable.remove!(field) }
  mutable.set!("orientation", 1)
  mutable.get("orientation")
  mutable.width + mutable.height + mutable.bands
  mutable.draw_rect!([255, 0, 0], 0, 0, 5, 5, fill: true)
  mutable.draw_point!(255, 1, 1)
end.width

# Operations
# @type var scaled: Vips::Image
scaled = image.resize(0.5)
scaled = image.resize(2.0, kernel: :lanczos3)
scaled = image.thumbnail_image(100)
scaled = image.copy(interpretation: :srgb)
scaled = image.flatten(background: [255, 255, 255])
scaled = image.autorot
scaled = image.insert(scaled, 0, image.height - scaled.height)
scaled = image.crop(0, 0, 10, 10)
scaled = image.extract_area(0, 0, 10, 10)
scaled = image.extract_band(0)
scaled = image.extract_band(0, n: 3)
scaled = image.embed(1, 1, 100, 100, extend: :mirror)
scaled = image.bandjoin(scaled)
scaled = image.bandjoin(255)
scaled = image.bandjoin([scaled, 255])
scaled = image.composite(scaled, "over", x: 1, y: 2)
scaled = image.composite([scaled], [:over])
scaled = image.colourspace(:srgb)
scaled = image.colourspace("b-w")
scaled = image.cast(:uchar)
scaled = image.flip(:horizontal)
scaled = image.rot(:d90)
scaled = image.ifthenelse(image, 0)
drawn = image.draw_rect([255], 1, 2, 3, 4, fill: true)
drawn.width.succ
scaled = image.bandfold(factor: 2)
scaled = image.affine([1, -0.2, 0, 1], background: [0])
scaled = image.embed(1.5, 2.5, 100.0, 100, extend: :background)
scaled = image.copy_memory
scaled = image.add_alpha
scaled = image[0]
scaled = image[0..2]
scaled = image[1.0]
scaled = image + 1
scaled = image - [1, 2]
scaled = image * image
scaled = image / 2
scaled = image % 2
scaled = image ** 2
scaled = image | image
scaled = image & image
scaled = image < 128
scaled = image <= 128
scaled = image > 128
scaled = image >= 128

# @type var stats: Vips::Image
stats = image.stats
# @type var point: Array[Float]
point = stats.getpoint(0, 1)
point.first.floor
# @type var rows: Array[Array[Array[Numeric]]]
rows = image.to_a
rows.first
# @type var trim: [Integer, Integer, Integer, Integer]
trim = image.find_trim(threshold: 10, background: [255, 255, 255])
image.crop(trim[0], trim[1], trim[2], trim[3])
image.avg.floor
image.min.floor
image.max.floor

# Errors
begin
  Vips::Image.new_from_file("missing.png")
rescue Vips::Error => e
  e.message.upcase
  e.to_s.upcase
end
begin
  raise Vips::Error, "invalid image"
rescue Vips::Error
  nil
end
