require "better_errors"
require "ipaddr"
require "logger"
require "rack"

# README: allow access from other hosts
BetterErrors::Middleware.allow_ip!("10.0.1.0/24")
allowed = BetterErrors::Middleware.allow_ip!(IPAddr.new("192.168.0.0/16"))
allowed.size

BetterErrors::Middleware::ALLOWED_IPS.each do |ip|
  ip.to_range
end

# README: editor configuration
BetterErrors.editor = :vscode
BetterErrors.editor = "subl://open?url=file://%{file}&line=%{line}"
BetterErrors.editor = proc { |file, line| "my-editor://open?url=#{URI.encode_www_form_component(file)}&line=#{line}" }
BetterErrors.editor = ->(file, line) { "my-editor://#{file}:#{line}" }

editor = BetterErrors.editor
editor.url("/some/file", 123).start_with?("txmt:")
editor.scheme.end_with?(":")
BetterErrors.default_editor.scheme

# README: other settings
BetterErrors.application_root = "/path/to/app"
BetterErrors.application_root = nil
BetterErrors.application_root&.length

BetterErrors.logger = Logger.new($stdout)
BetterErrors.logger = nil
BetterErrors.logger&.info("x")

BetterErrors.ignored_instance_variables = [:@foo, "@bar"]
BetterErrors.ignored_instance_variables.map(&:to_s)

BetterErrors.maximum_variable_inspect_size = 50_000
BetterErrors.maximum_variable_inspect_size.succ

BetterErrors.ignored_classes = ["ActionDispatch::Request"]
BetterErrors.ignored_classes << "ActionDispatch::Response"

BetterErrors.use_pry!

BetterErrors::VERSION.length

# Rack middleware
class HelloApp
  def call(_env)
    [200, { "content-type" => "text/plain" }, ["Hello"]]
  end
end

rack_app = HelloApp.new
middleware = BetterErrors::Middleware.new(rack_app)
custom = BetterErrors::Middleware.new(rack_app, BetterErrors::ErrorPage)
status, _headers, _body = middleware.call({ "PATH_INFO" => "/" })
status.to_i.succ
custom.call({ "PATH_INFO" => "/" })

BetterErrors::ErrorPage.new(RuntimeError.new("boom"), {})
