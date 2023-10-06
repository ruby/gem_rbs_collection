# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "chunky_png"

# Creating an image from scratch, save as an interlaced PNG
png = ChunkyPNG::Image.new(16, 16, ChunkyPNG::Color::TRANSPARENT)
png[1,1] = ChunkyPNG::Color.rgba(10, 20, 30, 128)
png[2,1] = ChunkyPNG::Color('black @ 0.5')
png.save('filename.png', :interlace => true)

# Compose images using alpha blending.
avatar = ChunkyPNG::Image.from_file('avatar.png')
badge  = ChunkyPNG::Image.from_file('no_ie_badge.png')
avatar.compose!(badge, 10, 10)
avatar.save('composited.png', :fast_rgba) # Force the fast saving routine.

# Accessing metadata
image = ChunkyPNG::Image.from_file('with_metadata.png')
puts image.metadata['Title']
image.metadata['Author'] = 'Willem van Bergen'
image.save('with_metadata.png') # Overwrite file
