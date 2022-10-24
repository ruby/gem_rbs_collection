stdlib_dependencies = %w[time monitor singleton logger mutex_m json date benchmark digest forwardable did_you_mean openssl socket minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[activesupport activemodel]

VERSIONS.each do |version|
  namespace version do
    namespace :active_record do
      install_to = File.expand_path("../../../gems/activerecord/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        sh "cp -a out/#{version}/active_record.rbs #{install_to}"
        sh "cp -a out/#{version}/active_record #{install_to}"
        sh "cp -a out/#{version}/arel #{install_to}"
        sh "cp -a out/#{version}/arel.rbs #{install_to}"
        sh "cp -a out/#{version}/_active_record_relation.rbs #{install_to}"
        sh "cp -a out/#{version}/_active_record_relation_class_methods.rbs #{install_to}"

        # split to railties
        sh "rm #{install_to}/active_record/railtie.rbs"
        sh "rm -f #{install_to}/active_record/destroy_association_async_job.rbs"

        sh "rm -fr #{install_to}/active_record/connection_adapters" # FIXME we want to support
        sh "rm -fr #{install_to}/active_record/migration/compatibility" # FIXME we want to support

        # split to activestorage
        sh "cat out/#{version}/active_record/base.rbs | grep -v ActiveStorage > #{install_to}/active_record/base.rbs"

        Pathname(install_to).join("EXTERNAL_TODO.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          module PG
            class SimpleDecoder
            end
          end
          module GlobalID
            module Identification
            end
            module FixtureSet
            end
          end
        RBS

        generate_test_script(
          gem: :activerecord,
          version: version,
          install_to: install_to,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )

        Pathname(install_to).join('_test').join('test.rb').write(<<~RUBY)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class User < ActiveRecord::Base
          end

          user = User.new
        RUBY

        Pathname(install_to).join('_test').join('test.rbs').write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class User < ActiveRecord::Base
          end
        RBS
      end
    end
  end
end
