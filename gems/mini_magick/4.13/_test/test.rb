require "mini_magick"

image = MiniMagick::Image.open("input.jpg")

# #resize returns self
image.resize("100x100").resize("50x50")

# #format returns self
image.format("png").format("jpg")

# Manually define dynamically generated methods
image.type
image.type("foo").resize("100x100")
