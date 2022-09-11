require 'rbs'

stdlib_dependencies = %w[time monitor singleton logger mutex_m json date benchmark digest forwardable did_you_mean openssl socket minitest securerandom ipaddr]
gem_dependencies = %w[nokogiri i18n rack]
rails_dependencies = %w[activesupport activemodel activejob activerecord actionview actionpack]

VERSIONS.each do |version|
  namespace version do
    namespace :active_storage do
      export = "export/activestorage/#{version}"

      desc "export to #{export}"
      task :export do
        sh "rm -fr #{export}"
        sh "mkdir -p #{export}"

        # base
        sh "cp -a out/#{version}/active_storage.rbs #{export}"
        sh "cp -a out/#{version}/active_storage #{export}"
        sh "rm #{export}/active_storage/engine.rbs"
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
        File.open("#{export}/active_record_base.rbs", "w+") do |f|
          RBS::Writer.new(out: f).write(decls)
        end

        generate_test_script(
          gem: :activestorage,
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
            has_one_attached :one_image
            has_many_attached :many_image
          end

          user = User.new
          one = ActiveStorage::Attached::One.new("one_image", user)
          one.url
        RUBY

        Pathname(export).join('_test').join('test.rbs').write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator

          class User < ActiveRecord::Base
          end
        RBS
      end

      desc "validate version=#{version} gem=active_storage"
      task :validate do
        validate(
          export: export,
          version: version,
          stdlib_dependencies: stdlib_dependencies,
          gem_dependencies: gem_dependencies,
          rails_dependencies: rails_dependencies,
        )
      end

      desc "install to ../../../gems/activestorage/#{version}"
      task :install do
        install_to = File.expand_path("../../../gems/activestorage/#{version}", __dir__)
        sh "rm -fr #{install_to}"
        sh "cp -a #{export} #{install_to}"
      end
    end
  end
end
