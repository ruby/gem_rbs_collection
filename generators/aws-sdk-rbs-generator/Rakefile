# frozen_string_literal: true

# see also aws-sdk-ruby/Rakefile
REPO_ROOT = "#{File.dirname(__FILE__)}/_src"
GEMS_DIR = "#{REPO_ROOT}/gems"
CORE_LIB = "#{REPO_ROOT}/gems/aws-sdk-core/lib"
$:.unshift("#{REPO_ROOT}/build_tools")
$:.unshift("#{REPO_ROOT}/build_tools/aws-sdk-code-generator/lib")
Dir["#{GEMS_DIR}/*"].each do |dir|
  $:.unshift("#{dir}/lib")
end

require "rubocop/rake_task"
require_relative 'lib/aws-sdk-rbs-generator'

RuboCop::RakeTask.new

# rake 'write[../gem_rbs_collection/gems,S3,SQS]'
task :write do |task, args|
  args.to_a => [target_path, *service_args]

  services = AwsSdkRbsGenerator::Services.new
  dir = File.expand_path(target_path, __dir__)
  puts "Generate signatures to #{dir}"
  service_args.each { |name| services[name].write_files(dir:) }
end

task :default do
  Rake::Task['write'].invoke("gems", "S3", "SQS", "EC2", "KMS", "RDS")
end
