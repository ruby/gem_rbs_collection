module RailsGuides
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end

  class NotifierMailer < ApplicationMailer
    default from: 'no-reply@example.com',
            return_path: 'system@example.com'

    def welcome(recipient)
      @account = recipient
      mail(to: recipient,
           bcc: ["bcc@example.com", "Order Watcher <watcher@example.com>"])
    end

    # @dynamic self.welcome
  end

  class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'

    def welcome_email
      @user = params[:user]
      @url  = 'http://example.com/login'
      mail(to: "@user", subject: 'Welcome to My Awesome Site')
    end
  end

  class I18nUserMailer < ActionMailer::Base
    def welcome(email, username)
      mail(to: email, subject: default_i18n_subject(user: username))
    end
  end

  NotifierMailer.welcome("first user").deliver_now
  NotifierMailer.welcome("first user").message
  NotifierMailer.welcome("first user").deliver_later
end

delivery = RailsGuides::NotifierMailer.welcome("first user")
delivery.deliver_now unless delivery.processed?

class NotifierMailerTest < ActionMailer::TestCase
  def test_welcome
    assert_no_emails
    assert_no_enqueued_emails
    RailsGuides::NotifierMailer.welcome("first user").deliver_later
    assert_enqueued_emails 1
    assert_enqueued_email_with RailsGuides::NotifierMailer, :welcome, args: ["first user"]
    deliver_enqueued_emails
  end
end

RailsGuides::ApplicationMailer.deliver_later_queue_name = :low
RailsGuides::ApplicationMailer.delivery_job = ActionMailer::MailDeliveryJob
