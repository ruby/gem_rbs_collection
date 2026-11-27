require "faraday"
require "faraday/retry"

# @type var version: String
version = Faraday::Retry::VERSION

stubs = Faraday::Adapter::Test::Stubs.new
connection = Faraday.new do |builder|
  builder.request :retry, max: 2, interval: 0.05, retry_statuses: [503]
  builder.adapter :test, stubs
end
connection.get("/")

retry_block = ->(**) { nil }

# @type var options: Faraday::Retry::Middleware::Options
options = Faraday::Retry::Middleware::Options.from(
  max: 3,
  interval: 0.1,
  backoff_factor: 2,
  exceptions: [Faraday::ConnectionFailed, "Timeout::Error"],
  methods: %i[get post],
  retry_block: retry_block
)
options = Faraday::Retry::Middleware::Options.from(5)
options = Faraday::Retry::Middleware::Options.from(nil)

options.max = 4
options.interval = 1
options.retry_statuses = 429
options.retry_if = ->(env, exception) { env.method == :post && exception.is_a?(Faraday::TimeoutError) }
options.exhausted_retries_block = ->(**) { nil }
options.rate_limit_retry_header = "X-Retry-After"
options.header_parser_block = ->(value) { value&.to_i }

# @type var max: Integer
max = options.max
# @type var interval: Float
interval = options.interval
# @type var exceptions: Array[Module | String]
exceptions = options.exceptions
# @type var methods: Array[Symbol]
methods = options.methods
# @type var statuses: Array[Integer]
statuses = options.retry_statuses
# @type var header: String?
header = options.rate_limit_retry_header

middleware = Faraday::Retry::Middleware.new(Faraday::Adapter::Test.new(nil, stubs), options)
Faraday::Retry::Middleware.new(nil, 3)
Faraday::Retry::Middleware.new(nil)

env = Faraday::Env.new
env.method = :get
env.response_headers = { "Retry-After" => "2" }
# @type var sleep_amount: Numeric?
sleep_amount = middleware.calculate_sleep_amount(1, env)

begin
  raise Faraday::RetriableResponse.new(nil, nil)
rescue Faraday::Error => e
  puts e.message
end

# @type var middleware_options: Faraday::Retry::Middleware::Options
middleware_options = middleware.options
