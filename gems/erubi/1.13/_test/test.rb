require "erubi"
require "erubi/capture_block"
require "erubi/capture_end"

engine = Erubi::Engine.new("Hello <%= name %>!\n", escape: true, filename: "hello.erb", trim: false)
engine.src.length
engine.filename&.length
engine.bufvar.to_sym
Erubi::Engine.new("<%= 1 %>").src.frozen?
Erubi::Engine.new("<%= 1 %>", bufvar: "@output_buffer", freeze_template_literals: false, chain_appends: true).src.length

Erubi.h("<a href='/'>").length

Erubi::CaptureBlockEngine.new("<%= form do %>x<% end %>", escape: true).src.length
buffer = Erubi::CaptureBlockEngine::Buffer.new
buffer << 1
buffer | "<b>"
buffer.capture(1) { |n| buffer << n }.upcase

Erubi::CaptureEndEngine.new("<%|= form do %>x<%| end %>", escape_capture: true, yield_returns_buffer: true).src.length
