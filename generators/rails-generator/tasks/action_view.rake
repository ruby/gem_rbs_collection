stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest did_you_mean]
gem_dependencies = %w[nokogiri i18n rack]
rails_dependencies = %w[activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :action_view do
      export = "export/actionview/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        sh "cp -a out/#{version}/action_view.rbs #{export}"
        sh "cp -a out/#{version}/action_view #{export}"
        sh "cp -a out/#{version}/erubi.rbs #{export}"
        sh "cp -a out/#{version}/erubi #{export}"
        sh "rm #{export}/action_view/railtie.rbs"
        sh "rm -fr #{export}/action_view/test_case"
        sh "rm #{export}/action_view/test_case.rbs"

        File.open("out/#{version}/action_view/partial_renderer.rbs") do |r|
          File.open("#{export}/action_view/partial_renderer.rbs", "w+") do |w|
            outs = r.each_line.select do |line|
              !line.include?("prepend ActiveRecord::Railties::CollectionCacheAssociationLoading")
            end
            w.puts(outs)
          end
        end

        File.open("out/#{version}/action_view/routing_url_for.rbs") do |r|
          File.open("#{export}/action_view/routing_url_for.rbs", "w+") do |w|
            outs = r.each_line.select do |line|
              !line.include?("include ActionDispatch::Routing::UrlFor")
            end
            w.puts(outs)
          end
        end

        Pathname(export).join("EXTERNAL_TODO.rbs").write(<<~RBS)
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

      desc "validate version=#{version} gem=action_view"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/actionview/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/actionview/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
