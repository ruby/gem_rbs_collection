stdlib_dependencies = %w[time monitor singleton logger mutex_m json date benchmark digest minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :active_job do
      export = "export/activejob/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        sh "cp -a out/#{version}/active_job.rbs #{export}"
        sh "cp -a out/#{version}/active_job #{export}"
        sh "rm #{export}/active_job/railtie.rbs"

        Pathname(export).join("EXTERNAL_TODO.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          module Que
            class Job
            end
          end
          module Qu
            class Job
            end
          end
        RBS

        generate_test_script(
          gem: :activejob,
          version: version,
          export: export,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )

        Pathname(export).join('_test').join('test.rb').write(<<~RUBY)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class SendMessageJob < ActiveJob::Base
            queue_as :default
            self.queue_adapter = :sidekiq

            before_enqueue do |job|
              # before enqueued
            end

            around_perform :around_task

            def perform(*args)
              # Do something later
            end

            private

            def around_task
              # Do something before
              # yield
              # Do something after
            end
          end

          SendMessageJob.perform_now
          SendMessageJob.set(queue: :another_queue).perform_later(flag: false)
        RUBY

        Pathname(export).join('_test').join('test.rbs').write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class SendMessageJob < ActiveJob::Base
            def perform: (*untyped) -> void
          end
        RBS
      end

      desc "validate version=#{version} gem=active_job"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/activejob/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/activejob/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
