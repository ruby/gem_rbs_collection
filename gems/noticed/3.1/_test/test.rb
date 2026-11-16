require "noticed"

class User < ActiveRecord::Base
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"

  def email_notifications? = true

  def registered_ios? = false
end

class Post < ActiveRecord::Base
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"

  def all_authors = []
end

class CommentMailer < ActionMailer::Base
  def new_comment = mail(to: "author@example.com")
end

class ApplicationNotifier < Noticed::Event
end

class NewCommentNotifier < ApplicationNotifier
  recipients lambda {
    thread = record #: Post
    thread.all_authors
  }
  recipients do
    thread = record #: Post
    thread.all_authors
  end
  recipients :fetch_recipients
  recipients

  required_params :branch
  required_param :comment

  deliver_by :action_cable do |config|
    config.channel = "NotificationsChannel"
    config.channel = ActionCable::Channel::Base
    config.stream = :some_stream
    config.stream = -> { "notifications_#{event.type}" }
    config.message = -> { { title: params[:title] } }
    config.message = "plain text"
    config.class = "Noticed::DeliveryMethods::ActionCable"
  end

  deliver_by :email do |config|
    config.mailer = CommentMailer
    config.method = :new_comment
    config.args = -> { [recipient, params[:comment]] }
    config.kwargs = -> { { locale: :en } }
    config.params = { source: "readme" }
    config.enqueue = true
    config.if = lambda do
      subscriber = recipient #: User
      subscriber.email_notifications?
    end
    config.unless = :muted?
    config.wait = 5.minutes
    config.wait_until = -> { 1.hour.from_now }
    config.queue = :mailers_queue
    config.priority = 10
    config.before_enqueue = lambda do
      subscriber = recipient #: User
      throw(:abort) unless subscriber.registered_ios?
    end
  end

  deliver_by(:custom_email, class: "CustomEmail") { |config| config.mailer = "CommentMailer" }

  deliver_by :turbo_stream, class: "TurboStreamDelivery"

  bulk_deliver_by :discord do |config|
    config.url = "https://discord.example.com/hooks/123"
    config.json = -> { { message: type, channel: :general } }
    config.headers = -> { { "X-Token" => ENV.fetch("HOOK_TOKEN") } }
    config.form = { a: 1 }
    config.body = -> { type }
    config.basic_auth = -> { { user: ENV.fetch("HOOK_USER"), pass: ENV.fetch("HOOK_PASS") } }
    config.if = -> { notifications_count.positive? }
    config.queue = :digests
    config.wait_until = Time.now
    config.before_enqueue = -> { throw(:abort) if params.empty? }
  end

  bulk_deliver_by :digest, class: "DigestDelivery"

  notification_methods do
    def message
      t(".message")
    end
  end

  def message = "message"

  def muted?(notification) = notification.read?

  def fetch_recipients = []
end

# Delivery methods can be added with `class:`
class TurboStreamDelivery < Noticed::DeliveryMethod
  required_option :stream
  required_options :target, :partial

  before_deliver :prepare
  around_deliver { |_job, block| block.call }
  after_deliver { 3 }

  def deliver
    subscriber = recipient #: User
    return unless subscriber.email_notifications?

    notification.read?
    event.type
    params[:post]
    record
  end

  def prepare = config[:stream]

  def describe_config
    day = evaluate_option(:day) #: String
    options = [config.if, config.unless, config.wait, config.wait_until, config.queue, config.priority, config.before_enqueue]
    email = [config.mailer, config.method, config.args, config.kwargs, config.params, config.enqueue]
    cable = [config.message, config.channel, config.stream]
    webhook = [config.url, config.headers, config.json, config.form, config.body, config.basic_auth]
    day + (options + email + cable + webhook).compact.size.to_s
  end
end

class DigestDelivery < Noticed::BulkDeliveryMethod
  required_options :url

  before_deliver { 1 }
  around_deliver { |_job, block| block.call }
  after_deliver { 2 }

  def deliver
    event.notifications.count
    config[:url]
    config.url
    config.if
    evaluate_option(:url)
  end
end

Noticed::EventJob.queue_as :default_events
Noticed::DeliveryMethods::Email.queue_as :default_emails

Noticed.parent_class = "ApplicationJob"
Noticed.parent_class.upcase
Noticed::VERSION.upcase

# These need a database, so they are not called
class NotificationExamples
  def deliver(user, post, comment)
    # @type var event: NewCommentNotifier
    event = NewCommentNotifier.with(record: post, branch: comment).deliver(user)
    event = NewCommentNotifier.with(record: post, comment: comment).deliver([user, user], wait: 1.hour, queue: :low)
    event = NewCommentNotifier.with(record: post).deliver_later([user], priority: 5)
    event = NewCommentNotifier.with(record: post).deliver(wait_until: 1.hour.from_now, enqueue_job: false)
    event = NewCommentNotifier.with(record: post).deliver(wait_until: Time.now + 60)
    event = NewCommentNotifier.deliver(user)
    event = NewCommentNotifier.deliver_later
    event = NewCommentNotifier.new.deliver(user).deliver_later(user)

    # @type var failure: Noticed::Event
    failure = NewCommentNotifier.with(record: post)
    begin
      failure.deliver(user)
    rescue Noticed::ValidationError => e
      e.message
    end

    event
  end

  def read_event(event, post)
    event.message.upcase
    event.params[:comment]
    event.record
    event.record = post
    event.type.upcase
    event.id + event.notifications_count
    event.created_at.year
    event.updated_at.year
    event.record_type&.upcase
    event.record_id&.succ
    event.translate(".message").upcase
    event.t("message").upcase

    # @type var event_notifications: Noticed::Notification::ActiveRecord_Associations_CollectionProxy
    event_notifications = event.notifications
    event_notifications.unread.count
    event_notifications.read.newest_first.count
    event_notifications.mark_as_read

    # @type var recent: Noticed::Event::ActiveRecord_Relation
    recent = Noticed::Event.newest_first
    recent.where(id: 1).newest_first.first
    Noticed::Event.where(type: "NewCommentNotifier").count
  end

  def inbox(user)
    # @type var inbox: Noticed::Notification::ActiveRecord_Relation
    inbox = Noticed::Notification.where(recipient_id: user.id)
    # @type var unread: Noticed::Notification::ActiveRecord_Relation
    unread = inbox.unread
    unread = inbox.where(type: ["NewCommentNotifier::Notification"]).newest_first.unread
    unread.count
    inbox.includes([:event]).newest_first.read.count
    Noticed::Notification.newest_first.limit(10).to_a
    inbox.mark_as_read
    inbox.mark_as_unread(updated_at: Time.now)
    Noticed::Notification.unread.mark_as_read(read_at: Time.now) + 1
  end

  def notification(notification)
    notification.mark_as_read!
    notification.mark_as_unread!
    mark_results = [notification.mark_as_read, notification.mark_as_unread] #: Array[bool]
    mark_results.size
    flags = [notification.read?, notification.unread?] #: Array[bool]
    flags.size
    notification.read_at&.year
    notification.seen_at&.year
    notification.event.type
    notification.event_id + notification.id
    notification.recipient
    notification.recipient_type.upcase
    notification.recipient_id.succ
    notification.params[:comment]
    notification.record
    notification.type.upcase
    notification.created_at.year
    notification.updated_at.year
    notification.translate(".message").upcase
    notification.t("message").upcase
  end
end
