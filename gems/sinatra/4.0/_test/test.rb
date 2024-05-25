require "sinatra/base"
require "sinatra/json"

class MyApp < Sinatra::Base
  enable :logging
  set :sessions, domain: 'example.dev', path: '/', expire_after: 1000*60

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

  # @dynamic self.foo, self.bar
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

  post '/' do
    json(foo: foo, bar: bar)
  end

  patch '/' do
    raise HttpError.new(401)
  end
end
