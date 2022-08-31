require 'aws-sdk-ssm'

ssm = Aws::SSM::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
resp = ssm.add_tags_to_resource(
  resource_type: 'Document',
  resource_id: 'foo',
  tags: [
    { key: 'key', value: 'value' }
  ]
)
