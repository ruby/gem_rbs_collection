require 'sentry-ruby'

Sentry.init do |config|
  config.dsn = 'https://examplePublicKey@o0.ingest.sentry.io/0'
  config.breadcrumbs_logger = [:sentry_logger, :http_logger]

  config.traces_sample_rate = 0.5
end


class FooMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    Sentry.capture_message("test message")
    @app.call(env)
  end
end

builder = Rack::Builder.new
builder.use(Sentry::Rack::CaptureExceptions)
builder.use(FooMiddleware)
