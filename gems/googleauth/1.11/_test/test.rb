require "googleauth"

class MyCredentials < Google::Auth::Credentials
  # Set the default scope for these credentials
  self.scope = "http://example.com/my_scope"
end

Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: StringIO.new(''), scope: []
)
