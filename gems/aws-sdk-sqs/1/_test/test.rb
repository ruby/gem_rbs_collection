require 'aws-sdk-sqs'

client = Aws::SQS::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
queue_url = "https://example.com/"
client.create_queue(queue_name: "test")
queues = client.list_queues
queues.queue_urls.each do |url|
  puts url
end

attributes = client.get_queue_attributes(
  queue_url: queue_url,
  attribute_names: [ "All" ]
)
attributes.attributes.each do |key, value|
  puts "#{key}: #{value}"
end

resp = client.send_message_batch(
  queue_url: queue_url, # required
  entries: [ # required
    {
      id: "String", # required
      message_body: "String", # required
      delay_seconds: 1,
      message_attributes: {
        "String" => {
          string_value: "String",
          binary_value: "data",
          string_list_values: ["String"],
          binary_list_values: ["data"],
          data_type: "String", # required
        },
      },
      message_system_attributes: {
        "AWSTraceHeader" => {
          string_value: "String",
          binary_value: "data",
          string_list_values: ["String"],
          binary_list_values: ["data"],
          data_type: "String", # required
        },
      },
      message_deduplication_id: "String",
      message_group_id: "String",
    },
  ],
)
resp.successful.each do |s|
  s.id.upcase
end
