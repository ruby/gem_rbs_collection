require "redcarpet"
require "redcarpet/render_strip"

# README-style usage: a renderer instance and extensions
renderer = Redcarpet::Render::HTML.new(hard_wrap: true, filter_html: true, link_attributes: { rel: "nofollow" })
markdown = Redcarpet::Markdown.new(renderer, autolink: true, tables: true, fenced_code_blocks: true)
html = markdown.render("# Title\n\nbody")
html.length
# @type var used_renderer: Redcarpet::Render::Base
used_renderer = markdown.renderer
used_renderer.is_a?(Redcarpet::Render::HTML)

# A renderer class is accepted too
Redcarpet::Markdown.new(Redcarpet::Render::HTML).render("text").upcase
Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(escape_html: true, no_images: true)).render("text").upcase

# Other renderers
Redcarpet::Render::XHTML.new(hard_wrap: true)
Redcarpet::Render::Safe.new(link_attributes: { "target" => "_blank" })
Redcarpet::Render::SmartyHTML.new.postprocess("it's").upcase
Redcarpet::Render::StripDown.new
Redcarpet::Markdown.new(Redcarpet::Render::StripDown, strikethrough: true, superscript: true).render("~~a~~").upcase
Redcarpet::Markdown.new(Redcarpet::Render::SmartyHTML.new, highlight: true, quote: true, underline: true).render("\"a\"").upcase

# Table of contents
toc = Redcarpet::Render::HTML_TOC.new(nesting_level: 2..3)
Redcarpet::Markdown.new(toc).render("# a").upcase
Redcarpet::Render::HTML_TOC.new(with_toc_data: true)
Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC.new(nesting_level: 3, escape_html: true)).render("# a").upcase
Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(with_toc_data: true, prettify: true, no_links: true, no_styles: true, safe_links_only: true, xhtml: true, escape_html: true)).render("# a").upcase

# Options built dynamically are Hash[Symbol, bool], not a literal with known keys
render_options = { escape_html: true, hard_wrap: false }
render_options[:no_images] = true
Redcarpet::Render::HTML.new(render_options)
Redcarpet::Render::HTML_TOC.new(render_options)
markdown_options = { tables: true }
markdown_options[:autolink] = true
Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, markdown_options).render("a").upcase

# More extensions
Redcarpet::Markdown.new(
  Redcarpet::Render::HTML.new,
  no_intra_emphasis: true,
  disable_indented_code_blocks: true,
  lax_spacing: true,
  space_after_headers: true,
  footnotes: true
).render("a").upcase

# SmartyPants
Redcarpet::Render::SmartyPants.render("don't").upcase
Redcarpet::Render::SmartyPants.postprocess("don't").upcase

# A custom renderer overriding callbacks
class HeadingRenderer < Redcarpet::Render::HTML
  def header(text, header_level)
    "<h#{header_level}>#{text}</h#{header_level}>"
  end

  def block_code(code, language)
    "<pre data-lang=\"#{language}\">#{code}</pre>"
  end

  def image(link, title, alt_text)
    "<img src=\"#{link}\" title=\"#{title}\" alt=\"#{alt_text}\">"
  end

  def postprocess(document)
    document.strip
  end
end

class Slack < Redcarpet::Render::Base
  def initialize(prefix)
    super()
    @prefix = prefix
  end

  def paragraph(text)
    "#{@prefix}#{text}\n"
  end
end

Redcarpet::Markdown.new(HeadingRenderer.new(hard_wrap: true), tables: true).render("# a").upcase
Redcarpet::Markdown.new(HeadingRenderer).render("# a").upcase
Redcarpet::Markdown.new(Slack.new("> ")).render("a").upcase
