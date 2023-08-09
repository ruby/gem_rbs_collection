# Taken from https://github.com/mime-types/ruby-mime-types/blob/v3.5.0/lib/mime/type.rb#L10-L66
require 'mime/types'

plaintext = MIME::Types['text/plain'] # => [ text/plain ]
text = plaintext.first
puts text.media_type            # => 'text'
puts text.sub_type              # => 'plain'

puts text.extensions.join(' ')  # => 'txt asc c cc h hh cpp hpp dat hlp'
puts text.preferred_extension   # => 'txt'
puts text.friendly              # => 'Text Document'
puts text.i18n_key              # => 'text.plain'

puts text.encoding              # => quoted-printable
puts text.default_encoding      # => quoted-printable
puts text.binary?               # => false
puts text.ascii?                # => true
puts text.obsolete?             # => false
puts text.registered?           # => true
puts text.provisional?          # => false
puts text.complete?             # => true

puts text                       # => 'text/plain'

puts text == 'text/plain'       # => true
puts 'text/plain' == text       # => true
puts text == 'text/x-plain'     # => false
puts 'text/x-plain' == text     # => false

puts MIME::Type.simplified('x-appl/x-zip') # => 'x-appl/x-zip'
puts MIME::Type.i18n_key('x-appl/x-zip') # => 'x-appl.x-zip'

puts text.like?('text/x-plain') # => true
puts text.like?(MIME::Type.new('x-text/x-plain')) # => true

puts text.xrefs.inspect # => { "rfc" => [ "rfc2046", "rfc3676", "rfc5147" ] }
puts text.xref_urls # => [ "http://www.iana.org/go/rfc2046",
                    #      "http://www.iana.org/go/rfc3676",
                    #      "http://www.iana.org/go/rfc5147" ]

xtext = MIME::Type.new('x-text/x-plain')
puts xtext.media_type # => 'text'
puts xtext.raw_media_type # => 'x-text'
puts xtext.sub_type # => 'plain'
puts xtext.raw_sub_type # => 'x-plain'
puts xtext.complete? # => false

puts MIME::Types.any? { |type| type.content_type == 'text/plain' } # => true
puts MIME::Types.all?(&:registered?) # => false

# Various string representations of MIME types
qcelp = MIME::Types['audio/QCELP'].first # => audio/QCELP
puts qcelp.content_type         # => 'audio/QCELP'
puts qcelp.simplified           # => 'audio/qcelp'

xwingz = MIME::Types['application/x-Wingz'].first # => application/x-Wingz
puts xwingz.content_type        # => 'application/x-Wingz'
puts xwingz.simplified          # => 'application/x-wingz'
