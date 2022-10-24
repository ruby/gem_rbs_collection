stdlib_dependencies = %w[benchmark date digest json logger monitor mutex_m pathname singleton time minitest securerandom ipaddr did_you_mean]
gem_dependencies = %w[nokogiri i18n rack rails-dom-testing]
rails_dependencies = %w[activesupport actionview]

VERSIONS.each do |version|
  namespace version do
    namespace :action_pack do
      install_to = File.expand_path("../../../gems/actionpack/#{version}", __dir__)

      desc "install to #{install_to}"
      task :install do
        sh "rm -fr #{install_to}"
        sh "mkdir -p #{install_to}"

        sh "cp -a out/#{version}/action_pack.rbs #{install_to}"
        sh "cp -a out/#{version}/action_pack #{install_to}"
        sh "cp -a out/#{version}/action_controller.rbs #{install_to}"
        sh "cp -a out/#{version}/action_controller #{install_to}"
        sh "cp -a out/#{version}/action_dispatch.rbs #{install_to}"
        sh "cp -a out/#{version}/action_dispatch #{install_to}"
        sh "cp -a out/#{version}/abstract_controller.rbs #{install_to}"
        sh "cp -a out/#{version}/abstract_controller #{install_to}"
        sh "cp -a out/#{version}/mime.rbs #{install_to}"
        sh "cp -a out/#{version}/mime #{install_to}"

        sh "rm #{install_to}/action_controller/railtie.rbs"
        sh "rm #{install_to}/action_dispatch/railtie.rbs"

        Pathname(install_to).join("patch.rbs").write(<<~RBS)
          # !!! GENERATED CODE !!!
          # Please see generators/rails-generator
          # TODO: These signatures should be defined as library signatures.

          class Ripper
          end

          class Delegator
          end

          class SimpleDelegator < ::Delegator
          end

          class ActionDispatch::Cookies::CookieJar
            def to_h: () -> Hash[untyped, untyped]
          end

          module Rack
            module Cache
              class EntityStore
              end
              class MetaStore
              end
            end
            module Session
              class Dalli
              end
            end
            module Test
              class UploadedFile
              end
            end
          end

          module Rails
            module Dom
              module Testing
                module Assertions
                  include Rails::Dom::Testing::Assertions::SelectorAssertions

                  include Rails::Dom::Testing::Assertions::DomAssertions

                  extend ActiveSupport::Concern

                  module DomAssertions
                    public

                    def assert_dom_equal: (untyped expected, untyped actual, ?untyped message) -> untyped

                    def assert_dom_not_equal: (untyped expected, untyped actual, ?untyped message) -> untyped

                    private

                    def fragment: (untyped text) -> untyped
                  end

                  module SelectorAssertions
                    include Rails::Dom::Testing::Assertions::SelectorAssertions::CountDescribable

                    public

                    def assert_select: (*untyped args) { (*untyped) -> untyped } -> untyped

                    def assert_select_email: () { (*untyped) -> untyped } -> untyped

                    def assert_select_encoded: (?untyped element) { (*untyped) -> untyped } -> untyped

                    def css_select: (*untyped args) -> untyped

                    private

                    def assert_size_match!: (untyped size, untyped equals, untyped css_selector, ?untyped message) -> untyped

                    def document_root_element: () -> untyped

                    def nest_selection: (untyped selection) { (untyped) -> untyped } -> untyped

                    def nodeset: (untyped node) -> untyped

                    module CountDescribable
                      extend ActiveSupport::Concern

                      private

                      def count_description: (untyped min, untyped max, untyped count) -> untyped

                      def pluralize_element: (untyped quantity) -> untyped
                    end
                  end
                end
              end
            end
          end
        RBS
      end
    end
  end
end
