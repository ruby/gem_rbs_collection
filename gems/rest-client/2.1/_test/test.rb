# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rest-client"

RestClient.get 'http://example.com/resource'

RestClient.get 'http://example.com/resource', {params: {id: 50, 'foo' => 'bar'}}

RestClient.get 'https://user:password@example.com/private/resource', {accept: :json}

RestClient.post 'http://example.com/resource', {param1: 'one', nested: {param2: 'two'}}

RestClient.post "http://example.com/resource", {'x' => 1}.to_json, {content_type: :json, accept: :json}

RestClient.delete 'http://example.com/resource'

RestClient::Request.execute(method: :get, url: 'http://example.com/resource',
                            timeout: 10)

RestClient::Request.execute(method: :get, url: 'http://example.com/resource',
                            ssl_ca_file: 'myca.pem',
                            ssl_ciphers: 'AESGCM:!aNULL')

RestClient.get('http://example.com/resource') { |response, request, result, &block|
  case response.code
  when 200
    p "It worked !"
    response
  when 423
    raise SomeCustomExceptionIfYouWant
  else
    response.return!(&block)
  end
}

resource = RestClient::Resource.new("http://example.com/resource")
resource.get
resource.get(params: {id: 50, 'foo' => 'bar'})
resource.get(accept: :json)
resource.post(params: 'one', nested: {param2: 'two'})
resource.post({'x' => 1}.to_json, {content_type: :json, accept: :json})
resource.delete

resource['nested'] { |response, request, result, &block|
  case response.code
  when 200
    p "It worked !"
    response
  when 423
    raise SomeCustomExceptionIfYouWant
  else
    response.return!(&block)
  end
}

