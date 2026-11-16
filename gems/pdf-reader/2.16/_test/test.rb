require "pdf/reader"
require "stringio"

# Open from a path and from an IO
reader = PDF::Reader.new("sample.pdf")
from_io = PDF::Reader.new(StringIO.new("%PDF-1.4"), {})

count = reader.page_count
count.succ

version = reader.pdf_version
version.round(1)

info = reader.info
title = info[:Title] # @type var title: String?
title.to_s

xmp = reader.metadata
xmp&.length

# Pages
reader.pages.each do |page|
  page.text.strip
end

first = reader.page(1)
number = first.number
number.succ
first.text(rotation: true).upcase
first.to_s.upcase
fonts = first.fonts
fonts.keys
first.raw_content.length

from_io.pages.first&.text

# Block form
PDF::Reader.open("sample.pdf") do |r|
  r.page_count.succ
end
text = PDF::Reader.open(StringIO.new("%PDF-1.4"), {}) { |r| r.page(1).text }
text.upcase

# Errors
begin
  reader.page(0)
rescue PDF::Reader::InvalidPageError => e
  e.message.upcase
rescue PDF::Reader::EncryptedPDFError, PDF::Reader::UnsupportedFeatureError => e
  e.message.upcase
rescue PDF::Reader::InvalidObjectError, PDF::Reader::MalformedPDFError => e
  e.message.upcase
end
