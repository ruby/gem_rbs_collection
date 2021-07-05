image = ChunkyPNG::Image.from_rgba_stream(128, 128, File.read('pixeldata.rgba')) # or
image.save('filename.png', :best_compression)
File.open('newfile.png', 'wb' ) { |io| image.write(io) }
png_data = image.to_blob(:fast_rgba)
image.save('filename.png', :color_mode => ChunkyPNG::COLOR_INDEXED, :compression => Zlib::NO_COMPRESSION, :interlace => true)
