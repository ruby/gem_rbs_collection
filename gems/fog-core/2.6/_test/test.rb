require "fog/core"

Fog.mock!
# @type var mocking: bool
mocking = Fog.mocking?
mocking = Fog.mock?
mocking = Fog.mocking

Fog.credential = :production
# @type var credential: Symbol
credential = Fog.credential
credential.to_s
Fog.credential = nil
Fog.credentials_path = "/etc/fog.yml"
# @type var path: String?
path = Fog.credentials_path
path&.length
Fog.credentials = { example_username: "alice" }

Fog.timeout = 30
Fog.timeout.floor
Fog.interval = 2
Fog.interval = ->(retries) { retries * 2 }
Fog.max_interval = 10
Fog.interval
Fog.max_interval.floor

# These calls poll or time out, so they are type checked but never run.
# @type var wait_examples: ^() -> void
wait_examples = -> do
  # @type var waited: { duration: Numeric }
  waited = Fog.wait_for(5, 1) { Fog.mocking? }
  waited[:duration].floor
  Fog.wait_for { true }
  Fog.wait_for(10) { true }

  begin
    Fog.wait_for(0, 0) { false }
  rescue Fog::Errors::TimeoutError, Fog::Errors::NotFound, Fog::Errors::LoadError, Fog::Errors::NotImplemented => e
    e.message.length
  rescue Fog::Service::NotFound, Fog::Service::Error => e
    e.message.length
  end

  Fog::Mock.reset
end

Fog.services[:storage]&.first&.to_s
Fog.providers[:example]&.upcase

Fog::Core::VERSION.length

error = Fog::Errors::Error.new("failed")
error.verbose = "detail"
error.verbose&.length
Fog::Errors::MockNotImplemented.new("not yet").message.length
[Fog::Errors::NotFound, Fog::Errors::LoadError, Fog::Errors::TimeoutError, Fog::Errors::NotImplemented].map(&:name)
Fog::Service::Error.new("failed").message.length
Fog::Service::NotFound.new("missing").message.length

module Fog
  module Example
    extend Fog::Provider

    service(:storage, "Storage")
    service(:compute, "Compute")
  end

  module Storage
    class Example < Fog::Service
      requires :example_username
      recognizes :example_url, :example_port
      secrets :example_password
      model_path "fog/example/models/storage"
      request_path "fog/example/requests/storage"
      model :directory
      collection :directories, "fog/example/models/storage/directories"
      request :get_service
      request :put_bucket, "fog/example/requests/storage/put_bucket"

      Fog::Storage::Example.requirements.first&.to_s
      Fog::Storage::Example.recognized.first&.to_s
      Fog::Storage::Example.collections.first&.to_s
      Fog::Storage::Example.requests.size
      Fog::Storage::Example.mocked_requests.first&.to_s
    end
  end
end

Fog::Example.services.first&.to_s

# These calls build services and load provider files, so they are type checked but never run.
# @type var use_services: ^() -> void
use_services = -> do
  Fog::Storage.new(provider: "AWS", aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"), aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"), region: "us-east-1")
  Fog::Storage[:aws]
  Fog::Storage.providers.first&.to_s
  Fog::Compute.new(provider: "AWS", region: "us-east-1")
  Fog::Compute[:aws]
  Fog::DNS.new(provider: "AWS")
  Fog::CDN.new(provider: "AWS")
  Fog::Identity.new(provider: "OpenStack")
  Fog::Network.new(provider: "OpenStack")
  Fog::Volume.new(provider: "OpenStack")
  Fog::Image.new(provider: "OpenStack")
  Fog::Orchestration.new(provider: "OpenStack")
  Fog::Account.new(provider: "Example")
  Fog::Baremetal.new(provider: "Example")
  Fog::Billing.new(provider: "Example")
  Fog::Introspection.new(provider: "Example")
  Fog::Metering.new(provider: "Example")
  Fog::Monitoring.new(provider: "Example")
  Fog::NFV.new(provider: "Example")
  Fog::Support.new(provider: "Example")
  Fog::VPN.new(provider: "Example")
  Fog::Example[:storage]
  Fog::Storage::Example.new(example_username: "alice")
end

class Directory < Fog::Model
  identity :key
  attribute :creation_date, type: :time
  attribute :location, aliases: ["Location"], default: "us"
  has_many :files, :files
  ignore_attributes :internal

  def save
    requires :key
    requires_one :creation_date, :location
    super
  end
end

Directory.attributes.first&.to_s
Directory.aliases.keys
Directory.associations.keys
Directory.default_values.keys
Directory.masks.keys
Directory.ignored_attributes.first&.length
Directory.has_one :owner, :owners
Directory.has_one_identity :acl, :acls
Directory.has_many_identities :tags, :tag_sets

class Directories < Fog::Collection
  model Directory

  def all(options = {})
    load([{ key: "bucket" }])
  end
end

Directories.model

# @type var use_models: ^() -> void
use_models = -> do
  dir = Directory.new(key: "bucket", service: Fog::Storage.new(provider: "Example", example_username: "alice"))
  dir.merge_attributes(location: "eu").identity_name&.to_s
  dir.identity = "bucket"
  dir.identity
  dir.persisted?
  dir.attributes.keys
  dir.associations.keys
  dir.all_attributes.keys
  dir.all_associations.keys
  dir.all_associations_and_attributes.keys
  dir.filter_attributes(:key, :location).keys
  dir.collection = nil
  dir.service
  dir.to_json.length
  dir.save
  dir.create
  dir.update
  dir.destroy
  # @type var reloaded: Directory?
  reloaded = dir.reload
  reloaded&.persisted?
  dir.wait_for(10, 1) { persisted? }[:duration].floor
  dir.wait_for { persisted? }

  directories = Directories.new(service: Fog::Storage.new(provider: "Example", example_username: "alice"))
  directories.create(key: "other")
  directories.destroy("other")
  directories.new(key: "third")
  directories.load([{ key: "fourth" }]).size
  directories.reload.size
  directories.model
  directories.service
  directories.table([:key])
  directories.table
  directories.to_json.length
  directories.map { |d| d }.size
end

Fog.unmock!
