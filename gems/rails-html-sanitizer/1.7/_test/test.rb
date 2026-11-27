require "rails-html-sanitizer"

full_sanitizer = Rails::HTML::FullSanitizer.new
# @type var stripped: String
stripped = full_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")

link_sanitizer = Rails::HTML::LinkSanitizer.new
# @type var unlinked: String
unlinked = link_sanitizer.sanitize('<a href="example.com">Only the link text will be kept.</a>')

safe_list_sanitizer = Rails::HTML::SafeListSanitizer.new

# sanitize via an extensive safe list of allowed elements
# @type var safe: String
safe = safe_list_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...")

# sanitize only the supplied tags and attributes
safe_list_sanitizer.sanitize("<b>Bold</b> no more!  <a href='more.html'>See more here</a>...", tags: %w(table tr td), attributes: %w(id class style))

# nil in, nil out
# @type var nothing: nil
nothing = safe_list_sanitizer.sanitize(nil)

input = ["<b>maybe</b>", nil].sample
# @type var maybe: String?
maybe = full_sanitizer.sanitize(input)

# @type var pruning: Rails::HTML4::SafeListSanitizer
pruning = Rails::HTML4::SafeListSanitizer.new(prune: true)
pruning.sanitize("<div><script>x</script>y</div>", scrubber: Rails::HTML::TextOnlyScrubber.new)

# @type var css: String
css = pruning.sanitize_css("background-color: #000;")

# @type var tags: Enumerable[String]?
tags = Rails::HTML4::SafeListSanitizer.allowed_tags
Rails::HTML4::SafeListSanitizer.allowed_tags = %w(table tr td)
Rails::HTML4::SafeListSanitizer.allowed_tags = tags
# @type var attributes: Enumerable[String]?
attributes = Rails::HTML4::SafeListSanitizer.allowed_attributes
Rails::HTML4::SafeListSanitizer.allowed_attributes = attributes

# @type var html5: bool
html5 = Rails::HTML::Sanitizer.html5_support?
# @type var vendor: singleton(Rails::HTML4::Sanitizer) | singleton(Rails::HTML5::Sanitizer)
vendor = Rails::HTML::Sanitizer.best_supported_vendor
# @type var allowed: bool
allowed = Rails::HTML::Sanitizer.allowed_uri?("https://example.com")

# @type var html4_safe_list: singleton(Rails::HTML4::SafeListSanitizer)
html4_safe_list = Rails::HTML::Sanitizer.safe_list_sanitizer
# @type var html4_full: singleton(Rails::HTML4::FullSanitizer)
html4_full = Rails::HTML4::Sanitizer.full_sanitizer

if html5
  # @type var html5_safe_list: singleton(Rails::HTML5::SafeListSanitizer)
  html5_safe_list = Rails::HTML5::Sanitizer.safe_list_sanitizer
  # @type var html5_link: singleton(Rails::HTML5::LinkSanitizer)
  html5_link = Rails::HTML5::Sanitizer.link_sanitizer
  # @type var html5_result: String
  html5_result = html5_link.new.sanitize("<a href='x'>y</a>")
  Rails::HTML5::SafeListSanitizer.allowed_attributes = %w(id class)
end

# Rails::Html is the old name of Rails::HTML
Rails::Html::WhiteListSanitizer.new.sanitize("<b>old</b>")

class CommentScrubber < Rails::HTML::PermitScrubber
  def initialize
    super
    self.tags = %w(form script comment blockquote)
  end

  def skip_node?(node)
    node.text?
  end

  def scrub_attribute?(name)
    name == "style"
  end
end

scrubber = CommentScrubber.new
# @type var scrubber_tags: Enumerable[String]?
scrubber_tags = scrubber.tags
# @type var prune: bool
prune = scrubber.prune
safe_list_sanitizer.sanitize("<form><b>x</b></form>", scrubber: scrubber)

target = Rails::HTML::TargetScrubber.new(prune: true)
target.attributes = Set["style"]
