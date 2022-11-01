# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "sentry-ruby"

Sentry.init do |config|
  config.dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sample_rate = 0.5
end


begin
  1 / 0
rescue ZeroDivisionError => exception
  Sentry.capture_exception(exception)
end

Sentry.capture_message("test message")

Sentry.capture_message("this is not important", level: :info)


def do_something(action_name)
  # some code
rescue => exception
  Sentry.capture_exception(exception, fingerprint: [__method__, action_name])
end

Sentry.set_tags('page.locale': 'de-at')

Sentry.set_user(email: "jane@example.com")
Sentry.set_user({})

Sentry.configure_scope do |scope|
  # TODO: Comment-in after scope is typed
  # scope.set_context(
  #   'character',
  #   {
  #     name: 'Mighty Fighter',
  #     age: 19,
  #     attack_type: 'melee'
  #   }
  # )
end

Sentry.with_scope do |scope|
  # TODO: Comment-in after scope is typed
  # scope.set_tags(my_tag: "my value")
  # Sentry.capture_message("test")
end
