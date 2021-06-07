png = ChunkyPNG::Image.new(128, 128, ChunkyPNG::Color::TRANSPARENT)
datastream = png.to_datastream
datastream.chunks.map { |x| x.type }
datastream.each_chunk { |chunk| chunk }

# Snippet taken from Gem's GitHub Wiki
image = ChunkyPNG::Image.from_file('clock.png')
image.change_theme_color!(ChunkyPNG::Color.from_hex('#bb1234'), ChunkyPNG::Color.from_hex('#cc3244'), ChunkyPNG::Color('white'), 5)
b, m = image.extract_mask(ChunkyPNG::Color.from_hex('#bb1234'), ChunkyPNG::Color('white'), 5)
m.change_mask_color!(ChunkyPNG::Color.from_hex('#cc3244'))
image.replace(b.compose(m))
