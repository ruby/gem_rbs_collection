# @type var app: Rack::_Application
app = _ = nil

middleware = -> (env) do
  # @type var env: Rack::env
  # @type block: Rack::response
  [404, { "FOO" => "BAR" }, "Not found"]
end

middleware #: Rack::_Application
