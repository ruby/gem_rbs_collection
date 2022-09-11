stdlib_dependencies = %w[benchmark date digest forwardable json logger monitor mutex_m singleton time minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :active_model do
      export = "export/activemodel/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        sh "cp -a out/#{version}/active_model.rbs #{export}"
        sh "cp -a out/#{version}/active_model #{export}"
        sh "rm #{export}/active_model/railtie.rbs"

        Pathname(export).join("EXTERNAL_TODO.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class Delegator
          end
          class SimpleDelegator < Delegator
          end
        RBS
      end

      desc "validate version=#{version} gem=active_model"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/activemodel/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/activemodel/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
