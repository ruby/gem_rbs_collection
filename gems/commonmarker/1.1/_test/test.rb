require "commonmarker"

Commonmarker.to_html('"Hi *there*"', options: {
    parse: { smart: true }
})

doc = Commonmarker.parse("*Hello* world", options: {
    parse: { smart: true }
})
puts(doc.to_html) # => <p><em>Hello</em> world</p>\n
