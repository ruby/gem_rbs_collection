stdlib_dependencies = %w[time monitor singleton logger mutex_m json date benchmark digest minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :active_job do
      install_to = File.expand_path("../../../gems/activejob/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        sh "cp -a out/#{version}/active_job.rbs #{install_to}"
        sh "cp -a out/#{version}/active_job #{install_to}"
        sh "rm #{install_to}/active_job/railtie.rbs"

        Pathname(install_to).join("patch.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator
          # TODO: These signatures should be defined as library signatures.

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
          install_to: install_to,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )

        Pathname(install_to).join('_test').join('test.rb').write(<<~RUBY)
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

        Pathname(install_to).join('_test').join('test.rbs').write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class SendMessageJob < ActiveJob::Base
            def perform: (*untyped) -> void
          end
        RBS
      end
    end
  end
end
