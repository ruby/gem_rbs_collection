stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest securerandom ipaddr did_you_mean forwardable openssl socket]
gem_dependencies = %w[nokogiri i18n rack rails-dom-testing]
rails_dependencies = %w[actionpack actionview activejob activemodel activerecord activestorage activesupport]

VERSIONS.each do |version|
  namespace version do
    namespace :railties do
      install_to = File.expand_path("../../../gems/railties/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        if File.exist?("out/#{version}/active_record/destroy_association_async_job.rbs")
          sh "mkdir #{install_to}/active_record"
          sh "cp out/#{version}/active_record/destroy_association_async_job.rbs #{install_to}/active_record/destroy_association_async_job.rbs"
        end

        sh "cp -a out/#{version}/railties_mixin #{install_to}"

        # TODO: we want to support
        sh "rm -fr #{install_to}/railties_mixin/active_record/connection_adapters"
        sh "rm -fr #{install_to}/railties_mixin/i18n"
        sh "rm -fr #{install_to}/railties_mixin/sq_lite3"
      end
    end
  end
end
