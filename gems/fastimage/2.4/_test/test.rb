require "fastimage"

# These methods fetch images over the network, so they are defined but never called
def fetch_remote_images
  # @type var size: [Integer, Integer]?
  size = FastImage.size("http://example.com/logo.png")
  if size
    width, height = size
    width + height
  end

  # @type var type: Symbol?
  type = FastImage.type("/path/to/image.gif", timeout: 5)
  type&.to_sym

  # @type var animated: bool?
  animated = FastImage.animated?(Pathname.new("/path/to/image.webp"))
  animated.nil?

  headers = { "User-Agent" => "Fake Browser" }
  FastImage.size("https://example.com/a.jpg", http_header: headers, proxy: "http://proxy.example.com:8080")
  FastImage.size("https://example.com/a.jpg", raise_on_failure: true, timeout: 0.5)
  FastImage.size("https://example.com/a.jpg", proxy: nil)

  # @type var dynamic_options: Hash[Symbol, untyped]
  dynamic_options = { timeout: 3, raise_on_failure: false }
  FastImage.size("https://example.com/a.jpg", dynamic_options)
  FastImage.type("https://example.com/a.jpg", dynamic_options)

  begin
    FastImage.size("https://example.com/faulty.jpg", raise_on_failure: true)
  rescue FastImage::SizeNotFound, FastImage::ImageFetchFailure => e
    e.message.length
  rescue FastImage::FastImageException => e
    e.message.length
  end

  remote = FastImage.new("https://example.com/images/ExifOrientation3.jpg", http_header: headers)
  remote.orientation
  remote.content_length&.to_s
end

[FastImage::UnknownImageType, FastImage::CannotParseImage, FastImage::BadImageURI].each do |klass|
  klass.new.is_a?(FastImage::FastImageException)
end

FastImage::SUPPORTED_IMAGE_TYPES.map(&:to_s)
FastImage::VERSION.length

File.open(__FILE__, "rb") do |file|
  image = FastImage.new(file, timeout: 10)

  # @type var image_type: Symbol?
  image_type = image.type
  image_type&.to_s

  # @type var image_size: [Integer, Integer]?
  image_size = image.size
  image_size&.first

  # @type var orientation: Integer?
  orientation = image.orientation
  orientation&.succ

  # @type var width: Integer?
  width = image.width
  # @type var height: Integer?
  height = image.height
  width && height && width * height

  # @type var is_animated: bool?
  is_animated = image.animated
  is_animated.nil?

  # @type var length: Integer?
  length = image.content_length
  length&.succ
end
