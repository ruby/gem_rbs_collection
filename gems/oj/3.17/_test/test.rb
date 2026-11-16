require "oj"
require "stringio"
require "active_support"
require "active_support/json"

# Options
Oj.default_options = Oj.default_options.merge(mode: :compat)
Oj.default_options = { mode: :strict, indent: 2 }
options = Oj.default_options
options.fetch(:mode)

# Loading
Oj.load('{"a": [1, 2, 3]}')
Oj.load('{"a": 1}', mode: :strict, symbol_keys: true)
Oj.load(StringIO.new('{"a": 1}'))
loaded = [] # @type var loaded: Array[untyped]
Oj.load("[1] [2]") do |obj, start, len|
  loaded << obj
  start + len
end

Oj.strict_load('{"a": 1}')
Oj.strict_load('{"a": 1}', symbol_keys: true)
Oj.compat_load('{"a": 1}', symbol_keys: true)
Oj.object_load('{"a": 1}')
Oj.wab_load('{"a": 1}')
Oj.safe_load('{"a": 1}')
Oj.safe_load(StringIO.new('[1, 2]'))

begin
  Oj.load("{")
rescue Oj::ParseError => e
  e.message.upcase
rescue Oj::Error => e
  e.message.upcase
end

# Dumping
json = Oj.dump({ "a" => [1, 2, 3] })
json.upcase
Oj.dump([1, nil, "x"], mode: :compat, indent: 2).upcase
Oj.to_json({ "a" => 1 }).upcase
Oj.to_json({ "a" => 1 }, space: " ").upcase
Oj.generate({ "a" => 1 }).upcase
Oj.generate({ "a" => 1 }, indent: "  ", object_nl: "\n").upcase
Oj.fast_generate([1, 2]).upcase
Oj.to_stream(StringIO.new, { "a" => 1 }, mode: :compat)

# JSON compatibility
json_module = Oj.mimic_JSON
json_module.name
Oj.add_to_json
Oj.add_to_json(Range, Time)
Oj.remove_to_json(Range)
Oj.remove_to_json

# Rails
Oj.optimize_rails
Oj::Rails.set_encoder
Oj::Rails.set_decoder
Oj::Rails.optimize
Oj::Rails.optimize(Hash, Array)
Oj::Rails.deoptimize(Hash)
Oj::Rails.deoptimize
Oj::Rails.mimic_JSON
optimized = Oj::Rails.optimized?(Hash)
optimized ? 1 : 2
Oj::Rails.encode({ "a" => 1 }).upcase
Oj::Rails.encode({ "a" => 1 }, escape_html: true).upcase

encoder = Oj::Rails::Encoder.new
encoder.encode({ "a" => 1 }).upcase
encoder = Oj::Rails::Encoder.new({ escape_html: true })
encoder.optimize(Hash)
encoder.optimize
encoder.deoptimize(Hash)
encoder.deoptimize
encoder.optimized?(Hash) ? 1 : 2
Oj::Rails::Encoder.new(nil).encode([1]).upcase

# Writers
writer = Oj::StringWriter.new(mode: :compat)
writer.push_object
writer.push_value(1, "a")
writer.push_key("b")
writer.push_array
writer.push_value("x")
writer.push_json("[1, 2]")
writer.pop
writer.push_array("c")
writer.pop
writer.push_object("d")
writer.push_json('{"e": 1}', "e")
writer.pop_all
writer.to_s.upcase
writer.raw_json.upcase
loaded << writer.as_json
writer.reset
Oj::StringWriter.new.push_array

stream = StringIO.new
stream_writer = Oj::StreamWriter.new(stream, indent: 0)
stream_writer.push_object
stream_writer.push_key("a")
stream_writer.push_value(1)
stream_writer.push_value(2, "b")
stream_writer.push_array("c")
stream_writer.push_json("[1]")
stream_writer.push_json("[2]", "d")
stream_writer.pop
stream_writer.push_object("e")
stream_writer.pop
stream_writer.pop_all
stream_writer.flush
Oj::StreamWriter.new(stream).push_array

# Oj::Doc
size = Oj::Doc.open('[1, [2, 3], {"a": 4}]') do |doc|
  doc.where?.upcase
  doc.where.upcase
  doc.path.upcase
  doc.move("/2")
  doc.local_key.to_s
  doc.home.upcase
  doc.type("/1")&.name
  doc.type&.name
  doc.fetch("/1")
  doc.fetch("/9", 0)
  doc.fetch
  doc.exists?("/1") ? 1 : 2
  doc.each_leaf { |leaf| leaf.where?.upcase }
  doc.each_leaf("/2") { |leaf| leaf.fetch }
  doc.each_child { |child| child.local_key }
  doc.each_child("/2") { |child| child.where? }
  doc.each_value { |value| loaded << value }
  doc.each_value("/2") { |value| loaded << value }
  doc.dump.to_s.upcase
  doc.dump("/2").to_s.upcase
  doc.size
end
size + 1

doc = Oj::Doc.open("[1, 2]")
doc.size
doc.close

Oj::Doc.parse("[1]") { |parsed| parsed.size }.succ
Oj::Doc.parse("[1]").close

# Constants
Oj::VERSION.upcase

# These methods read and write files, so they are defined but never called
def use_files(data_path, out_path)
  loaded = [] # @type var loaded: Array[untyped]
  Oj.load_file(data_path)
  Oj.load_file(data_path, mode: :strict) { |obj, _start, _len| loaded << obj }
  Oj.to_file(out_path, { "a" => 1 })
  Oj.to_file(out_path, { "a" => 1 }, indent: 2)

  begin
    Oj.load_file(data_path, mode: :object)
  rescue IOError, Oj::LoadError, Oj::DepthError, Oj::MimicError => e
    e.message.upcase
  end

  Oj::Doc.open('[1, [2, 3]]') { |doc| doc.dump("/2", out_path) }
  Oj::Doc.open_file(data_path) { |file_doc| file_doc.size }.succ
  Oj::Doc.open_file(data_path).close
end
