class MyFormatter < Faraday::Logging::Formatter
  def request(env)
    # Build a custom message using `env`
    info('Request') { 'Sending Request' }
  end

  def response(env)
    # Build a custom message using `env`
    info('Response') { 'Response Received' }
  end

  def exception(exc)
    # Build a custom message using `exc`
    info('Error') { 'Error Raised' }
  end
end

conn = Faraday.new(url: 'http:///example.com') do |faraday|
  faraday.response :logger, nil, formatter: MyFormatter
end

conn.get('/abc')
