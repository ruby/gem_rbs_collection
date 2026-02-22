# frozen_string_literal: true

require "google-cloud-ai_platform-v1"

client = Google::Cloud::AIPlatform::V1::PredictionService::Client.new

Google::Cloud::AIPlatform::V1::PredictionService::Client.new do |config|
  config.endpoint = "aiplatform.googleapis.com"
  config.timeout = 30.0
end

response = client.generate_content({
  model: "projects/my-project/locations/us-central1/publishers/google/models/gemini-pro",
  contents: [{ role: "USER", parts: [{ text: "Hello" }] }]
})

request = Google::Cloud::AIPlatform::V1::GenerateContentRequest.new
request.model = "projects/my-project/locations/us-central1/publishers/google/models/gemini-pro"
request.contents = []
response2 = client.generate_content(request)

candidates = response.candidates
candidates2 = response2.candidates

candidate = candidates.first
if candidate
  content = candidate.content
  _finish_reason = candidate.finish_reason

  _role = content.role
  parts = content.parts

  part = parts.first
  _text = part.text if part
end

candidate2 = candidates2.first
_content2 = candidate2.content if candidate2
