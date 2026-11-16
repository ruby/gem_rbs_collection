require "rack"
require "rack-timeout"
require "logger"

class ExampleApp
  def call(_env)
    [200, { "content-type" => "text/plain" }, ["ok"]]
  end
end

app = ExampleApp.new

middleware = Rack::Timeout.new(app)
middleware = Rack::Timeout.new(app, service_timeout: 30, wait_timeout: 10, service_past_wait: false)
middleware = Rack::Timeout.new(
  app,
  service_timeout: 120,
  wait_overtime: 86_400,
  wait_timeout: false,
  service_past_wait: true,
  term_on_timeout: 1
)

# @type var service_timeout: Numeric | false
service_timeout = middleware.service_timeout
# @type var wait_timeout: Numeric | false
wait_timeout = middleware.wait_timeout
# @type var wait_overtime: Numeric | false
wait_overtime = middleware.wait_overtime
# @type var service_past_wait: bool
service_past_wait = middleware.service_past_wait
# @type var term_on_timeout: Numeric | false
term_on_timeout = middleware.term_on_timeout

status, _headers, _body = middleware.call({ "REQUEST_METHOD" => "GET" })
status.to_i

Rack::Timeout::VALID_STATES.first.to_s
Rack::Timeout::ENV_INFO_KEY.upcase

Rack::Timeout.register_state_change_observer(:my_observer) do |env|
  info = env[Rack::Timeout::ENV_INFO_KEY]
  # @type var details: Rack::Timeout::RequestDetails
  details = info
  # @type var state: Symbol?
  state = details.state
  state == :timed_out
  # @type var request_id: String?
  request_id = details.id
  request_id&.upcase
  # @type var waited: Float?
  waited = details.wait
  waited&.round
  # @type var served: Float?
  served = details.service
  served&.round
  # @type var timeout: Numeric?
  timeout = details.timeout
  timeout&.zero?
  # @type var term: Integer?
  term = details.term
  term&.to_s
  # @type var formatted: String?
  formatted = details.ms(:service)
  formatted&.upcase
  details.id = "abc"
  details.wait = 0.5
  details.service = 1.5
  details.timeout = 15
  details.state = :active
  details.term = 0
end
# @type var removed: Proc?
removed = Rack::Timeout.unregister_state_change_observer(:my_observer)
removed&.arity

Rack::Timeout::Logger.disable
Rack::Timeout::Logger.level = Logger::ERROR
Rack::Timeout::Logger.level = :warn
Rack::Timeout::Logger.device = $stderr
Rack::Timeout::Logger.logger = Logger.new($stdout)
# @type var logger_device: (IO | String)?
logger_device = Rack::Timeout::Logger.device
# @type var logger_level: (Integer | String | Symbol)?
logger_level = Rack::Timeout::Logger.level
# @type var current_logger: Logger?
current_logger = Rack::Timeout::Logger.logger
current_logger&.info("hello")

Rack::Timeout::StateChangeLoggingObserver::STATE_LOG_LEVEL[:ready] = :debug
Rack::Timeout::StateChangeLoggingObserver::STATE_LOG_LEVEL[:completed] = :debug

begin
  middleware.call({})
rescue Rack::Timeout::RequestTimeoutError, Rack::Timeout::RequestExpiryError => e
  # @type var error: Rack::Timeout::Error
  error = e
  error.env.fetch("PATH_INFO", "")
  error.message.upcase
rescue Rack::Timeout::RequestTimeoutException => e
  # @type var exception: Rack::Timeout::ExceptionWithEnv
  exception = e
  exception.env.keys
  e.message.upcase
end
