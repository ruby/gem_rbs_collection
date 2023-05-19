# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "circuitbox"

Circuitbox::VERSION
Circuitbox::FaradayMiddleware
Circuitbox.circuit(:your_service, exceptions: [ArgumentError]) do
  :processing!
end.id2name
circuit = Circuitbox.circuit(:your_service, exceptions: [ArgumentError])
circuit.run(exception: false) { :ok }

Circuitbox.configure do |config|
  config.default_circuit_store
  config.default_circuit_store = Circuitbox::MemoryStore.new
  config.default_notifier
  config.default_notifier = Circuitbox::Notifier::Null.new
end

notifier = Circuitbox::Notifier::Null.new
notifier.notify(:your_service, :open)
notifier.notify_warning(:your_service, :half_open)
notifier.notify_run(:your_service) { :ok }

notifier = Circuitbox::Notifier::ActiveSupport.new
notifier.notify(:your_service, :open)
notifier.notify_warning(:your_service, :half_open)
notifier.notify_run(:your_service) { :ok }
