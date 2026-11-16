require "openai"
require "stringio"

OpenAI.configure do |config|
  config.access_token = "token"
  config.admin_token = "admin"
  config.organization_id = "org"
  config.uri_base = "https://example.com/"
  config.request_timeout = 240
  config.log_errors = false
  config.api_type = :azure
  config.api_version = "2024-02-01"
  config.extra_headers = { "X-Test" => "1" }
end

# @type var configuration: OpenAI::Configuration
configuration = OpenAI.configuration
configuration.access_token&.upcase
configuration.admin_token&.upcase
configuration.organization_id&.upcase
configuration.uri_base.upcase
configuration.request_timeout.positive?
configuration.log_errors ? 1 : 0
configuration.api_version.upcase
configuration.extra_headers.keys
configuration.api_type.to_s
OpenAI.configuration = OpenAI::Configuration.new
OpenAI.rough_token_count("hello").succ
OpenAI.rough_token_count.succ
OpenAI::VERSION.upcase

client = OpenAI::Client.new
client = OpenAI::Client.new(access_token: "token", request_timeout: 240)
client = OpenAI::Client.new(
  access_token: "token",
  admin_token: "admin",
  api_type: :azure,
  api_version: "2024-02-01",
  extra_headers: { "X-Test" => "1" },
  log_errors: false,
  organization_id: "org",
  uri_base: "https://openrouter.example/api/v1"
)
client_options = { access_token: "token", uri_base: "https://openrouter.example/api/v1" }
client = OpenAI::Client.new(**client_options)
client = OpenAI::Client.new({ access_token: "token" })
client = OpenAI::Client.new do |f|
  f.request :url_encoded
end

client.access_token = "other"
client.access_token&.upcase
client.admin_token&.upcase
client.api_type.to_s
client.api_version.upcase
client.extra_headers.keys
client.log_errors ? 1 : 0
client.organization_id&.upcase
client.request_timeout.positive?
client.uri_base.upcase
client.faraday_middleware&.call(Faraday.new)
client.azure? ? 1 : 0
client.add_headers("X-Session" => "abc").keys
client.beta(assistants: "v2").access_token&.upcase

