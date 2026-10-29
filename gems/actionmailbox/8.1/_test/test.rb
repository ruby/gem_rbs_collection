# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "actionmailbox"

class ForwardsMailbox < ActionMailbox::Base
  before_processing :require_sender

  def process
    mail.subject
    inbound_email.message_id.size
    bounced! unless inbound_email.processed?
  end

  private

  def require_sender
  end
end

class ApplicationMailbox < ActionMailbox::Base
  routing all: :forwards
end

inbound_email = ActionMailbox::InboundEmail.new
inbound_email.status.to_sym
inbound_email.message_id.size
inbound_email.message_checksum.size
inbound_email.created_at.to_date
inbound_email.raw_email.attached?
inbound_email.delivered! unless inbound_email.bounced? || inbound_email.failed?
inbound_email.processing! if inbound_email.pending?
inbound_email.mail.subject
inbound_email.source.size
inbound_email.processed? || ForwardsMailbox.receive(inbound_email)

class ForwardsMailboxTest < ActionMailbox::TestCase
  def test_receive
    receive_inbound_email_from_mail(to: "save@example.com", subject: "Hello")
    create_inbound_email_from_mail(to: "save@example.com")
  end
end
