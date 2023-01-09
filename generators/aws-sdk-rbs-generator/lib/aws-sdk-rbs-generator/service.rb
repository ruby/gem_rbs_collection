# frozen_string_literal: true

module AwsSdkRbsGenerator
  class Service
    attr_reader :name, :api, :resources, :paginators, :shape_dictionary
    def initialize(name:, api:, resources:, paginators:, waiters:)
      @name = name
      @api = api
      @resources = resources
      @shape_dictionary = ShapeDictionary.new(service: self)
      @client_class = Views::ClientClass.new(shape_dictionary: @shape_dictionary, waiters:)
      @types_module = Views::TypesModule.new(shape_dictionary: @shape_dictionary)
      @errors_module = Views::ErrorsModule.new(shape_dictionary: @shape_dictionary)
      @root_resource_class = Views::RootResourceClass.new(service: self)
      @resource_classes = @resources.fetch(:resources, []).map do |resource_name, resource|
        Views::ResourceClass.new(service: self, shape_dictionary:, resource_name:, resource:)
      end
      @waiters_module = Views::WaitersModule.new(shape_dictionary: @shape_dictionary, waiters:)
    end

    def write_files(dir:)
      dir_path = "#{dir}/#{gem_name}/#{gem_major_version}"
      FileUtils.mkdir_p(dir_path)

      source_files.each do |path, rbs|
        file_path = "#{dir_path}/#{path}"
        File.write(file_path, rbs)
      end
    end

    def source_files
      [].tap do |result|
        result << ['types.rbs', @types_module.render] # should be first
        result << ['errors.rbs', @errors_module.render]
        result << ['client.rbs', @client_class.render]
        result << ['resource.rbs', @root_resource_class.render]
        result << ['waiters.rbs', @waiters_module.render] if !@waiters_module.waiters.empty?
        @resource_classes.each do |resource_class|
          result << ["#{resource_class.name.underscore}.rbs", resource_class.render]
        end
      end
    end

    private

    def gem_name
      "aws-sdk-#{@name.downcase}"
    end

    def gem_major_version
      File.read("#{Services::SRC_PATH}/gems/#{gem_name}/VERSION").split(".").first
    end
  end
end
