require "bullet"
require "active_job"

Bullet.enable = true
Bullet.enabled = true
Bullet.alert = true
Bullet.console = { foo: 1 }
Bullet.honeybadger = true
Bullet.airbrake = true
Bullet.rollbar = true
Bullet.sentry = { environment: "test" }
Bullet.appsignal = true
Bullet.bugsnag = true
Bullet.bugsnag = ->(report) { puts report }

# slack= needs the slack-notifier gem and xmpp= needs the xmpp4r gem; both raise without them
begin
  Bullet.slack = { webhook_url: "http://example.com/hook", channel: "#dev", username: "bullet" }
rescue StandardError
  nil
end

begin
  Bullet.xmpp = { account: "bullet@example.com", password: "secret", receiver: "dev@example.com", stay_connected: false }
rescue StandardError
  nil
end

Bullet.customized_logger = $stderr
Bullet.rails_logger = true
Bullet.terminal_notifier = true
Bullet.opentelemetry = true
Bullet.bullet_logger = false
Bullet.raise = false
Bullet.skip_html_injection = false
Bullet.n_plus_one_query_enable = false
Bullet.unused_eager_loading_enable = false
Bullet.counter_cache_enable = false

Bullet.add_footer = true
Bullet.footer_position = "bottom_right"
Bullet.skip_http_headers = true
Bullet.always_append_html_body = true
Bullet.skip_user_in_notification = true

# @type var footer: bool?
footer = Bullet.add_footer
footer = Bullet.skip_http_headers
footer = Bullet.always_append_html_body
footer = Bullet.skip_user_in_notification

# @type var position: String
position = Bullet.footer_position

# @type var enabled: bool
enabled = Bullet.enable?
enabled = Bullet.enabled?
enabled = Bullet.n_plus_one_query_enable?
enabled = Bullet.unused_eager_loading_enable?
enabled = Bullet.counter_cache_enable?

Bullet.stacktrace_includes = ["your_gem", /my_gem/, ["my_file.rb", "my_method"], ["my_file.rb", 16..20], [/my_gem/, 42]]
Bullet.stacktrace_excludes = [["my_file.rb", "my_method"], ["my_file.rb", 16..20], "vendor", /gems/]

# @type var includes: Array[Bullet::stacktrace_filter]
includes = Bullet.stacktrace_includes
# @type var excludes: Array[Bullet::stacktrace_filter]
excludes = Bullet.stacktrace_excludes
includes.size + excludes.size

# @type var added: Array[Symbol]
added = Bullet.add_safelist type: :n_plus_one_query, class_name: "Post", association: :comments
added = Bullet.add_safelist type: :unused_eager_loading, class_name: "Post", association: "user"
added.map(&:to_s)
Bullet.delete_safelist type: :counter_cache, class_name: "Post", association: :comments

# @type var safelist: Hash[Bullet::safelist_type, Hash[String, Array[Symbol]]]?
safelist = Bullet.safelist
safelist&.keys&.first&.to_s

Bullet.clear_safelist

# @type var result: Integer
result = Bullet.profile { 1 }
result = Bullet.skip { 2 }

Bullet.start_request
# @type var paused: bool
paused = Bullet.paused?
Bullet.pause
Bullet.resume
# @type var notified: bool?
notified = Bullet.notification?
Bullet.perform_out_of_channel_notifications if Bullet.notification?
Bullet.perform_out_of_channel_notifications("REQUEST_METHOD" => "GET", "PATH_INFO" => "/posts")
Bullet.end_request

# @type var rack_middleware: singleton(Bullet::Rack)
rack_middleware = Bullet::Rack
rack_middleware.name

class ApplicationJob < ActiveJob::Base
  include Bullet::ActiveJob
end

begin
  raise Bullet::Notification::UnoptimizedQueryError
rescue Bullet::Notification::UnoptimizedQueryError => e
  e.message.upcase
end
