# Operations - Manipulating images
image = ChunkyPNG::Image.from_file('filename.png')
new_image = ChunkyPNG::Canvas.from_canvas(image)
image[0, 0] = ChunkyPNG::Color.rgba(255, 0,0, 128)
image.line(1, 1, 10, 1, ChunkyPNG::Color.from_hex('#aa007f'))
image.flip_horizontally!.rotate_right!
image.compose(ChunkyPNG::Image.new(16, 16, ChunkyPNG::Color.rgba(10, 10, 10, 128)))
image.rect(0, 0, 16, 16)
ChunkyPNG::Canvas.adam7_extract_pass(4, image)
image.steps_residues(3,6)
image.resample_nearest_neighbor!(6,6)

image = ChunkyPNG::Image.from_file('filename.png')
image.pixels.map! { |pixel| ChunkyPNG::Color.r(pixel) < 0 ? -1 : 0 }
