require "rails-html-sanitizer"

full_sanitizer = Rails::HTML::FullSanitizer.new
full_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")

link_sanitizer = Rails::HTML::LinkSanitizer.new
link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')

safe_list_sanitizer = Rails::HTML::SafeListSanitizer.new

# sanitize via an extensive safe list of allowed elements
safe_list_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")

# sanitize only the supplied tags and attributes
safe_list_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...", tags: %w(table tr td), attributes: %w(id class style))
