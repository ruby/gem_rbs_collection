# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "minitest"

Minitest.clock_time
Minitest.filter_backtrace(caller)
Minitest.process_args
Minitest.load_plugins
Minitest.init_plugins({})
Minitest.after_run do end
