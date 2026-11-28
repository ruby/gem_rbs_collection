require "google/cloud/env"

# @type var env: Google::Cloud::Env
env = Google::Cloud.env
Google::Cloud::Env.get.app_engine?
Google::Cloud::Env.new.cloud_shell?

env.variables.backing_data = { "K_SERVICE" => "my-service", "GAE_MEMORY_MB" => "512" }
env.variables.backing_data = ENV
env.variables.with_backing_data({ "GAE_INSTANCE" => "instance" }) { env.app_engine? }
# @type var var_value: String?
var_value = env.variables["HOME"]
env.variables.get(:HOME)

# @type var compute_metadata: Google::Cloud::Env::ComputeMetadata
compute_metadata = env.compute_metadata
overrides = Google::Cloud::Env::ComputeMetadata::Overrides.new
overrides.add_ping
         .add("project/project-id", "my-project")
         .add("instance/attributes/", "a\nb", query: { "recursive" => "true" }, headers: { "X" => "y" })
response = Google::Cloud::Env::ComputeMetadata::Response.new(404, "Not found", { "Metadata-Flavor" => "Google" })
overrides.add_response("instance/zone", response)
# @type var found: Google::Cloud::Env::ComputeMetadata::Response?
found = overrides.lookup("project/project-id")
overrides.empty?
compute_metadata.overrides = overrides

# @type var project_id: String?
project_id = env.project_id
# @type var numeric_project_id: Integer?
numeric_project_id = env.numeric_project_id
# @type var tags: Array[String]?
tags = env.instance_tags
env.instance_attribute_keys
env.instance_attribute("cluster-name")
env.instance_name
env.instance_zone
env.instance_machine_type
env.instance_description
env.knative_service_id
env.knative_service_name
env.knative_service_revision
env.app_engine_service_id
env.app_engine_service_name
env.app_engine_service_version
env.app_engine_memory_mb
env.kubernetes_engine_cluster_name
env.container_engine_cluster_name
env.kubernetes_engine_namespace_id
env.container_engine_namespace_id
env.knative? || env.app_engine_flexible? || env.app_engine_standard? || env.kubernetes_engine? || env.container_engine?
env.compute_engine? || env.raw_compute_engine? || env.logging_agent_expected?

begin
  # @type var metadata: String?
  metadata = env.lookup_metadata("project", "project-id", query: { recursive: "true" })
  # @type var metadata_response: Google::Cloud::Env::ComputeMetadata::Response
  metadata_response = env.lookup_metadata_response("instance", "zone")
  # @type var status: Integer
  status = metadata_response.status
  # @type var body: String
  body = metadata_response.body
  metadata_response.headers["Metadata-Flavor"]
  # @type var retrieved_at: Float
  retrieved_at = metadata_response.retrieval_monotonic_time
  metadata_response.google_flavor?
rescue Google::Cloud::Env::MetadataServerNotResponding => e
  e.message
end

env.metadata?
# @type var confirmed: :confirmed
confirmed = env.ensure_metadata(timeout: 1.0)

compute_metadata.host = "metadata.google.internal"
compute_metadata.host = nil
# @type var host: String
host = compute_metadata.host
compute_metadata.retry_count = nil
compute_metadata.retry_timeout = 10
compute_metadata.retry_interval = 0.1
compute_metadata.warmup_time = Google::Cloud::Env::ComputeMetadata::DEFAULT_WARMUP_TIME
compute_metadata.open_timeout = 1
compute_metadata.request_timeout = Google::Cloud::Env::ComputeMetadata::DEFAULT_REQUEST_TIMEOUT
compute_metadata.open_timeout
compute_metadata.request_timeout
# @type var body_or_nil: String?
body_or_nil = compute_metadata.lookup("project/project-id", retry_count: 1, retry_timeout: nil)
compute_metadata.lookup_response(nil, open_timeout: 0.1, request_timeout: 0.5)
# @type var existence: :no | :unconfirmed | :confirmed
existence = compute_metadata.check_existence(retry_count: :default)
compute_metadata.existence_immediate
compute_metadata.ensure_existence
# @type var expiry: Float | false | nil
expiry = compute_metadata.expiration_time_of("project/project-id")
compute_metadata.with_overrides(nil) { compute_metadata.overrides }
compute_metadata.overrides&.clear

Google::Cloud::Env::ComputeMetadata.new(variables: env.variables, compute_smbios: Google::Cloud::Env::ComputeSMBIOS.new)
Google::Cloud::Env::MetadataServerNotResponding.new
Google::Cloud::Env::MetadataServerNotResponding.new("down")

smbios = env.compute_smbios
# @type var product_name: String
product_name = smbios.product_name
smbios.product_name_source
smbios.google_compute?
smbios.override_product_name = "Google Compute Engine"
# @type var block_result: Integer
block_result = smbios.with_override_product_name(nil) { 1 }

file_system = env.file_system
# @type var contents: String?
contents = file_system.read("/etc/hostname")
file_system.read("/bin/true", binary: true)
file_system.overrides = { "/etc/hostname" => "host" }
file_system.with_overrides(nil) { file_system.overrides }
