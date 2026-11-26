# frozen_string_literal: true

require "unicode/display_width"

Unicode::DisplayWidth.of("一")
Unicode::DisplayWidth.of("·", 2)
Unicode::DisplayWidth.of("·", nil, nil, emoji: false)
Unicode::DisplayWidth.of("a\tb", 1, overwrite: { "\t".ord => 10 })
Unicode::DisplayWidth.of("\u{1F93E}", ambiguous: 2, emoji: :all)
Unicode::DisplayWidth.of("\u{1F93E}", emoji: :rgi_at)

width = Unicode::DisplayWidth.new(overwrite: { "A".ord => 100 }, emoji: :all)
width.of("A") + 1
width.of("A", ambiguous: 2, emoji: :none)
width.get_config(emoji: false)[:ambiguous]
Unicode::DisplayWidth.new.of("·")

mode = Unicode::DisplayWidth::EmojiSupport.recommended
Unicode::DisplayWidth.of("x", emoji: mode)

Unicode::DisplayWidth::VERSION.length
