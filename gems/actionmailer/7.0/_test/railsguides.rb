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

  NotifierMailer.welcome("first user").deliver_now
  NotifierMailer.welcome("first user").message
  NotifierMailer.welcome("first user").deliver_later

  UserMailer.with(user: "an user").welcome_email.deliver_later
end
