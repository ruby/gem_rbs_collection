# frozen_string_literal: true

module AwsSdkRbsGenerator
  class Services
    SRC_PATH = File.expand_path("../../../_src", __FILE__)
    APIS_PATH = "#{SRC_PATH}/apis"
    MANIFEST_PATH = "#{SRC_PATH}/services.json"

    def initialize(manifest_path: MANIFEST_PATH)
      @manifest_path = manifest_path
    end

    def [](identifier)
      build_service(identifier, manifest[identifier.to_sym])
    end

    def each
      manifest.each do |identifier, _config|
        p identifier
        next if identifier == "AmplifyBackend"
        next if identifier == "XRay"

        begin
          yield self[identifier]
        rescue => e
          p [identifier, e]
        end
      end
    end

    private

    def build_service(svc_name, config)
      config => { models: }
      Service.new(
        name: svc_name,
        api: load_api(models),
        resources: load_resources(models),
        paginators: load_paginators(models),
        waiters: load_waiters(models),
      )
    end

    def manifest
      @manifest ||= load_json(@manifest_path)
    end

    def load_api(models_dir)
      load_json(File.expand_path("#{models_dir}/api-2.json", APIS_PATH))
    end

    def load_resources(models_dir)
      load_json(File.expand_path("#{models_dir}/resources-1.json", APIS_PATH))
    end

    def load_paginators(models_dir)
      load_json(File.expand_path("#{models_dir}/paginators-1.json", APIS_PATH))
    end

    def load_waiters(models_dir)
      load_json(File.expand_path("#{models_dir}/waiters-2.json", APIS_PATH))
    end

    def load_json(path)
      if File.exist?(path)
        path
          .then { File.read(_1) }
          .then { JSON.parse(_1, symbolize_names: true) }
          .then { ActiveSupport::HashWithIndifferentAccess.new(_1) }
      else
        {}
      end
    end
  end
end
