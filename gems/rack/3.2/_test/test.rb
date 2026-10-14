require "rack"

app = Rack::Builder.new do
  use Rack::ShowExceptions
  use Rack::Lint
  run { |_env| [200, { "content-type" => "text/plain" }, ["Hello"]] }
end.to_app

Rack::Builder.load_file("config.ru")
