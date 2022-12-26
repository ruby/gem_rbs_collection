require 'concurrent-ruby'

Concurrent.executor(:io).post { p :io }
Concurrent.executor(:fast).post { p :fast }
Concurrent.executor(:immediate).post { p :immediate }

Concurrent.global_io_executor.post { p :io }
Concurrent.global_fast_executor.post { p :fast }
Concurrent.global_immediate_executor.post { p :immediate }
