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

resp = client.send_message_batch(
  queue_url: "String", # required
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
resp.successful[0].id.upcase
