require "rack"
require "rack/session"

inner = ->(_env) { [200, { "content-type" => "text/plain" }, ["ok"]] }

pool = Rack::Session::Pool.new(inner)
pool.pool.size

Rack::Session::SessionId.new("abc").private_id.length
