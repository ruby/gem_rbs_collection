require "aws-sdk-kms"

client = Aws::KMS::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
client.decrypt(ciphertext_blob: 'blob').plaintext
