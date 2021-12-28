client = Aws::SQS::Client.new(
  region: 'ap-test-1'
)
client.create_queue(queue_name: "test")
queues = client.list_queues
queues.queue_urls.each do |url|
  puts url
end

attributes = client.get_queue_attributes(
  queue_url: "url",
  attribute_names: [ "All" ]
)
attributes.attributes.each do |key, value|
  puts "#{key}: #{value}"
end
