require "aws-sdk-s3"

client = Aws::S3::Client.new(
  region: 'ap-test-1'
)
resp = client.list_buckets
resp.buckets.each do |bucket|
  bucket.name.upcase
end

begin
  resp = Aws::S3::Client.new.get_object(bucket: 'test', key: 'test')
  resp.body.read # check streaming
rescue Aws::S3::Errors::InvalidObjectState => e # check Errors
  e.storage_class.downcase
end

# check simple input
resp = client.put_object(
  bucket: 'test',
  key: 'test',
  acl: 'private',
)
resp.etag.tr('', '')

# check CORSRules input and output type
client.put_bucket_cors(
  bucket: "BucketName", # required
  cors_configuration: { # required
    cors_rules: [ # required
      {
        id: "ID",
        allowed_headers: ["AllowedHeader"],
        allowed_methods: ["AllowedMethod"], # required
        allowed_origins: ["AllowedOrigin"], # required
        # expose_headers: ["ExposeHeader"], # check option
        max_age_seconds: 1,
      },
    ],
  },
  content_md5: "ContentMD5",
  expected_bucket_owner: "AccountId",
)
resp = client.get_bucket_cors(
  bucket: "BucketName", # required
  expected_bucket_owner: "AccountId",
)
resp.cors_rules[0].allowed_headers[0].upcase

