require "rinku"

text = "Check http://www.example.com or mail foo@example.com"

linked = Rinku.auto_link(text)
linked.upcase

all = Rinku.auto_link(text, :all)
all.upcase

urls = Rinku.auto_link(text, :urls, 'rel="nofollow"')
urls.upcase

emails = Rinku.auto_link(text, :email_addresses, nil, ["a", "pre"])
emails.upcase

short = Rinku.auto_link(text, :all, 'target="_blank" rel="noopener noreferrer"', nil, Rinku::AUTOLINK_SHORT_DOMAINS)
short.upcase

with_block = Rinku.auto_link(text, :all, nil, nil, 0) { |url| url.sub("http://", "") }
with_block.upcase

# @type var block_arg: ^(String) -> String
block_arg = ->(url) { url.upcase }
via_proc = Rinku.auto_link(text, :urls, nil, &block_arg)
via_proc.upcase

# @type var tags: Array[String]?
tags = Rinku.skip_tags
Rinku.skip_tags = ["a", "pre", "code"]
Rinku.skip_tags = nil
tags&.first

flag = Rinku::AUTOLINK_SHORT_DOMAINS
flag + 1

version = Rinku::VERSION
version.upcase
