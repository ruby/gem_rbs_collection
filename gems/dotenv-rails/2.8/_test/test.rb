# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'dotenv'

Dotenv.load
Dotenv.load('file1.env', 'file2.env')

Dotenv.load!
Dotenv.load!('file1.env', 'file2.env')

Dotenv.require_keys('KEY1', 'KEY2')

Dotenv.parse('file1.env', 'file2.env')['KEY1']

Dotenv.overload('file1.env', 'file2.env')
Dotenv.overload!('file1.env', 'file2.env')
