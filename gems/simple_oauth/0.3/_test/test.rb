# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "simple_oauth"

params = { status: "Test." }

oauth_params = {
  consumer_key: "consumer_key",
  consumer_secret: "consumer_secret",
  token: "access_token",
  token_secret: "access_token_secret",
}

auth_header = SimpleOAuth::Header.new(:get, "https://api.twitter.com/1.1/statuses/update.json", params, oauth_params).to_s
