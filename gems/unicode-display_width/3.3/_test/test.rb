# frozen_string_literal: true

require "unicode/display_width"

# @type var width: Integer
width = Unicode::DisplayWidth.of("一")
width = Unicode::DisplayWidth.of("·", 2)
width = Unicode::DisplayWidth.of("·", nil, nil, emoji: false)
width = Unicode::DisplayWidth.of("a\tb", 1, overwrite: { "\t".ord => 10 })
width = Unicode::DisplayWidth.of("\u{1F93E}", ambiguous: 2, emoji: :all)
width = Unicode::DisplayWidth.of("\u{1F93E}", emoji: :rgi_at)

display_width = Unicode::DisplayWidth.new(overwrite: { "A".ord => 100 }, emoji: :all)
width = display_width.of("A")
width = display_width.of("A", ambiguous: 2, emoji: :none)
width = Unicode::DisplayWidth.new.of("·")

# @type var ambiguous: Integer?
ambiguous = display_width.get_config(emoji: false)[:ambiguous]

# @type var mode: :rgi | :rgi_at | :all | :all_no_vs16 | :vs16 | :none
mode = Unicode::DisplayWidth::EmojiSupport.recommended
width = Unicode::DisplayWidth.of("x", emoji: mode)

# @type var version: String
version = Unicode::DisplayWidth::VERSION
