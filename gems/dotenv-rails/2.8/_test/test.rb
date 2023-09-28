# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require 'dotenv'

Dotenv.load
Dotenv.load('./env_files/file1.env', './env_files/file2.env')
Dotenv.load('./env_files/file3.env')

Dotenv.load!
Dotenv.load!('./env_files/file1.env', './env_files/file2.env')

Dotenv.require_keys('KEY1', 'KEY2')

pp Dotenv.parse('./env_files/file1.env', './env_files/file2.env')['KEY1']

Dotenv.overload('./env_files/file1.env', './env_files/file2.env')
Dotenv.overload!('./env_files/file1.env', './env_files/file2.env')
