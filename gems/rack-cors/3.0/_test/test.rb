require "rack"
require "rack/cors"

class HelloApp
  def call(_env)
    [200, { "content-type" => "text/plain" }, ["Hello"]]
  end
end

app = HelloApp.new

# README: Rack configuration (config.ru style)
cors = Rack::Cors.new(app) do
  allow do
    origins "localhost:3000", "127.0.0.1:3000", /\Ahttp:\/\/192\.168\.0\.\d{1,3}(:\d+)?\z/
    resource "/file/list_all/", headers: "x-domain-token"
    resource "/file/at/*",
             methods: [:get, :post, :delete, :put, :patch, :options, :head],
             headers: "x-domain-token",
             expose: ["Some-Custom-Response-Header"],
             max_age: 600
  end

  allow do
    origins "*"
    resource "/public/*", headers: :any, methods: :get
    resource "/api/v1/*",
             headers: :any,
             methods: :get,
             if: proc { |_env| true }
  end
end

# Rails initializer style, with middleware options
logged = Rack::Cors.new(app, debug: true, logger: -> { Logger.new($stdout) }) do
  allow do
    origins { |source, _env| source.end_with?(".example.com") }
    resource "/api/articles/search/*", methods: %i[head get options], headers: %w[content-type], max_age: 7200
    resource %r{\A/bb/}, methods: [:get], headers: []
    resource "/vary", headers: [:any], methods: [:any], vary: ["Origin"], expose: "Link"
  end

  allow do
    origins "example.com", ->(source, env) { source.start_with?("https://") && env.key?("HTTP_HOST") }
    origins ["app.example.com", "api"]
    resource "*", credentials: true, if: ->(env) { env.key?("HTTP_ACCEPT") }, vary: "Accept"
  end
end

# Block with an explicit receiver
explicit = Rack::Cors.new(app, logger: Logger.new($stdout)) do |c|
  c.allow do |resources|
    resources.origins "*"
    resources.resource "*", headers: :any, methods: :any
  end
end

# @type var is_debug: bool
is_debug = logged.debug?
is_debug || cors.debug? || explicit.debug?

# @type var resources: Array[Rack::Cors::Resource]
resources = []
Rack::Cors.new(app) do
  allow do
    resources = resource("/x", max_age: 60)
    resources.size
  end
end

# Rack middleware interface
rack_app = cors #: Rack::_Application
_status, headers, _body = rack_app.call({ "PATH_INFO" => "/public/a", "REQUEST_METHOD" => "GET", "HTTP_ORIGIN" => "http://localhost:3000" })
headers.each { |k, v| k.upcase + v.upcase }

# Wildcard origins cannot allow credentials
begin
  Rack::Cors.new(app) do
    allow do
      origins "*"
      resource "*", credentials: true
    end
  end
rescue Rack::Cors::Resource::CorsMisconfigurationError => e
  e.message.upcase
end
