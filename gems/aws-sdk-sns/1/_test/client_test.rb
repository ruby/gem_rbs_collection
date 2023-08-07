require "aws-sdk-sns"

client = Aws::SNS::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
resp = client.list_endpoints_by_platform_application(
  platform_application_arn: "String", # required
  next_token: "String",
)
resp.endpoints.each do |endpoint|
  endpoint.attributes["String"]
end
