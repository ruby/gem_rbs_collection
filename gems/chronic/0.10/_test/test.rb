require "chronic"

Chronic.parse('monday')

Chronic.parse('monday', context: :future)
Chronic.parse('monday', context: :past)

Chronic.parse('monday', now: Time.local(2000, 1, 1))

Chronic.parse('20:00:00', hours24: false) # => nil

Chronic.parse('monday', week_start: :sunday)
Chronic.parse('monday', week_start: :monday)

Chronic.parse('may 27th', guess: false)
Chronic.parse('may 27th', guess: true)

Chronic.parse('monday', ambiguous_time_range: 7)

Chronic.parse('03/04/2011', endian_precedence: [:middle, :little])
Chronic.parse('03/04/2011', endian_precedence: [:little, :middle])
Chronic.parse('03/04/2011', endian_precedence: :little)
Chronic.parse('03/04/2011', endian_precedence: :middle)

Chronic.parse('monday', ambiguous_year_future_bias: 79)

Chronic.parse('INVALID DATE')
