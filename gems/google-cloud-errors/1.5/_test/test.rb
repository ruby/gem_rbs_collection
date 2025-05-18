# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "google-cloud-errors"

begin
rescue Google::Cloud::UnauthenticatedError => e
end
