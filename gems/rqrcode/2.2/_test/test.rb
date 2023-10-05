# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rqrcode"

qr = RQRCode::QRCode.new("https://kyan.com")

puts qr.to_s

qrcode = RQRCode::QRCode.new("http://github.com/")

# NOTE: showing with default options specified explicitly
svg = qrcode.as_svg(
  color: "000",
  shape_rendering: "crispEdges",
  module_size: 11,
  standalone: true,
  use_path: true
)

qrcode = RQRCode::QRCode.new("http://github.com/")

# NOTE: showing with default options specified explicitly
png = qrcode.as_png(
  bit_depth: 1,
  border_modules: 4,
  color_mode: ChunkyPNG::COLOR_GRAYSCALE,
  color: "black",
  file: nil,
  fill: "white",
  module_px_size: 6,
  resize_exactly_to: false,
  resize_gte_to: false,
  size: 120
)

IO.binwrite("/tmp/github-qrcode.png", png.to_s)


qrcode = RQRCode::QRCode.new("http://github.com/")

# NOTE: showing with default options specified explicitly
ansi = qrcode.as_ansi(
  light: "\033[47m", dark: "\033[40m",
  fill_character: "  ",
  quiet_zone_size: 4
)
