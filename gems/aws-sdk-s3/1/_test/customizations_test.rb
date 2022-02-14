require "aws-sdk-s3"

client = Aws::S3::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
resource = Aws::S3::Resource.new(client: client)

bucket = resource.bucket('a')
bucket.url.upcase
bucket.url(secure: false).upcase
bucket.url(secure: true).upcase
bucket.url(virtual_host: false).upcase
# bucket.url(virtual_host: true).upcase
bucket.url(virtual_host: false, secure: false).upcase
bucket.url(virtual_host: false, secure: true).upcase
bucket.url(virtual_host: true, secure: false).upcase
bucket.url(virtual_host: true, secure: true).upcase

bucket.presigned_post

object = bucket.object('b')
object.copy_from('a/c').copy_object_result
object.copy_from('a/c', multipart_copy: false).copy_object_result
object.copy_from(bucket: 'a', key: 'c').copy_object_result
object.copy_from(bucket: 'a', key: 'c', multipart_copy: false).copy_object_result
object.copy_from(resource.bucket('a').object('c')).copy_object_result
object.copy_from(resource.bucket('a').object('c'), multipart_copy: false).copy_object_result
object.copy_from('a/c', multipart_copy: true, content_length: 5 * 1024 * 1024).location
object.copy_from(bucket: 'a', key: 'c', multipart_copy: true, content_length: 5 * 1024 * 1024).location
object.copy_from(resource.bucket('a').object('c'), multipart_copy: true, content_length: 5 * 1024 * 1024).location

object.copy_to('a/c').copy_object_result
object.copy_to('a/c', multipart_copy: false).copy_object_result
object.copy_to(bucket: 'a', key: 'c').copy_object_result
object.copy_to(bucket: 'a', key: 'c', multipart_copy: false).copy_object_result
object.copy_to(resource.bucket('a').object('c')).copy_object_result
object.copy_to(resource.bucket('a').object('c'), multipart_copy: false).copy_object_result
object.copy_to('a/c', multipart_copy: true, content_length: 5 * 1024 * 1024).location
object.copy_to(bucket: 'a', key: 'c', multipart_copy: true, content_length: 5 * 1024 * 1024).location
object.copy_to(resource.bucket('a').object('c'), multipart_copy: true, content_length: 5 * 1024 * 1024).location

object.move_to('a/c').delete_marker
object.move_to(bucket: 'a', key: 'c').delete_marker
object.move_to(resource.bucket('a').object('c')).delete_marker

object.presigned_post
object.presigned_url(:get).downcase
object.presigned_url(:get, expires_in: 604800).downcase
object.presigned_request(:get)
object.public_url.downcase
object.upload_stream do |w|
  w.write 'a'
end
object.upload_file('tmp') do |res|
  res.etag
end
object.download_file('tmp')
object.download_file('tmp', mode: 'get_range', chunk_size: 1)
