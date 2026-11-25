# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "unf"

normalizer = UNF::Normalizer.instance
normalizer.normalize("が", :nfd)
UNF::Normalizer.new.normalize("が", :nfc)
UNF::Normalizer.normalize("ｶ", :nfkc)
UNF::Normalizer.normalize("ｶﾞ", :nfkd)

"が".to_nfc
"が".to_nfd
"ｶ".to_nfkc
"ｶ".to_nfkd

UNF::VERSION
