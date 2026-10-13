# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "actionmailbox"

class ForwardsMailbox < ActionMailbox::Base
  def process
  end
end

class ApplicationMailbox < ActionMailbox::Base
  routing all: :forwards
end
