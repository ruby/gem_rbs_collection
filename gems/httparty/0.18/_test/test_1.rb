class Foo
  include HTTParty

  base_uri "reqres.in"
  basic_auth "username", "password"
  digest_auth "username", "password"
  default_timeout 10
  open_timeout 10
  read_timeout 10
  write_timeout 10
  debug_output $stderr
  headers 'Accept' => 'application/json'
  format :json
  pem File.read('/home/user/my.pem'), "optional password"
  pkcs12 File.read('/home/user/my.p12'), "password"
  parser Proc.new { |data| data }

  def initialize(page)
    @options = { page: page }
  end
  def users
    self.class.get('/api/users', @options)
  end
end

Foo.get('https://reqres.in')
Foo.mkcol('https://reqris.in')
Foo.lock('https://reqres.in')
Foo.unlock('https://reqres.in')

Foo.mkcol('https://reqris.in', query: { "name": "random", "job": "random" }) { |response| response }
Foo.lock('https://reqres.in', query: { "name": "random", "job": "random" }) { |response| response }
Foo.unlock('https://reqres.in', query: { "name": "random", "job": "random" }) { |response| response }
