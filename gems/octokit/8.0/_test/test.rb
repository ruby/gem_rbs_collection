# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "octokit"

# Provide authentication credentials
client = Octokit::Client.new(:access_token => 'personal_access_token')

# You can still use the username/password syntax by replacing the password value with your PAT.
# client = Octokit::Client.new(:login => 'defunkt', :password => 'personal_access_token')

# Fetch the current user
client.user
