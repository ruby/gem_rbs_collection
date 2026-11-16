# @type var app: Rack::_Application
app = _ = nil

middleware = -> (env) do
  # @type var env: Rack::env
  # @type block: Rack::response

  status, headers, body = app.call(env)

  body_proxy = Rack::BodyProxy.new(body) do
    puts "Closed"
  end #: Rack::BodyProxy & _Each[String]

  body_proxy.close()

  [status, headers, body_proxy]
end

middleware #: Rack::_Application
