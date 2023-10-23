# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rake"

class Task < Rake::TaskLib
  def create_task
    task default: %w[test]

    task :test do
      ruby "test/unittest.rb"
    end
  end
end
