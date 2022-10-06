address = Mail::Address.new('Fuga Kkbn (My email address) <fugakkbn@example.com>')
address.domain

mail = Mail.new
mail.from = 'fugakkbn@example.com'
mail.to = 'you@example.com'
mail.subject = 'This is a test email'
mail.body = 'Some simple body'
mail.to_s
