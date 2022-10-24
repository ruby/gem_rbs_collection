stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[]

VERSIONS.each do |version|
  namespace version do
    namespace :active_support do
      install_to = File.expand_path("../../../gems/activesupport/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        # minimum
        sh "cp -a out/#{version}/active_support.rbs #{install_to}"
        sh "cp -a out/#{version}/active_support #{install_to}"
        sh "rm #{install_to}/active_support/railtie.rbs"

        # core_ext
        %w[
          array benchmark big_decimal class date date_and_time date_time digest
          enumerable file hash integer kernel load_error marshal module name_error numeric
          object pathname range regexp securerandom string symbol time uri
        ].each do |lib|
          out = "out/#{version}/#{lib}"
          sh "cp -a #{out} #{install_to}" if File.exist?(out)
          sh "cp -a #{out}.rbs #{install_to}" if File.exist?("#{out}.rbs")
        end

        # 5.2
        sh "cp -a out/#{version}/logger_silence.rbs #{install_to}" if File.exist?("out/#{version}/logger_silence.rbs")

        Pathname(install_to).join("EXTERNAL_TODO.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          module DRb
            module DRbUndumped
            end
          end
          module Concurrent
            class Map
            end
          end
        RBS

        case version
        when "6.0", "6.1"
          sh "rm -fr #{install_to}/uri"
        when "7.0"
          # deprecated
          sh "rm -fr #{install_to}/uri{,.rbs}"
        end

        generate_manifest(
          install_to: install_to,
          stdlib_dependencies: stdlib_dependencies
        )
        generate_test_script(
          gem: :activesupport,
          version: version,
          install_to: install_to,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )

        Pathname(install_to).join('_test').join('test.rb').write(<<~'RUBY')
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          require 'active_support/all'

          # Test ActiveSupport::NumericWithFormat
          42.to_s
          42.to_s(:phone)

          3.days.ago + 1.minute
        RUBY
      end
    end
  end
end
