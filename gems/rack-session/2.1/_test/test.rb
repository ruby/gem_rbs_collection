require "rack"
require "rack/session"

secret = "x" * 64

app = Rack::Builder.new do
  use Rack::Session::Cookie, secrets: [secret], key: "_app_session", same_site: :lax, expire_after: 3600
  run do |env|
    session = env[Rack::RACK_SESSION] #: Rack::Session::Abstract::SessionHash
    session["count"] = 1
    session[:user_id] = 1
    session.fetch("user_id", nil)
    session.key?(:user_id)
    session.delete("count")
    session.to_hash.keys.first&.length
    session.options[:skip] = true
    [200, { "content-type" => "text/plain" }, ["ok"]]
  end
end

Rack::Session::Pool.new(app.to_app, expire_after: 3600).pool.size
Rack::Session::Cookie.new(app.to_app, coder: Rack::Session::Cookie::Base64::JSON.new, let_coder_handle_secure_encoding: true).coder

encryptor = Rack::Session::Encryptor.new(secret)
data = encryptor.encrypt({ "user_id" => 1 })
data.length
encryptor.decrypt(data)

begin
  encryptor.decrypt("invalid")
rescue Rack::Session::Encryptor::Error => e
  e.message
end

Rack::Session::SessionId.new("abc").private_id.length

class MyStore < Rack::Session::Abstract::PersistedSecure
  private

  def find_session(req, sid)
    [sid || generate_sid, {}]
  end

  def write_session(req, sid, session, options)
    sid
  end

  def delete_session(req, sid, options)
    generate_sid
  end
end
