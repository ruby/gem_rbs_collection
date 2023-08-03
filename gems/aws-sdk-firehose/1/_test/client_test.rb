require "aws-sdk-firehose"

client = Aws::Firehose::Client.new(
  region: 'ap-test-1',
  stub_responses: true,
)
resp = client.put_record(
  delivery_stream_name: "DeliveryStreamName",
  record: {
    data: "data",
  }
)
raise unless resp.record_id == "PutResponseRecordId"
raise unless !resp.encrypted
