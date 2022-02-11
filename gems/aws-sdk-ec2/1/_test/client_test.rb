require "aws-sdk-ec2"

client = Aws::EC2::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
client.describe_instances(
  filters: [
    { name: 'foo', values: ['bar'] }
  ]
).reservations.each do |reservation|
  reservation.groups.each do |group|
    group.group_name.upcase
  end
end
