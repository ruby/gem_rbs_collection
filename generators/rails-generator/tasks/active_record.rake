stdlib_dependencies = %w[time monitor singleton logger mutex_m json date benchmark digest forwardable did_you_mean openssl socket minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[activesupport activemodel]

VERSIONS.each do |version|
  namespace version do
    namespace :active_record do
      export = "export/activerecord/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        sh "cp -a out/#{version}/active_record.rbs #{export}"
        sh "cp -a out/#{version}/active_record #{export}"
        sh "cp -a out/#{version}/arel #{export}"
        sh "cp -a out/#{version}/arel.rbs #{export}"
        sh "cp -a out/#{version}/_active_record_relation.rbs #{export}"
        sh "cp -a out/#{version}/_active_record_relation_class_methods.rbs #{export}"

        # split to railties
        sh "rm #{export}/active_record/railtie.rbs"
        sh "rm -f #{export}/active_record/destroy_association_async_job.rbs"

        sh "rm -fr #{export}/active_record/connection_adapters" # FIXME we want to support
        sh "rm -fr #{export}/active_record/migration/compatibility" # FIXME we want to support

        # split to activestorage
        sh "cat out/#{version}/active_record/base.rbs | grep -v ActiveStorage > #{export}/active_record/base.rbs"

        Pathname(export).join("EXTERNAL_TODO.rbs").write(<<~RBS)
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
          export: export,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )

        Pathname(export).join('_test').join('test.rb').write(<<~RUBY)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class User < ActiveRecord::Base
          end

          user = User.new
        RUBY

        Pathname(export).join('_test').join('test.rbs').write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class User < ActiveRecord::Base
          end
        RBS
      end

      desc "validate version=#{version} gem=active_record"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/activerecord/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/activerecord/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
