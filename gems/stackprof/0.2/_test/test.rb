# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "stackprof"
StackProf.run(mode: :cpu, out: 'tmp/stackprof-cpu-myapp.dump') do
  # ...
end
