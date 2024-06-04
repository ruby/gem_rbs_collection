require "sinatra/base"
require "sinatra/json"
require "sinatra/cookies"

class MyApp < Sinatra::Base
  enable :logging
  set :sessions, domain: 'example.dev', path: '/', expire_after: 1000*60
  helpers Sinatra::Cookies

  class HttpError < StandardError
    # @dynamic code
    attr_reader :code

    def initialize(code)
      super("HTTP error #{code}")
      @code = code
    end
  end

  error HttpError do
    status 400
    json(error: 'HTTP error')
  end

  helpers do
    def foo
      'foo'
    end

    def bar
      foo
    end
  end

  get '/' do
    json(foo: foo, bar: bar)
  end

  get '/test_params/:id' do
    params[:id]
    params['id']
    json(status: 'ok')
  end

  get '/fail' do
    halt 500
  end

  get '/get_cookies' do
    foo = cookies[:foo]
    cookies['bar'] = 'bar'
  end

  post '/' do
    json(foo: foo, bar: bar)
  end

  patch '/' do
    raise HttpError.new(401)
  end

  delete '/' do
    json([{foo: 'bar'}])
  end
end
