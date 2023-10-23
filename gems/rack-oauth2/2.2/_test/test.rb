# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rack-oauth2"

YOUR_CLIENT_ID = 'client_id'
YOUR_CLIENT_SECRET = 'secret'
YOUR_REDIRECT_URI = 'http://example.com'
YOUR_USERNAME = 'username'
YOUR_PASSWORD = 'password'
YOUR_AUTHORIZATION_CODE = '1234'
YOUR_REFRESH_TOKEN_FOR_USER = 'abcd'

client = Rack::OAuth2::Client.new(
  :identifier => YOUR_CLIENT_ID,
  :secret => YOUR_CLIENT_SECRET,
  :redirect_uri => YOUR_REDIRECT_URI, # only required for grant_type = :code
  :host => 'rack-oauth2-sample.heroku.com'
)

request_type = :token

puts "## request_type = :#{request_type}"

authorization_uri = case request_type
when :code
  client.authorization_uri(:scope => :user_about_me)
when :token
  client.authorization_uri(:response_type => :token, :scope => :user_about_me)
end

puts authorization_uri


client = Rack::OAuth2::Client.new(
  :identifier => YOUR_CLIENT_ID,
  :secret => YOUR_CLIENT_SECRET,
  :redirect_uri => YOUR_REDIRECT_URI, # only required for grant_type = :code
  :host => 'rack-oauth2-sample.heroku.com'
)

grant_type = :authorization_code

puts "## grant_type = :#{grant_type}"

case grant_type
when :client_credentials
  # Nothing to do
when :password
  client.resource_owner_credentials = YOUR_USERNAME, YOUR_PASSWORD
when :authorization_code
  client.authorization_code = YOUR_AUTHORIZATION_CODE
when :refresh_token
  client.refresh_token = YOUR_REFRESH_TOKEN_FOR_USER
end

begin
  p client.access_token!
rescue => e
  p e
end
