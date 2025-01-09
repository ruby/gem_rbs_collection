# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "rake"

class Task < Rake::TaskLib
  def create_task
    task default: %w[test]

    task :test do
      ruby "test/unittest.rb"
    end

    task :test_with_1_arg, :name do |t, args|
      value = args[:name]
      puts "#{args[:name]}=#{value}"
    end

    task :test_with_2_args, %i[name1 name2] do |t, args|
      args.each do |name, value|
        puts "#{name}=#{value}"
      end
    end

    task :test_with_sh do
      sh "ruby test/unittest_without_env.rb"

      env = { "RACK_ENV" => "test" }
      sh env, "ruby test/unittest_with_env.rb"
    end
  end
end
