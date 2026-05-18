class MyFormatter < Faraday::Logging::Formatter
  def exception(exc)
    # Build a custom message using `exc`
    info('Error') { 'Error Raised' }
  end

  def dump_nil_headers
    dump_headers(nil)
  end
end

conn = Faraday.new(url: 'http:///example.com') do |faraday|
  faraday.response :logger, nil, formatter: MyFormatter, errors: true
end

conn.get('/abc')

formatter = MyFormatter.new(logger: Object.new, options: {})
formatter.dump_nil_headers

logger = Faraday::Response::Logger.new(Object.new)
logger.on_error(StandardError.new('boom'))
