require 'concurrent-ruby'

# Basic usage
task = Concurrent::TimerTask.new{ puts 'Boom!' }
task.execute
task.execution_interval #=> 60 (default)
task.shutdown #=> true


# Configuring :execution_interval
task = Concurrent::TimerTask.new(execution_interval: 5) do
  puts 'Boom!'
end
task.execution_interval #=> 5

# Immediate execution with :run_now
task = Concurrent::TimerTask.new(run_now: true) { puts 'Boom!' }
task.execute

# Configuring :interval_type with either :fixed_delay or :fixed_rate, default is :fixed_delay

task = Concurrent::TimerTask.new(execution_interval: 5, interval_type: :fixed_rate) do
  puts 'Boom!'
end
task.interval_type #=> :fixed_rate

# Last #value and Dereferenceable mixin
task = Concurrent::TimerTask.new(
  dup_on_deref: true,
  execution_interval: 5
){ Time.now }
task.execute
task.value

# Controlling execution from within the block
timer_task = Concurrent::TimerTask.new(execution_interval: 1) do |task|
  task.execution_interval.to_i.times { print 'Boom! ' }
  task.execution_interval += 1
  if task.execution_interval > 5
    puts 'Stopping...'
    task.shutdown
  end
end

timer_task.execute

# Observation

class TaskObserver
  def update(time, result, ex)
    if result
      print "(#{time}) Execution successfully returned #{result}\n"
    else
      print "(#{time}) Execution failed with error #{ex}\n"
    end
  end
end

task = Concurrent::TimerTask.new(execution_interval: 1){ 42 }
task.add_observer(TaskObserver.new)
task.add_observer { |time, result, error| pp time, result, error }
task.add_observer { |time, result| pp time, result }
task.add_observer { |time| pp time }
task.execute
task.shutdown
