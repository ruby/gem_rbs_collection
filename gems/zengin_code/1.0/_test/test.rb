# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "zengin_code"

ZenginCode::Bank.all # => { '0001' => <#ZenginCode::Bank code, name, kana, hira, roma ... >, .... }

bank = ZenginCode::Bank["0001"] or raise

puts bank.code
puts bank.name
puts bank.kana
puts bank.hira
puts bank.roma

branch = bank.branches["001"]
puts branch.code
puts branch.name
puts branch.kana
puts branch.hira
puts branch.roma
puts branch.bank

ZenginCode::Bank["0000"] # => nil

ZenginCode.version # => "1.0.1-p20221002"
