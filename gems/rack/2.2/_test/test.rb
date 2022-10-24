require "rack"
require 'rack/lobster'

Rack::Server.start(app: Rack::ShowExceptions.new(Rack::Lint.new(Rack::Lobster.new)), Port: 9292)
