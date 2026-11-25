require "slop"

Slop::VERSION.upcase

opts = Slop.parse(%w[--host example.com -p 8080 -v --tags a,b extra], suppress_errors: false) do |o|
  o.banner = "usage: app [options]"
  o.string "-h", "--host", "a hostname", default: "localhost"
  o.integer "-p", "--port", "a port"
  o.int "--retries"
  o.float "--ratio"
  o.bool "-v", "--verbose", "verbose output"
  o.boolean "--quiet"
  o.array "--tags", delimiter: ","
  o.symbol "--mode"
  o.regexp "--pattern"
  o.separator ""
  o.separator "Other:"
  o.null "--debug"
  o.on "--version", "print the version" do
    puts Slop::VERSION
  end
  o.on "--level", type: :integer do |value|
    puts value
  end
end

host = opts[:host]
opts.get("port")
opts.fetch(:verbose)
opts[:ratio] = 1.5
opts.set(:mode, :fast)
opts.option("--tags")&.flags&.first
opts.arguments.first
opts.args.size
opts.to_hash.each_key(&:to_s)
opts.to_h.size
opts.used_options.map(&:key)
opts.unused_options.map(&:flag)
opts.to_s(prefix: "  ").upcase
opts.parser.reset.arguments.size
opts.options.to_a.size

options = Slop::Options.new(banner: "usage: other")
option = options.on "-n", "--name", "a name"
option.flags.size
option.desc&.upcase
option.key.to_proc
option.to_s(offset: 10).upcase
option.count + 1
option.expects_argument?
option.config[:required]
options.each { |o| o.flag.upcase }
options.each.to_a.size
options.to_a.size
options.to_s.upcase
options.config[:banner]
options.separators.compact.size
result = options.parse(%w[-n Alice rest])
name = result[:name]

Slop.option_defined?(:string)
Slop.option_defined?("omg")
Slop.string_to_option("some_thing").upcase
Slop.string_to_option_class("string").new(["--x"], nil)

begin
  Slop.parse(%w[--unknown]) { |o| o.string "--name" }
rescue Slop::UnknownOption => e
  e.flag.upcase
rescue Slop::MissingArgument => e
  e.flags.size
rescue Slop::Error => e
  e.message
end

class MyOption < Slop::Option
  def call(value)
    "#{value}".reverse
  end
end
