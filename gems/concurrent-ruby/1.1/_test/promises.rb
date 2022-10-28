require 'concurrent-ruby'

## Concurrent::Promises::FactoryMethods

p Concurrent::Promises.any_event(
  Concurrent::Promises.resolvable_event,
  Concurrent::Promises.future { 1 },
).wait.resolved?

p Concurrent::Promises.any_fulfilled_future(
  Concurrent::Promises.rejected_future(RuntimeError.new('error')),
  Concurrent::Promises.future { 'hello' },
).value!.start_with?('h')

p Concurrent::Promises.any_resolved_future(
  Concurrent::Promises.rejected_future(RuntimeError.new('error')),
  Concurrent::Promises.future { 'hello' },
).then { |s| s.start_with?('h') }.rescue { |e| e&.message == 'error' }.value

p Concurrent::Promises.fulfilled_future(1).fulfilled?

p Concurrent::Promises.schedule(0.1).wait.resolved?
p Concurrent::Promises.schedule(Time.now).wait.resolved?
p Concurrent::Promises.schedule(0.1) { true }.value!
p Concurrent::Promises.schedule(Time.now) { true }.value!

p Concurrent::Promises.zip_events(
  Concurrent::Promises.resolved_event,
  Concurrent::Promises.fulfilled_future(1),
).wait.resolved?

p Concurrent::Promises.zip_futures(
  Concurrent::Promises.fulfilled_future(1),
  Concurrent::Promises.fulfilled_future('a'),
).then { |a, b| a == 1 && b == 'a' }.value!

p Concurrent::Promises.zip_futures(
  Concurrent::Promises.rejected_future(RuntimeError.new('error')),
  Concurrent::Promises.fulfilled_future('a'),
).rescue { |e,| e&.message == 'error' }.value

p Concurrent::Promises.
  future('3', '5') { |s, t| s.to_i + t.to_i }.
  then(2) { |v, arg| v + arg }.
  then { |v| v == 10 }.
  value

p Concurrent::Promises.
  future { fail "error" }.
  rescue { |e| e.message  }.
  then { |v| v == "error" }.
  value

p Concurrent::Promises.
  rejected_future(1).
  rejected?

p (Concurrent::Promises.future { 1 } & Concurrent::Promises.future { 2 }).
  then { |a, b| a == 1 && b == 2 }.
  value

p (Concurrent::Promises.future { 1 } & Concurrent::Promises.resolved_event).
  then { |a| a == 1 }.
  value

p (Concurrent::Promises.resolved_event & Concurrent::Promises.future { 2 }).
  then { |a| a == 2 }.
  value

p (Concurrent::Promises.future { 1 } | Concurrent::Promises.future { '2' }).
  then { |a| a == 1 || a == '2' }.
  value

p Concurrent::Promises.any_event(
  Concurrent::Promises.future { 1 },
  Concurrent::Promises.future { '2' },
  Concurrent::Promises.resolved_event,
).wait.resolved?

p Concurrent::Promises.make_future(nil).resolved?
p Concurrent::Promises.make_future(Concurrent::Promises.resolved_event).resolved?
p Concurrent::Promises.make_future(RuntimeError.new('error')).rescue { |e| e.message.start_with?('e') }.value
p Concurrent::Promises.make_future(Concurrent::Promises.future { 'hello' }).then { |s| s.start_with?('h') }.value
p Concurrent::Promises.make_future('hello').then { |s| s.start_with?('h') }.value


## Concurrent::Promises::Event

->() {
  x = Concurrent::Promises.resolved_event

  p x.delay.touch.resolved?
  p x.schedule(0.1).wait.resolved?
  p x.to_event.resolved?
  p x.to_future.fulfilled?
  p x.with_default_executor(:io).resolved?
  p !x.pending?

  p x.any(Concurrent::Promises.resolved_event).resolved?
  p x.zip(Concurrent::Promises.resolved_event).resolved?

  p x.chain('hi') { |s| s }.value!.start_with?('h')
}.()


## Concurrent::Promises::Future

->() {
  x = Concurrent::Promises.future { 'hello' }

  p x.delay.touch.value!.start_with?('h')
  p x.schedule(0.1).wait.then { |s| s.start_with?('h') }.value!
  p x.to_event.resolved?
  p x.to_future.fulfilled?
  p x.with_default_executor(:io).fulfilled?
  p !x.rejected?
  p !x.pending?
}.()

p (Concurrent::Promises.fulfilled_future('hi') | Concurrent::Promises.fulfilled_future('hello')).value!.start_with?('h')
p (Concurrent::Promises.fulfilled_future('hi') & Concurrent::Promises.fulfilled_future('hello')).value!.all? { |s| s.start_with?('h') }

->() {
  # @type var step: ^(Integer) -> (Concurrent::Promises::Future[untyped, Exception] | Integer)
  step = ->(v) {
    v < 5 ? Concurrent::Promises.future(v + 1) { |x| step[x] } : v
  }
  Concurrent::Promises.future(0) {|x| step[x] }.run
}.()

->() {
  failure = Concurrent::Promises.future { fail 'error' }
  p failure.reason&.message&.start_with?('e')
  p failure.reason(1)&.message&.start_with?('e')
  p failure.reason(1, RuntimeError.new('timeout'))&.message&.start_with?('e')
}.()

->() {
  known_failure = Concurrent::Promises.rejected_future(RuntimeError.new('error'))
  p known_failure.reason&.message&.start_with?('e')
  p known_failure.reason(1)&.message&.start_with?('e')
  p known_failure.reason(1, RuntimeError.new('timeout'))&.message&.start_with?('e')
}.()


## Concurrent::Promises::ResolvableEvent

-> () {
  x = Concurrent::Promises.resolvable_event
  p x.resolve.resolved?
  p x.with_hidden_resolvable.wait.resolved?
}.()

-> () {
  x = Concurrent::Promises.resolvable_event
  p !x.wait(0.1, true)
  p x.wait.resolved?
}.()


## Concurrent::Promises::ResolvableFuture

-> () {
  # @type var x: Concurrent::Promises::ResolvableFuture[String, Exception]
  x = Concurrent::Promises.resolvable_future
  p x.fulfill("hello").value&.start_with?('h')
  p x.with_hidden_resolvable.wait.fulfilled?
}.()

-> () {
  # @type var x: Concurrent::Promises::ResolvableFuture[String, Exception]
  x = Concurrent::Promises.resolvable_future
  p x.reject(RuntimeError.new('error')).reason&.message&.start_with?('e')
  p x.with_hidden_resolvable.wait.rejected?
}.()

-> () {
  # @type var x: Concurrent::Promises::ResolvableFuture[String, Exception]
  x = Concurrent::Promises.resolvable_future
  p !x.value(0.1, nil, [false, 'hello', nil])
}.()
