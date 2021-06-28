# Basic API usage - Color, Dimension
png = ChunkyPNG::Image.new(128, 128, ChunkyPNG::Color::TRANSPARENT)
png[1, 1] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
png[2, 1] = ChunkyPNG::Color('black @ 0.5')
png[3, 1] = ChunkyPNG::Color.rgb(255, 0, 128)
png.metadata['title'] = 'Test image'
puts png.metadata['title']
puts png.dimension.height.to_s
puts png.dimension.width.to_s
