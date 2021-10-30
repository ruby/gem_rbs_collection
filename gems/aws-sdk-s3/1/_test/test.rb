require "aws-sdk-s3"

client = Aws::S3::Client.new
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

