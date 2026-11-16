require "inline_svg"
require "action_view"

class SvgToSymbolTransform < InlineSvg::CustomTransformation
  def transform(doc)
    with_svg(doc) do |svg|
      svg.name = "symbol"
    end
  end
end

InlineSvg.configure do |config|
  config.asset_file = InlineSvg::CachedAssetFile.new(
    paths: [Pathname.new(__dir__.to_s)],
    filters: /\.svg\z/
  )
  config.raise_on_file_not_found = true
  config.svg_not_found_css_class = "svg-missing"
  config.add_custom_transformation(attribute: :to_symbol, transform: SvgToSymbolTransform)
  config.add_custom_transformation(
    attribute: :asset_path,
    transform: SvgToSymbolTransform,
    priority: 2,
    default_value: true
  )
end

class SvgView < ActionView::Base
  def render_icons
    # @type var icon: ActiveSupport::SafeBuffer
    icon = inline_svg_tag("icons/check.svg", class: "icon", aria: true, title: "Check", desc: "A check mark")
    packed = inline_svg_pack_tag("icons/check.svg", size: "20px*20px", data: { icon: "check" })
    from_io = inline_svg_tag(StringIO.new("<svg></svg>"), nocomment: true)
    icon.concat(packed).concat(from_io)
  end
end

class SvgHelperHost
  include InlineSvg::ActionView::Helpers

  def render_icon(name)
    inline_svg_tag(name, class: "icon", aria_hidden: true, fallback: "icons/fallback.svg")
  end
end

config = InlineSvg.configuration
# @type var transformations: Hash[Symbol, InlineSvg::custom_transformation]
transformations = config.custom_transformations
transformations.empty?
config.svg_not_found_css_class&.upcase
config.raise_on_file_not_found? ? 1 : 0
config.asset_file #: InlineSvg::_AssetFile

cached = InlineSvg::CachedAssetFile.new(paths: __dir__.to_s, filters: %w[\.svg\z])
cached_default = InlineSvg::CachedAssetFile.new

begin
  cached.named("icons/check.svg").strip
  cached_default.named("icons/check.svg").strip
  config.asset_file.named("icons/check.svg").bytesize
rescue InlineSvg::AssetFile::FileNotFound => e
  e.message.strip
end

# AssetFile.named reads through the asset finder that the Rails integration configures.
module IconLoader
  def self.read(name)
    InlineSvg::AssetFile.named(name).strip
  rescue InlineSvg::AssetFile::FileNotFound => e
    e.message.strip
  end
end

title_id = InlineSvg::IdGenerator.generate("title", "Strava")
title_id.upcase
InlineSvg::IdGenerator.generate("desc", 1, randomness: InlineSvg::IdGenerator::Randomness).upcase
InlineSvg::IdGenerator::Randomness.call.upcase

document = Nokogiri::XML::Document.parse("<svg></svg>")
null_transformation = InlineSvg::TransformPipeline::Transformations::NullTransformation.new(nil)
null_transformation.with_svg(document).to_html
null_transformation.transform(document).to_html
null_transformation.value
SvgToSymbolTransform.create_with_value(true).transform(document).to_html
InlineSvg::VERSION.upcase
