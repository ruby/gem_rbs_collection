require "regexp_trie"

p RegexpTrie.union('foo', 'bar', 'baz')

# From https://github.com/gfx/ruby-regexp_trie#readme

# like Regexp.union()
p RegexpTrie.union(%w(foobar fooxar foozap fooza)) # /foo(?:bar|xar|zap?)/
p RegexpTrie.union(%w(foobar fooxar foozap fooza), option: Regexp::IGNORECASE) # /foo(?:bar|xar|zap?)/i

# or object-oriented interface
rt = RegexpTrie.new
%w(foobar fooxar foozap fooza).each do |word|
  rt.add(word)
end
p rt.to_regexp # /foo(?:bar|xar|zap?)/
