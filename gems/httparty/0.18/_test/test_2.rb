HTTParty.get('http://api.stackexchange.com/2.2/questions', query: {site: 'stackoverflow'})
HTTParty.get('http://api.stackexchange.com/2.2/questions', query: {site: 'stackoverflow'}) { |res| res }
HTTParty.post('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.patch('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.put('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.delete('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.move('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.copy('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.head('https://reqres.in/api/users', query: { "name": "random", "job": "random" })
HTTParty.options('https://reqres.in/api/users', query: { "name": "random", "job": "random" })

HTTParty.get('http://api.stackexchange.com/2.2/questions', query: {site: 'stackoverflow'}) { |res| res }
HTTParty.post('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.patch('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.put('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.delete('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.move('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.copy('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.head('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }
HTTParty.options('https://reqres.in/api/users', query: { "name": "random", "job": "random" }) { |res| res }

request = HTTParty::Request.new(Net::HTTP::Get, URI('https://reqres.in'), {follow_redirects: true})
request.path = URI('https://reqres.in/api/users')
request.perform
request.perform { |response| puts response }
puts request.perform.headers, request.perform.code