# These calls send requests to the API, so they are only defined here.
# @type var call_api: ^() -> void
call_api = lambda do
  # @type var response: Hash[String, untyped]
  # @type var streamed: String
  client.admin.access_token&.upcase
  response = client.chat(
    parameters: {
      model: "gpt-4o-mini",
      messages: [{ role: "user", content: "Hello!" }],
      temperature: 0.7
    }
  )
  response.dig("choices", 0, "message", "content")
  response = client.chat
  streamed = client.chat(
    parameters: {
      model: "gpt-4o",
      messages: [{ role: "user", content: "Hello!" }],
      stream: proc { |chunk, _event| chunk }
    }
  )
  streamed.empty?
  response = client.embeddings(parameters: { model: "text-embedding-3-small", input: "text" })
  response = client.completions(parameters: { model: "gpt-3.5-turbo-instruct", prompt: "Once upon a time" })
  streamed = client.completions(parameters: { model: "gpt-3.5-turbo-instruct", prompt: "Once", stream: proc { |chunk, _event| chunk } })
  response = client.moderations(parameters: { input: "text" })

  response = client.audio.transcribe(parameters: { model: "whisper-1", file: File.open("audio.mp3", "rb") })
  response = client.audio.translate(parameters: { model: "whisper-1", file: StringIO.new("data") })
  # @type var text: String
  text = client.audio.transcribe(parameters: { model: "whisper-1", file: File.open("audio.mp3", "rb"), response_format: "text" })
  text = client.audio.translate(parameters: { model: "whisper-1", file: StringIO.new("data"), response_format: "srt" })
  # @type var audio: String
  audio = client.audio.speech(parameters: { model: "tts-1", input: "Hello", voice: "alloy" })
  audio.bytesize

  response = client.files.list
  response = client.files.list(parameters: { purpose: "assistants" })
  response = client.files.upload(parameters: { file: "data.jsonl", purpose: "fine-tune" })
  response = client.files.retrieve(id: "file-1")
  response = client.files.retrieve(id: "file-1", parameters: {})
  client.files.content(id: "file-1")
  client.files.content(id: "file-1", parameters: {})
  response = client.files.delete(id: "file-1")

  response = client.finetunes.list
  response = client.finetunes.create(parameters: { training_file: "file-1", model: "gpt-4o-mini" })
  response = client.finetunes.retrieve(id: "ft-1")
  response = client.finetunes.cancel(id: "ft-1")
  response = client.finetunes.list_events(id: "ft-1")

  response = client.images.generate(parameters: { prompt: "A cat", size: "256x256" })
  response = client.images.edit(parameters: { prompt: "A cat", image: "image.png", mask: "mask.png" })
  response = client.images.variations(parameters: { image: "image.png", n: 2 })

  response = client.models.list
  response = client.models.retrieve(id: "gpt-4o")
  response = client.models.delete(id: "ft:gpt-4o:org")

  response = client.responses.create(parameters: { model: "gpt-4o", input: "Hello" })
  streamed = client.responses.create(parameters: { model: "gpt-4o", input: "Hello", stream: proc { |chunk, _event| chunk } })
  response = client.responses.retrieve(response_id: "resp_1")
  response = client.responses.delete(response_id: "resp_1")
  response = client.responses.input_items(response_id: "resp_1")
  response = client.responses.input_items(response_id: "resp_1", parameters: { limit: 10 })

  response = client.assistants.list
  response = client.assistants.retrieve(id: "asst_1")
  response = client.assistants.create(parameters: { model: "gpt-4o", name: "Helper" })
  response = client.assistants.modify(id: "asst_1", parameters: { name: "Other" })
  response = client.assistants.delete(id: "asst_1")

  response = client.threads.retrieve(id: "thread_1")
  response = client.threads.create
  response = client.threads.create(parameters: { messages: [] })
  response = client.threads.modify(id: "thread_1", parameters: { metadata: {} })
  response = client.threads.delete(id: "thread_1")

  response = client.messages.list(thread_id: "thread_1")
  response = client.messages.list(thread_id: "thread_1", parameters: { order: "asc" })
  response = client.messages.retrieve(thread_id: "thread_1", id: "msg_1")
  response = client.messages.create(thread_id: "thread_1", parameters: { role: "user", content: "Hi" })
  response = client.messages.modify(thread_id: "thread_1", id: "msg_1", parameters: { metadata: {} })
  response = client.messages.delete(thread_id: "thread_1", id: "msg_1")

  response = client.runs.list(thread_id: "thread_1")
  response = client.runs.list(thread_id: "thread_1", parameters: { limit: 5 })
  response = client.runs.retrieve(thread_id: "thread_1", id: "run_1")
  response = client.runs.create(thread_id: "thread_1", parameters: { assistant_id: "asst_1" })
  response = client.runs.create(thread_id: "thread_1", parameters: { assistant_id: "asst_1" }, query_parameters: { include: [] })
  response = client.runs.modify(id: "run_1", thread_id: "thread_1", parameters: { metadata: {} })
  response = client.runs.cancel(id: "run_1", thread_id: "thread_1")
  response = client.runs.create_thread_and_run(parameters: { assistant_id: "asst_1" })
  response = client.runs.submit_tool_outputs(thread_id: "thread_1", run_id: "run_1", parameters: { tool_outputs: [] })

  response = client.run_steps.list(thread_id: "thread_1", run_id: "run_1")
  response = client.run_steps.list(thread_id: "thread_1", run_id: "run_1", parameters: { limit: 5 })
  response = client.run_steps.retrieve(thread_id: "thread_1", run_id: "run_1", id: "step_1")
  response = client.run_steps.retrieve(thread_id: "thread_1", run_id: "run_1", id: "step_1", parameters: {})

  response = client.vector_stores.list
  response = client.vector_stores.list(parameters: { limit: 1 })
  response = client.vector_stores.retrieve(id: "vs_1")
  response = client.vector_stores.create(parameters: { name: "Docs" })
  response = client.vector_stores.modify(id: "vs_1", parameters: { name: "New" })
  response = client.vector_stores.delete(id: "vs_1")
  response = client.vector_stores.search(id: "vs_1", parameters: { query: "text", max_num_results: 3 })
  response = client.vector_stores.search(id: "vs_1")

  response = client.vector_store_files.list(vector_store_id: "vs_1")
  response = client.vector_store_files.list(vector_store_id: "vs_1", parameters: { limit: 5 })
  response = client.vector_store_files.retrieve(vector_store_id: "vs_1", id: "file-1")
  response = client.vector_store_files.create(vector_store_id: "vs_1", parameters: { file_id: "file-1" })
  response = client.vector_store_files.delete(vector_store_id: "vs_1", id: "file-1")

  response = client.vector_store_file_batches.list(vector_store_id: "vs_1", id: "vsfb_1")
  response = client.vector_store_file_batches.list(vector_store_id: "vs_1", id: "vsfb_1", parameters: { limit: 5 })
  response = client.vector_store_file_batches.retrieve(vector_store_id: "vs_1", id: "vsfb_1")
  response = client.vector_store_file_batches.create(vector_store_id: "vs_1", parameters: { file_ids: ["file-1"] })
  response = client.vector_store_file_batches.cancel(vector_store_id: "vs_1", id: "vsfb_1")

  response = client.batches.list
  response = client.batches.list(parameters: { limit: 5 })
  response = client.batches.retrieve(id: "batch_1")
  response = client.batches.create(parameters: { input_file_id: "file-1", endpoint: "/v1/chat/completions" })
  response = client.batches.cancel(id: "batch_1")

  response = client.realtime.create(parameters: { model: "gpt-4o-realtime-preview" })
  response = client.realtime.create

  response = client.usage.completions(parameters: { start_time: 1 })
  response = client.usage.completions
  response = client.usage.embeddings(parameters: { start_time: 1 })
  response = client.usage.moderations(parameters: { start_time: 1 })
  response = client.usage.images(parameters: { start_time: 1 })
  response = client.usage.audio_speeches(parameters: { start_time: 1 })
  response = client.usage.audio_transcriptions(parameters: { start_time: 1 })
  response = client.usage.vector_stores(parameters: { start_time: 1 })
  response = client.usage.code_interpreter_sessions(parameters: { start_time: 1 })
  response = client.usage.costs(parameters: { start_time: 1 })

  response = client.conversations.retrieve(id: "conv_1")
  response = client.conversations.create
  response = client.conversations.create(parameters: { metadata: {} })
  response = client.conversations.modify(id: "conv_1", parameters: { metadata: {} })
  response = client.conversations.delete(id: "conv_1")
  response = client.conversations.create_items(conversation_id: "conv_1", parameters: { items: [] })
  response = client.conversations.list_items(conversation_id: "conv_1")
  response = client.conversations.list_items(conversation_id: "conv_1", parameters: { limit: 5 })
  response = client.conversations.get_item(conversation_id: "conv_1", item_id: "item_1")
  response = client.conversations.delete_item(conversation_id: "conv_1", item_id: "item_1")


  begin
    client.chat
  rescue OpenAI::AuthenticationError => e
    e.message.upcase
  rescue OpenAI::ConfigurationError => e
    e.message.upcase
  rescue OpenAI::Error => e
    e.message.upcase
  end
end
