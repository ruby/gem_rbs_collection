stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest did_you_mean]
gem_dependencies = %w[nokogiri i18n rack]
rails_dependencies = %w[activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :action_view do
      install_to = File.expand_path("../../../gems/actionview/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        sh "cp -a out/#{version}/action_view.rbs #{install_to}"
        sh "cp -a out/#{version}/action_view #{install_to}"
        sh "cp -a out/#{version}/erubi.rbs #{install_to}"
        sh "cp -a out/#{version}/erubi #{install_to}"
        sh "rm #{install_to}/action_view/railtie.rbs"
        sh "rm -fr #{install_to}/action_view/test_case"
        sh "rm #{install_to}/action_view/test_case.rbs"

        File.open("out/#{version}/action_view/partial_renderer.rbs") do |r|
          File.open("#{install_to}/action_view/partial_renderer.rbs", "w+") do |w|
            outs = r.each_line.select do |line|
              !line.include?("prepend ActiveRecord::Railties::CollectionCacheAssociationLoading")
            end
            w.puts(outs)
          end
        end

        File.open("out/#{version}/action_view/routing_url_for.rbs") do |r|
          File.open("#{install_to}/action_view/routing_url_for.rbs", "w+") do |w|
            outs = r.each_line.select do |line|
              !line.include?("include ActionDispatch::Routing::UrlFor")
            end
            w.puts(outs)
          end
        end

        Pathname(install_to).join("EXTERNAL_TODO.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class Ripper
          end

          class Delegator
          end

          class SimpleDelegator < ::Delegator
          end

          module ERB
            module Util
            end
          end
        RBS
      end
    end
  end
end
