stdlib_dependencies = %w[benchmark date digest forwardable json logger monitor mutex_m singleton time minitest]
gem_dependencies = %w[nokogiri]
rails_dependencies = %w[activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :active_model do
      install_to = File.expand_path("../../../gems/activemodel/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        sh "cp -a out/#{version}/active_model.rbs #{install_to}"
        sh "cp -a out/#{version}/active_model #{install_to}"
        sh "rm #{install_to}/active_model/railtie.rbs"

        Pathname(install_to).join("patch.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator
          # TODO: These signatures should be defined as library signatures.

          class Delegator
          end
          class SimpleDelegator < Delegator
          end
        RBS
      end
    end
  end
end
