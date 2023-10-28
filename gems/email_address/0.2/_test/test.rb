# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "email_address"

address = "Clark.Kent+scoops@gmail.com"
EmailAddress.valid?(address)    #=> true
EmailAddress.normal(address)    #=> "clark.kent+scoops@gmail.com"
EmailAddress.canonical(address) #=> "clarkkent@gmail.com"
EmailAddress.reference(address) #=> "c5be3597c391169a5ad2870f9ca51901"
EmailAddress.redact(address)    #=> "{bea3f3560a757f8142d38d212a931237b218eb5e}@gmail.com"
EmailAddress.munge(address)     #=> "cl*****@gm*****"
EmailAddress.matches?(address, 'google') #=> 'google' (true)
EmailAddress.error("#bad@example.com") #=> "Invalid Mailbox"

email = EmailAddress.new(address) #=> #<EmailAddress::Address:0x007fe6ee150540 ...>
email.normal        #=> "clark.kent+scoops@gmail.com"
email.canonical     #=> "clarkkent@gmail.com"
email.original      #=> "Clark.Kent+scoops@gmail.com"
email.valid?        #=> true

email.redact        #=> "{bea3f3560a757f8142d38d212a931237b218eb5e}@gmail.com"
email.sha1          #=> "bea3f3560a757f8142d38d212a931237b218eb5e"
email.sha256        #=> "9e2a0270f2d6778e5f647fc9eaf6992705ca183c23d1ed1166586fd54e859f75"
email.md5           #=> "c5be3597c391169a5ad2870f9ca51901"
email.host_name     #=> "gmail.com"
email.provider      #=> :google
email.mailbox       #=> "clark.kent"
email.tag           #=> "scoops"

exchanger = email.host.exchangers.first or raise
exchanger[:ip]      #=> "2a00:1450:400b:c02::1a"
email.host.txt_hash #=> {:v=>"spf1", :redirect=>"\_spf.google.com"}

EmailAddress.normal("HIRO@こんにちは世界.com")
                    #=> "hiro@xn--28j2a3ar1pp75ovm7c.com"
EmailAddress.normal("hiro@xn--28j2a3ar1pp75ovm7c.com", host_encoding: :unicode)
                    #=> "hiro@こんにちは世界.com"
