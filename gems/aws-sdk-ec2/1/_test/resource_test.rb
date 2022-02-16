require "aws-sdk-ec2"

resource = Aws::EC2::Resource.new
resource.instances(filters: [
  { name: 'foo', values: ['bar'] }
]).each do |instance|
  instance.network_interfaces.each do |network_interface|
    network_interface.owner_id.upcase
  end
end
