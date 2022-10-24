stdlib_dependencies = %w[time monitor singleton logger mutex_m json date benchmark digest forwardable did_you_mean
                         openssl socket minitest securerandom ipaddr tempfile]
gem_dependencies = %w[nokogiri i18n rack]
rails_dependencies = %w[activesupport activemodel activejob activerecord actionview actionpack]

VERSIONS.each do |version|
  namespace version do
    namespace :active_storage do
      install_to = File.expand_path("../../../gems/activestorage/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        require 'rbs'

        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        # base
        sh "cp -a out/#{version}/active_storage.rbs #{install_to}"
        sh "cp -a out/#{version}/active_storage #{install_to}"
        sh "rm #{install_to}/active_storage/engine.rbs"
        decls = RBS::Parser.parse_signature(RBS::Buffer.new(
          content: File.read("out/#{version}/active_record/base.rbs"),
          name: "out/#{version}/active_record/base.rbs"
        )).map do |decl|
          decl.members.select! do |member|
            case member
            when RBS::AST::Members::Mixin
              # Remove ActiveStorage
              member.name.to_s.include?("ActiveStorage")
            end
          end
          decl
        end
        File.open("#{install_to}/active_record_base.rbs", "w+") do |f|
          RBS::Writer.new(out: f).write(decls)
        end

        generate_test_script(
          gem: :activestorage,
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
            has_one_attached :one_image
            has_many_attached :many_image
          end

          user = User.new
          one = ActiveStorage::Attached::One.new("one_image", user)
          one.url # TODO すでにあるRBSをknown_sigとしてとりこむ
        RUBY

        Pathname(install_to).join('_test').join('test.rbs').write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          # from railties
          class ActiveRecord::Base
            extend ActiveStorage::Attached::Model::ClassMethods
          end
          class User < ActiveRecord::Base
          end
        RBS
      end
    end
  end
end
