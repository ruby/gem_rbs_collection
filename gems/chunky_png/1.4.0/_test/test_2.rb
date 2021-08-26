# Loading Data - Datastream/StreamImport
image = ChunkyPNG::Image.from_rgba_stream(128, 128, File.read('pixeldata.rgba'))
image = ChunkyPNG::Image.from_rgb_stream(128, 128, File.read('pixeldata.rgb'))
image = ChunkyPNG::Image.from_file('file.png')
File.open('file.png', 'rb') { |io| image = ChunkyPNG::Image.from_io(io) }
image = ChunkyPNG::Image.from_blob(File.read('file.png'))
