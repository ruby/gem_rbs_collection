# Taken from https://github.com/flippercloud/flipper/blob/v0.28.0/examples/basic.rb

require 'bundler/setup'
require 'flipper'

# check if search is enabled
if Flipper.enabled?(:search)
  puts 'Search away!'
else
  puts 'No search for you!'
end

puts 'Enabling Search...'
Flipper.enable(:search)

# check if search is enabled
if Flipper.enabled?(:search)
  puts 'Search away!'
else
  puts 'No search for you!'
end
