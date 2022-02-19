require 'aws-sdk-s3'

creds = Object.new
def creds.credentials
  c = Object.new
  def c.access_key_id = 'a'
  def c.secret_access_key = 'k'
  def c.session_token = 's'
  c
end
region = "ap-test-1"
bucket = "bucket"

post = Aws::S3::PresignedPost.new(creds, region, bucket, {
  key: '/uploaded/object/key',
  content_length_range: 0..1024,
  acl: 'public-read',
  metadata: {
    'original-filename' => '${filename}'
  }
})
post.fields

post = Aws::S3::PresignedPost.new(creds, region, bucket).
  key('/uploaded/object/key').
  content_length_range(0..1024).
  acl('public-read').
  metadata('original-filename' => '${filename}').
  fields

post = Aws::S3::PresignedPost.new(creds, region, bucket)
post.content_type('text/plain')

post = Aws::S3::PresignedPost.new(creds, region, bucket, {
  key_starts_with: '/images/',
  content_type_starts_with: 'image/',
  # ...
})

post = Aws::S3::PresignedPost.new(creds, region, bucket, {
  key: 'object-key',
  allow_any: ['Filename'],
  # ...
})

post = Aws::S3::PresignedPost.new(creds, region, bucket).
  key('/fixed/key').
  metadata(foo: 'bar')
post.fields['x-amz-meta-foo']

post = Aws::S3::PresignedPost.new(creds, region, bucket, {
  key: '/fixed/key',
  metadata: {
    'original-filename': '${filename}'
  }
})

post.fields.each do |name, value|
  name.upcase
  value.upcase
end
