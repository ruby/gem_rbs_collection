# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "image_processing"

pipeline = ImageProcessing::Vips
  .source("image.jpg")
  .resize_to_limit(400, 400)
  .convert("png")
  .saver(quality: 80, strip: true)

tempfile = pipeline.call
tempfile.path
pipeline.call(destination: "output.png")
pipeline.call(save: false)
pipeline.call("other.jpg")

ImageProcessing::Vips.source(File.open("image.jpg")).resize_to_fit(800, nil).call
ImageProcessing::Vips.resize_to_fill(400, 400).call("image.jpg")
ImageProcessing::Vips.source("image.jpg").resize_to_limit!(400, 400).path
ImageProcessing::Vips.source("image.jpg").rotate(90).resize_and_pad(400, 400, extend: :copy).call
ImageProcessing::Vips.source("image.jpg").composite("overlay.png", gravity: "south-east", offset: [10, 10]).call
ImageProcessing::Vips.source("image.jpg").crop(0, 0, 100, 100).call
ImageProcessing::Vips.valid_image?(File.open("image.jpg"))

ImageProcessing::MiniMagick
  .source("image.jpg")
  .loader(page: 0)
  .resize_to_cover(300, 300)
  .crop("100x100+0+0")
  .apply(resize_to_limit: [400, 400], strip: true)
  .apply([[:rotate, 90]])
  .operation(:colorspace, "Gray")
  .call(destination: "output.jpg")

ImageProcessing::MiniMagick
  .source("image.jpg")
  .composite("overlay.png", mode: "Over") { |magick| magick }
  .instrumenter { |**options, &processing| nil }
  .call

builder = ImageProcessing::MiniMagick.source("image.jpg")
builder.options[:source]
builder.call!
ImageProcessing::MiniMagick.valid_image?(Tempfile.new)

begin
  ImageProcessing::Vips.call
rescue ImageProcessing::Error => error
  error.message
end
