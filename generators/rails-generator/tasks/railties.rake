stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest securerandom ipaddr did_you_mean forwardable openssl socket]
gem_dependencies = %w[nokogiri i18n rack rails-dom-testing]
rails_dependencies = %w[actionpack actionview activejob activemodel activerecord activestorage activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :railties do
      export = "export/railties/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        if File.exist?("out/#{version}/active_record/destroy_association_async_job.rbs")
          sh "mkdir #{export}/active_record"
          sh "cp out/#{version}/active_record/destroy_association_async_job.rbs #{export}/active_record/destroy_association_async_job.rbs"
        end

        sh "cp -a out/#{version}/railties_mixin #{export}"

        # TODO: we want to support
        sh "rm -fr #{export}/railties_mixin/active_record/connection_adapters"
        sh "rm -fr #{export}/railties_mixin/i18n"
        sh "rm -fr #{export}/railties_mixin/sq_lite3"
      end

      desc "validate version=#{version} gem=railties"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/railties/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/railties/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
