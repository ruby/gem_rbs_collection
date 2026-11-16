require "premailer"

Premailer.name.upcase

# The first argument is opened as a file path or URL unless with_html_string: true
premailer = Premailer.new("<p>Hello</p>", with_html_string: true)

# @type var html: String
html = premailer.to_inline_css
# @type var text: String
text = premailer.to_plain_text
html.upcase
text.upcase

Premailer.new(StringIO.new("<p>Hello</p>")).to_inline_css.upcase
