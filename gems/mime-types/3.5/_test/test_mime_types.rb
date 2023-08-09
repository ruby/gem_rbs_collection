# Taken from https://github.com/mime-types/ruby-mime-types/blob/v3.5.0/lib/mime/types.rb#L51-L66
require 'mime/types'

plaintext = MIME::Types['text/plain']
print plaintext.media_type           # => 'text'
print plaintext.sub_type             # => 'plain'

puts plaintext.extensions.join(" ")  # => 'asc txt c cc h hh cpp'

puts plaintext.encoding              # => 8bit
puts plaintext.binary?               # => false
puts plaintext.ascii?                # => true
puts plaintext.obsolete?             # => false
puts plaintext.registered?           # => true
puts plaintext.provisional?          # => false
puts plaintext == 'text/plain'       # => true
puts MIME::Type.simplified('x-appl/x-zip') # => 'appl/zip'

# Taken from https://github.com/mime-types/ruby-mime-types/blob/v3.5.0/lib/mime/types.rb#L107-L113
puts "\nMIME::Types['text/plain']"
MIME::Types['text/plain'].each { |t| puts t.to_a.join(", ") }

puts "\nMIME::Types[/^image/, complete: true]"
MIME::Types[/^image/, :complete => true].each do |t|
  puts t.to_a.join(", ")
end

# Taken from https://github.com/mime-types/ruby-mime-types/blob/v3.5.0/lib/mime/types.rb#L147-L152
puts MIME::Types.type_for('citydesk.xml')                 # => [application/xml, text/xml]
puts MIME::Types.type_for('citydesk.gif')                 # => [image/gif]
puts MIME::Types.type_for(%w(citydesk.xml citydesk.gif))  # => [application/xml, image/gif, text/xml]
