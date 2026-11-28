require "execjs"

# @type var runtime: ExecJS::Runtime
runtime = ExecJS.runtime
# @type var runtime_name: String
runtime_name = runtime.name
# @type var available: bool
available = runtime.available?
runtime.deprecated?

ExecJS.runtime = ExecJS::Runtimes::Node

# @type var value: untyped
value = ExecJS.eval("'red yellow blue'.split(' ')")
value = ExecJS.exec("return 1 + 1")
value = ExecJS.eval("1 + 1", {})

# @type var context: ExecJS::Runtime::Context
context = ExecJS.compile("function add(a, b) { return a + b }")
value = context.call("add", 1, 2)
value = context.eval("add(1, 2)")
value = context.exec("return add(1, 2)")
value = context.call("CoffeeScript.compile", "square = (x) -> x * x", bare: true)

context = ExecJS::Runtimes::MiniRacer.compile("var x = 1", {})
value = ExecJS::Runtimes::Duktape.eval("[1, 2]")
value = ExecJS::Runtimes::Node.exec("return 1")
ExecJS::Runtime::Context.new(ExecJS::Runtimes::Node, "", {})
ExecJS::ExternalRuntime::Context.new(ExecJS::Runtimes::Node, "var x = 1")

# @type var context_class: singleton(ExecJS::Runtime::Context)
context_class = ExecJS::Runtimes::Duktape.context_class

# @type var node: ExecJS::ExternalRuntime
node = ExecJS::ExternalRuntime.new(
  name: "Node.js (V8)",
  command: ["node", "nodejs"],
  runner_path: "#{ExecJS.root}/support/node_runner.js",
  encoding: "UTF-8"
)
ExecJS::ExternalRuntime.new(command: "d8", deprecated: true)
# @type var node_name: String?
node_name = node.name

begin
  ExecJS::Runtimes::Disabled.eval("1")
rescue ExecJS::Error => e
  # @type var message: String
  message = e.message
end

# @type var runtimes: Array[ExecJS::Runtime]
runtimes = ExecJS.runtimes
runtimes = ExecJS::Runtimes.runtimes
# @type var best: ExecJS::Runtime?
best = ExecJS::Runtimes.best_available
best = ExecJS::Runtimes.from_environment
runtime = ExecJS::Runtimes.autodetect
# @type var names: Array[Symbol]
names = ExecJS::Runtimes.names

# @type var windows: Integer?
windows = ExecJS.windows?
windows = ExecJS.cygwin?

# @type var errors: Array[singleton(ExecJS::Error)]
errors = [ExecJS::RuntimeError, ExecJS::ProgramError, ExecJS::RuntimeUnavailable]
