require "rake"
require "rake/testtask"
require "rake/packagetask"
require "rake/clean"

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

  def create_typed_tasks
    desc "Build everything"
    # @type var build: Rake::Task
    build = task :build, [:mode] => [:compile] do |t, args|
      # @type var t: Rake::Task
      # @type var mode: untyped
      mode = args.fetch(:mode, "debug")
      puts "#{t.name} #{mode}"
    end

    # @type var compile: Rake::Task
    compile = task(compile: "lib/foo.o", order_only: ["tmp"])

    # @type var obj: Rake::Task
    obj = file "lib/foo.o" => ["lib/foo.c"] do |t|
      sh "cc", "-c", t.prerequisites.first.to_s, "-o", t.name do |ok, status|
        puts "failed: #{status.exitstatus}" unless ok
      end
    end

    # @type var dir: Rake::Task
    dir = directory "pkg/out"

    # @type var multi: Rake::Task
    multi = multitask parallel: %w[build compile]

    rule ".o" => ".c" do |t|
      # @type var t: Rake::Task
      sh "cc -c #{t.source} -o #{t.name}"
    end

    # @type var ns: Rake::NameSpace
    ns = namespace :db do |namespace|
      task :migrate
      # @type var found: Rake::Task?
      found = namespace[:migrate]
    end

    # @type var verbose: bool | Object
    verbose = verbose(false)
    # @type var written: Integer?
    written = when_writing("write file") { 1 }
  end
end

# @type var app: Rake::Application
app = Rake.application
# @type var top_level_tasks: Array[String]
top_level_tasks = app.top_level_tasks
# @type var tasks: Array[Rake::Task]
tasks = app.tasks
# @type var lookup: Rake::Task?
lookup = app.lookup(:default)
# @type var trace: bool
trace = app.options.trace

# @type var task: Rake::Task
task = Rake::Task[:default]
# @type var prerequisites: Array[String | Symbol]
prerequisites = task.prerequisites
# @type var comment: String?
comment = task.comment
# @type var timestamp: Time | Rake::EarlyTime | Rake::LateTime
timestamp = task.timestamp
task.enhance([:other]) { |t, args| puts t.name }
task.invoke("arg1", 2)
task.reenable

# @type var defined: bool
defined = Rake::Task.task_defined?("default")

# @type var args: Rake::TaskArguments
args = Rake::TaskArguments.new(%i[a b], [1, "two"])
# @type var hash: Hash[Symbol, untyped]
hash = args.to_hash
# @type var values: Array[untyped]
values = args.values_at(:a, :b)
# @type var keys: Hash[Symbol, untyped]
keys = args.deconstruct_keys([:a])

# @type var files: Rake::FileList
files = Rake::FileList["lib/**/*.rb", "test/**/*.rb"]
files = FileList.new("lib/**/*.rb") { |fl| fl.exclude("lib/generated/*", /_spec\.rb\z/) }
files = files.ext("o").pathmap("%{^lib,obj}p").map { |file| file.upcase }
files = files.select { |file| file.end_with?(".o") }.sort
# @type var file_names: Array[String]
file_names = files.to_a
# @type var first: String?
first = files.first
files.each { |file| puts file }
# @type var matched: Integer
matched = files.egrep(/TODO/) { |file, line_number, line| puts "#{file}:#{line_number}: #{line}" }

# @type var test_task: Rake::TestTask
test_task = Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList["test/**/test_*.rb"]
  t.verbose = true
end

# @type var package_task: Rake::PackageTask
package_task = Rake::PackageTask.new("foo", "1.0.0") do |p|
  p.need_tar_gz = true
  p.package_files.include("lib/**/*.rb")
end
# @type var package_dir_path: String
package_dir_path = package_task.package_dir_path

CLEAN.include("*.o")
CLOBBER.include("pkg")

RakeFileUtils.verbose(true)
Rake::FileUtilsExt.nowrite_flag = false
