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
  resp.body.read
rescue Aws::S3::Errors::InvalidObjectState => e
  e.storage_class.downcase
end

resp = client.put_object(
  bucket: 'test',
  key: 'test',
  acl: 'private',
)
resp.etag.tr('', '')

resp = client.complete_multipart_upload(
  bucket: "examplebucket",
  key: "bigobject",
  multipart_upload: {
    parts: [
      {
        etag: "\"d8c2eafd90c266e19ab9dcacc479f8af\"",
        part_number: 1,
      },
      {
        etag: "\"d8c2eafd90c266e19ab9dcacc479f8af\"",
        part_number: 2,
      },
    ],
  },
  upload_id: "7YPBOJuoFiQ9cz4P3Pe6FIZwO4f7wN93uHsNBEw97pl5eNwzExg0LAT2dUN91cOmrEQHDsP3WA60CEg--",
)
resp.location.upcase
