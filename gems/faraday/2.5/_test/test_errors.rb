Faraday::Error.new.tap do |error|
  error.backtrace
  error.inspect.downcase
  error.response_status
  error.response_headers
  error.response_body
  error.exc_msg_and_response!.downcase
  error.exc_msg_and_response!(RuntimeError.new)
  error.exc_msg_and_response!({ status: 500 })
  error.exc_msg_and_response!("Error!")
  error.exc_msg_and_response!(nil)
  error.exc_msg_and_response!(nil, nil)
  error.exc_msg_and_response!(nil, { status: 500 })
  error.exc_msg_and_response.tap { _1[0]&.backtrace; _1[1].upcase; _1[2]&.fetch(:status, 503) }
  error.exc_msg_and_response(RuntimeError.new)
  error.exc_msg_and_response({ status: 500 })
  error.exc_msg_and_response("Error!")
  error.exc_msg_and_response(nil)
  error.exc_msg_and_response(nil, nil)
  error.exc_msg_and_response(nil, { status: 500 })
end

Faraday::Error.new(RuntimeError.new)
Faraday::Error.new({ status: 500 })
Faraday::Error.new("Error!")
Faraday::Error.new(nil)
Faraday::Error.new(nil, nil)
Faraday::Error.new(nil, { status: 500 })
Faraday::ClientError.new
Faraday::BadRequestError.new
Faraday::UnauthorizedError.new
Faraday::ForbiddenError.new
Faraday::ResourceNotFound.new
Faraday::ProxyAuthError.new
Faraday::ConflictError.new
Faraday::UnprocessableEntityError.new
Faraday::ServerError.new
Faraday::TimeoutError.new
Faraday::NilStatusError.new("nil")
Faraday::ConnectionFailed.new
Faraday::SSLError.new
Faraday::ParsingError.new
