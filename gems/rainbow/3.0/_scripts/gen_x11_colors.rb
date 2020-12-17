require "rainbow"

existing_names = Rainbow::Presenter.public_instance_methods(false)
x11_color_names = Rainbow::X11ColorNames::NAMES.keys - existing_names

case ARGV[0]
when "sig"
  puts x11_color_names.sort.map { |method| "    def #{method}: () -> instance\n" }.join
when "test"
  puts x11_color_names.sort.map { |method| "Rainbow('Hi').#{method}\n" }.join
else
  abort "usage: #{__FILE__} <sig|test>"
end
