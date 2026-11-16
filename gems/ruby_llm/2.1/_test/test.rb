require "ruby_llm"
require "logger"

RubyLLM.configure do |config|
  config.openai_api_key = ENV.fetch("OPENAI_API_KEY", "key")
  config.gpustack_api_key = ENV["GPUSTACK_API_KEY"]
  config.openai_api_base = "https://api.example.com/v1"
  config.openai_organization_id = "org"
  config.openai_project_id = "proj"
  config.openai_use_system_role = true
  config.openai_protocol = :chat_completions
  config.openrouter_api_key = "key"
  config.openrouter_api_base = "https://openrouter.example.com"
  config.openrouter_app_name = "App"
  config.openrouter_app_url = "https://app.example.com"
  config.anthropic_api_key = "key"
  config.anthropic_api_base = "https://anthropic.example.com"
  config.gemini_api_key = "key"
  config.gemini_api_base = "https://gemini.example.com"
  config.deepseek_api_key = "key"
  config.deepseek_api_base = "https://deepseek.example.com"
  config.mistral_api_key = "key"
  config.mistral_api_base = "https://mistral.example.com"
  config.perplexity_api_key = "key"
  config.perplexity_api_base = "https://perplexity.example.com"
  config.xai_api_key = "key"
  config.xai_api_base = "https://xai.example.com"
  config.cohere_api_key = "key"
  config.cohere_api_base = "https://cohere.example.com"
  config.deepgram_api_key = "key"
  config.deepgram_api_base = "https://deepgram.example.com"
  config.elevenlabs_api_key = "key"
  config.elevenlabs_api_base = "https://elevenlabs.example.com"
  config.hetzner_api_key = "key"
  config.hetzner_api_base = "https://hetzner.example.com"
  config.typesafe_api_key = "key"
  config.typesafe_api_base = "https://typesafe.example.com"
  config.ollama_api_key = "key"
  config.ollama_api_base = "http://localhost:11434/v1"
  config.ollama_cloud_api_key = "key"
  config.ollama_cloud_api_base = "https://ollama.example.com"
  config.gpustack_api_base = "http://localhost:8080/v1"
  config.azure_api_key = "key"
  config.azure_api_base = "https://azure.example.com"
  config.azure_ai_auth_token = "token"
  config.azure_deployments = { "my-deployment" => "gpt-5.6" }
  config.bedrock_api_key = "key"
  config.bedrock_secret_key = "secret"
  config.bedrock_region = "us-east-1"
  config.bedrock_session_token = "token"
  config.bedrock_api_base = "https://bedrock.example.com"
  config.vertexai_project_id = "project"
  config.vertexai_location = "us-central1"
  config.vertexai_service_account_key = "key"
  config.vertexai_api_base = "https://vertexai.example.com"

  config.default_model = "gpt-5.6"
  config.default_embedding_model = "text-embedding-3-small"
  config.default_moderation_model = "omni-moderation-latest"
  config.default_image_model = "gpt-image-2"
  config.default_speech_model = "gpt-4o-mini-tts-2025-12-15"
  config.default_transcription_model = "gpt-transcribe"
  config.default_video_model = "grok-imagine-video-1.5"
  config.video_generation_timeout = 600
  config.video_generation_poll_interval = 5
  config.model_registry_file = "models/registry.json"
  config.model_registry_store = nil
  config.mcp_credential_store = nil
  config.mcp_client_name = "App"
  config.mcp_client_id = "client"
  config.use_new_acts_as = true

  config.request_timeout = 120
  config.max_retries = 2
  config.retry_interval = 0.1
  config.retry_backoff_factor = 2
  config.retry_interval_randomness = 0.5
  config.retry_max_interval = 30
  config.http_proxy = "http://proxy.example.com:3128"
  config.tool_concurrency = :threads
  config.auto_upload_large_files = false
  config.faraday_adapter = :net_http
  config.logger = Logger.new($stdout)
  config.deprecation_behavior = :warn
  config.log_file = $stdout
  config.log_level = Logger::INFO
  config.log_stream_debug = false
  config.log_regexp_timeout = 1.0

  # @type var timeout: Numeric?
  timeout = config.request_timeout
  # @type var base: String?
  base = config.openai_api_base
  # @type var protocol: Symbol?
  protocol = config.openai_protocol
  # @type var registry_file: String?
  registry_file = config.model_registry_file
  # @type var logger: RubyLLM::Configuration::_Logger?
  logger = config.logger
  # @type var concurrency: (bool | Symbol)?
  concurrency = config.tool_concurrency
  # @type var deployments: Hash[String, String]?
  deployments = config.azure_deployments
end

RubyLLM::Configuration.options.map(&:to_s)

class WeatherTool < RubyLLM::Tool
  description "Gets current weather for a location"
  parameter :latitude, description: "Latitude (e.g., 52.5200)"
  parameter :longitude, type: :string, description: "Longitude", required: false
  provider_options({ strict: true })
  requires_approval { |tool_call| tool_call.name == "weather" }
  defer

  def execute(latitude:, longitude: nil)
    { latitude: latitude, longitude: longitude }
  end
end

class ProbeTool < RubyLLM::Tool
  description "Records the result of a health check"
  parameters({ type: "object", properties: { status: { type: "string" } }, required: ["status"] })

  def name = "probe"
  def execute(status:) = status
end

# @type var tool_name: String
tool_name = WeatherTool.tool_name
# @type var tool_description: String?
tool_description = WeatherTool.description
# @type var class_options: Hash[Symbol, untyped]
class_options = WeatherTool.provider_options

weather = WeatherTool.new
# @type var instance_name: String
instance_name = weather.name
# @type var instance_description: String?
instance_description = weather.description
# @type var approval: bool
approval = weather.requires_approval?
# @type var tool_provider_options: Hash[Symbol, untyped]
tool_provider_options = weather.provider_options
# @type var schema: Hash[Symbol | String, untyped]?
schema = weather.parameters_schema
weather.call(latitude: "52.5")
weather.execute(latitude: "52.5")
weather.progress("fetching", value: 1, total: 2)

RubyLLM::Message.new(role: :user, content: "Hello")

context = RubyLLM.context do |config|
  config.openai_api_key = "key"
  config.request_timeout = 60
end
# @type var context_config: RubyLLM::Configuration
context_config = context.config
# @type var configured: bool
configured = RubyLLM::Providers::OpenAI.configured?(context_config)
# @type var provider_slug: String
provider_slug = RubyLLM::Providers::Anthropic.slug
# @type var provider_name: String
provider_name = RubyLLM::Providers::OpenRouter.display_name
RubyLLM.providers.map(&:slug)

chat = RubyLLM.chat
chat = RubyLLM.chat(model: "claude-sonnet-5", provider: :anthropic)
chat = RubyLLM.chat(model: "gpt-5.6", protocol: :responses, assume_model_exists: true, provider: "openai", context: context)
chat = context.chat(model: "gpt-5.6", provider: :openai, protocol: :chat_completions, assume_model_exists: true)
chat = RubyLLM::Chat.new(model: "gpt-5.6")

chat
  .with_instructions("You are a helpful assistant")
  .with_instructions("Be brief", append: true, cache_until_here: true)
  .with_tools(WeatherTool, ProbeTool.new)
  .with_tools(weather, defer: true)
  .with_tool_options(choice: :auto, calls: :one, concurrency: false)
  .with_model("gpt-5.6", provider: :openai, protocol: :chat_completions, assume_model_exists: true)
  .with_temperature(0.2)
  .with_max_output_tokens(1000)
  .with_thinking(effort: :low, budget: 1024, display: :summary)
  .with_thinking(false)
  .with_thinking({ effort: :medium })
  .with_provider_options({ service_tier: "flex" })
  .with_headers({ "X-Request-Id" => "abc" })
  .with_schema({ type: "object", properties: { name: { type: "string" } } })

class ReviewSchema
  def to_json_schema = { type: "object" }
end

chat.with_schema(ReviewSchema)
chat.with_schema(ReviewSchema.new)

chat.before_message { puts "request" }
chat.after_message { |message| puts message.content.to_s }
chat.before_tool_call { |tool_call| puts tool_call.name }
chat.after_tool_result { |result| puts result }

# This method sends requests to the provider, so it is only defined here.
def talk_to_model(chat)
  # @type var response: RubyLLM::Message?
  response = chat.ask("What is the capital of France?")
  response = chat.say("And Germany?")
  response = chat.ask("Summarize this report", with: ["report.pdf", "chart.png"])
  chat.ask("Describe this") { |chunk| print chunk.content }
  chat.ask_later("Queued question", with: "report.pdf")
  chat.add_message(role: :user, content: "Respond with valid JSON.")
  chat.add_message(RubyLLM::Message.new(role: :assistant, content: "Hello"))
  response = chat.generate
  response = chat.generate { |chunk| print chunk.content }

  until chat.complete?
    # @type var step_message: RubyLLM::Message?
    step_message = chat.step
    chat.run_tools
    break if chat.waiting? || chat.cancelled?
  end
  response = chat.complete
  chat.complete { |chunk| print chunk.content }
  # @type var cancelled_chat: RubyLLM::Chat
  cancelled_chat = chat.cancel
end

def read_message(response)
  # @type var content: String?
  content = response.content
  # @type var role: Symbol
  role = response.role
  # @type var message_model: String?
  message_model = response.model
  # @type var finish_reason: Symbol?
  finish_reason = response.finish_reason
  # @type var raw_content: String
  raw_content = response.content.to_s.strip
  # @type var parsed: untyped
  parsed = response.parsed
  # @type var calls: Hash[String, RubyLLM::ToolCall]?
  calls = response.tool_calls
  # @type var tool_call_id: String?
  tool_call_id = response.tool_call_id
  # @type var attachments: Array[RubyLLM::Attachment]
  attachments = response.attachments
  # @type var thinking: RubyLLM::Thinking?
  thinking = response.thinking
  # @type var message_raw: untyped
  message_raw = response.raw
  # @type var results: Array[RubyLLM::Message]
  results = response.tool_results
  # @type var model_info: RubyLLM::Model?
  model_info = response.model_info
  # @type var message_hash: Hash[Symbol, untyped]
  message_hash = response.to_h
  response.tool_call?
  response.tool_result?
  response.stopped?
  response.max_tokens?
  response.tool_call_stop?
  response.content_filtered?
  RubyLLM::Message::ROLES.include?(response.role)

  # @type var message_tokens: RubyLLM::Tokens
  message_tokens = response.tokens
  # @type var input_tokens: Integer?
  input_tokens = message_tokens.input
  # @type var output_tokens: Integer?
  output_tokens = message_tokens.output
  # @type var cache_read: Integer?
  cache_read = message_tokens.cache_read
  # @type var cache_write: Integer?
  cache_write = message_tokens.cache_write
  # @type var thinking_tokens: Integer?
  thinking_tokens = message_tokens.thinking
  # @type var cache_write_by_ttl: Hash[String, Integer]?
  cache_write_by_ttl = message_tokens.cache_write_by_ttl
  # @type var server_tool_use: Hash[String, Integer]?
  server_tool_use = message_tokens.server_tool_use
  # @type var reported_cost: Numeric?
  reported_cost = message_tokens.reported_cost
  # @type var tokens_hash: Hash[Symbol, untyped]
  tokens_hash = message_tokens.to_h
  RubyLLM::Tokens.new(input: 100, output: 20, cache_read: 1, cache_write: 2, thinking: 3, cache_write_by_ttl: { "5m" => 1 }, server_tool_use: { "web_search_requests" => 1 }, reported_cost: 0.01)

  # @type var message_cost: RubyLLM::Cost
  message_cost = response.cost
  message_cost = response.cost(model: "gpt-5.6")
  message_cost = response.cost(model: model_info)
  # @type var total_cost: Numeric?
  total_cost = message_cost.total
  # @type var input_cost: Numeric?
  input_cost = message_cost.input
  # @type var output_cost: Numeric?
  output_cost = message_cost.output
  # @type var cache_read_cost: Numeric?
  cache_read_cost = message_cost.cache_read
  # @type var cache_write_cost: Numeric?
  cache_write_cost = message_cost.cache_write
  # @type var thinking_cost: Numeric?
  thinking_cost = message_cost.thinking
  # @type var cost_hash: Hash[Symbol, Numeric]
  cost_hash = message_cost.to_h
end

# @type var chat_model: RubyLLM::Model
chat_model = chat.model
# @type var chat_provider: RubyLLM::Provider
chat_provider = chat.provider
# @type var chat_messages: Array[RubyLLM::Message]
chat_messages = chat.messages
chat.messages = [RubyLLM::Message.new(role: :user, content: "Hi"), { role: :assistant, content: "Hello" }]
# @type var chat_provider_options: Hash[Symbol, untyped]
chat_provider_options = chat.provider_options
# @type var chat_headers: Hash[String | Symbol, String]
chat_headers = chat.headers
# @type var chat_temperature: Numeric?
chat_temperature = chat.temperature
# @type var chat_max_output_tokens: Integer?
chat_max_output_tokens = chat.max_output_tokens
# @type var chat_schema: Hash[Symbol | String, untyped]?
chat_schema = chat.schema
# @type var chat_concurrency: Symbol?
chat_concurrency = chat.concurrency
# @type var chat_context: RubyLLM::Context?
chat_context = chat.context
# @type var chat_tools: Hash[Symbol, RubyLLM::Tool]
chat_tools = chat.tools
# @type var chat_thinking: Hash[Symbol, untyped]?
chat_thinking = chat.thinking
# @type var effort: untyped
effort = chat.thinking&.dig(:effort)
chat.tool_options
# @type var chat_tokens: RubyLLM::Tokens
chat_tokens = chat.tokens
# @type var chat_cost: RubyLLM::Cost
chat_cost = chat.cost
# @type var roles: Array[Symbol]
roles = chat.map(&:role)
chat.each { |message| message.role }
chat.each.to_a

chat.after_message do |message|
  # @type var message_calls: Hash[String, RubyLLM::ToolCall]?
  message_calls = message.tool_calls
  message_calls&.each_value do |call|
    # @type var call_id: String
    call_id = call.id
    # @type var call_name: String
    call_name = call.name
    # @type var call_arguments: Hash[String | Symbol, untyped]
    call_arguments = call.arguments
    # @type var call_hash: Hash[Symbol, untyped]
    call_hash = call.to_h
    call.remote?
    call.thought_signature = call.thought_signature
  end
end

# This method reads the attachment file, so it is only defined here.
def inspect_attachment
  attachment = RubyLLM::Attachment.new("report.pdf", filename: "report.pdf", resolution: :high)
  # @type var attachment_filename: String
  attachment_filename = attachment.filename
  # @type var attachment_mime_type: String
  attachment_mime_type = attachment.mime_type
  # @type var attachment_type: Symbol
  attachment_type = attachment.type
  # @type var attachment_content: String
  attachment_content = attachment.content
  # @type var attachment_resolution: Symbol?
  attachment_resolution = attachment.resolution
  attachment.source
  attachment.image?
  attachment.video?
  attachment.audio?
  attachment.pdf?
  attachment.text?
  attachment.document?
end

# This method sends requests to the provider, so it is only defined here.
def count_chat_tokens(chat)
  # @type var token_count: Integer
  token_count = chat.count_tokens("What is the capital of France?")
  token_count = chat.count_tokens
end

def read_thinking(thinking)
  # @type var thinking_text: String?
  thinking_text = thinking&.text
  # @type var thinking_signature: String?
  thinking_signature = thinking&.signature
end


# This method sends requests to the provider, so it is only defined here.
def embed_text(context, weather)
  # @type var embedding: RubyLLM::Embedding
  embedding = RubyLLM.embed("Ruby is a programmer's best friend")
  embedding = RubyLLM.embed(["Ruby", "Rails"], model: "text-embedding-3-small", provider: :openai, assume_model_exists: true, dimensions: 256, task_type: :retrieval_query, title: "Docs", provider_options: {}, metadata: { id: 1 }, owner: weather)
  embedding = context.embed("Ruby", model: "text-embedding-3-small")
  embedding = RubyLLM::Embedding.embed("Ruby", context: context)
  # @type var vectors: Array[Float] | Array[Array[Float]]
  vectors = embedding.vectors
  # @type var embedding_model: String
  embedding_model = embedding.model
  # @type var embedding_tokens: RubyLLM::Tokens
  embedding_tokens = embedding.tokens
  # @type var embedding_cost: RubyLLM::Cost
  embedding_cost = embedding.cost
end

# This method sends requests to the provider, so it is only defined here.
def moderate_text(context, weather)
  # @type var moderation: RubyLLM::Moderation
  moderation = RubyLLM.moderate("Some user input text")
  moderation = RubyLLM.moderate("input", model: "omni-moderation-latest", provider: :openai, assume_model_exists: true, provider_options: {}, metadata: nil, owner: weather)
  moderation = RubyLLM.moderate(with: "photo.png")
  moderation = context.moderate("input")
  moderation = RubyLLM::Moderation.moderate("input", context: context)
  # @type var flagged: bool
  flagged = moderation.flagged?
  # @type var flagged_categories: Array[String]
  flagged_categories = moderation.flagged_categories
  # @type var category_scores: Hash[String, Float]
  category_scores = moderation.category_scores
  # @type var moderation_id: String
  moderation_id = moderation.id
  # @type var moderation_model: String?
  moderation_model = moderation.model
  moderation.raw
  moderation.tokens.input
  moderation.cost.total
  moderation.results.each do |result|
    # @type var result_categories: Array[String]
    result_categories = result.categories
    # @type var result_scores: Hash[String, Float]
    result_scores = result.category_scores
    result.flagged?
  end
end

# This method sends requests to the provider, so it is only defined here.
def paint_image(context, weather)
  # @type var image: RubyLLM::Image
  image = RubyLLM.paint("A red panda coding Ruby, watercolor")
  image = RubyLLM.paint("A sunset", model: "gpt-image-2", provider: :openai, assume_model_exists: true, size: "1024x1024", with: "source.png", mask: "mask.png", provider_options: {}, metadata: nil, owner: weather)
  image = context.paint("A sunset", count: nil)
  image = RubyLLM::Image.paint("A sunset", context: context)
  # @type var images: RubyLLM::Image | Array[RubyLLM::Image]
  images = RubyLLM.paint("A sunset", count: 2)
  images = context.paint("A sunset", count: 2)
  images = RubyLLM::Image.paint("A sunset", count: 2)
  # @type var saved_path: String
  saved_path = image.save("panda.png")
  # @type var image_blob: String
  image_blob = image.to_blob
  # @type var image_url: String?
  image_url = image.url
  # @type var image_data: String?
  image_data = image.data
  # @type var image_mime_type: String?
  image_mime_type = image.mime_type
  # @type var revised_prompt: String?
  revised_prompt = image.revised_prompt
  # @type var image_model: String?
  image_model = image.model
  image.base64?
  image.tokens.output
  image.cost.total
end

# This method sends requests to the provider, so it is only defined here.
def transcribe_audio(context, weather)
  # @type var transcription: RubyLLM::Transcription
  transcription = RubyLLM.transcribe("meeting.wav")
  transcription = RubyLLM.transcribe(Pathname.new("meeting.wav"), model: "gpt-4o-transcribe", language: "en", provider: :openai, assume_model_exists: true, prompt: "Ruby", temperature: 0.0, format: :json, timestamps: :word, speaker_names: ["Alice"], speaker_references: ["alice.wav"], provider_options: {}, metadata: nil, owner: weather)
  transcription = context.transcribe("meeting.wav") { |chunk| print chunk.delta }
  transcription = RubyLLM::Transcription.transcribe("meeting.wav", context: context) { |chunk| print chunk.text }
  # @type var transcript: String
  transcript = transcription.text
  # @type var transcription_model: String?
  transcription_model = transcription.model
  # @type var language: String?
  language = transcription.language
  # @type var duration: Numeric?
  duration = transcription.duration
  # @type var segments: Array[Hash[Symbol | String, untyped]]?
  segments = transcription.segments
  # @type var words: Array[Hash[Symbol | String, untyped]]?
  words = transcription.words
  transcription.tokens.input
  transcription.cost.total

  RubyLLM.transcribe("meeting.wav", model: "gpt-4o-transcribe") do |chunk|
    # @type var chunk_type: String
    chunk_type = chunk.type
    # @type var chunk_delta: String?
    chunk_delta = chunk.delta
    # @type var chunk_text: String?
    chunk_text = chunk.text
    # @type var chunk_segment: Hash[Symbol | String, untyped]?
    chunk_segment = chunk.segment
    chunk.raw
    chunk.delta?
    chunk.partial?
    chunk.segment?
    chunk.done?
  end
end

# @type var models: RubyLLM::Models
models = RubyLLM.models
# @type var found: RubyLLM::Model
found = models.find("claude-haiku-4-5")
found = models.find("claude-sonnet-5", provider: :bedrock, config: context_config)
# @type var all_models: Array[RubyLLM::Model]
all_models = models.all
models.listed
models.unlisted
models.chat_models.map(&:id)
models.embedding_models
models.audio_models
models.image_models
models.by_family("gpt")
models.by_provider(:openai).select { |model| model.created_at && model.created_at >= Time.now }
models.by_provider("anthropic").to_h { |model| [model.name, { id: model.id }] }
models.each { |model| model.label }
# This method sends requests to the provider, so it is only defined here.
def refresh_models(models)
  models.refresh
  models.refresh(remote_only: true)
  models.load_from_json
  models.load_from_json("config/llm_models.json")
  models.save_to_json
  models.save_to_json("config/llm_models.json")
end

# @type var model_id: String
model_id = found.id
# @type var model_name: String
model_name = found.name
# @type var model_provider: String
model_provider = found.provider
# @type var family: String?
family = found.family
# @type var created_at: Time?
created_at = found.created_at
# @type var context_window: Integer?
context_window = found.context_window
# @type var max_output: Integer?
max_output = found.max_output_tokens
# @type var capabilities: Array[String]
capabilities = found.capabilities
# @type var metadata: Hash[Symbol, untyped]
metadata = found.metadata
# @type var unlisted_at: Time?
unlisted_at = found.unlisted_at
# @type var input_modalities: Array[String]
input_modalities = found.modalities.input
# @type var output_modalities: Array[String]
output_modalities = found.modalities.output
# @type var modalities_hash: Hash[Symbol, Array[String]]
modalities_hash = found.modalities.to_h
# @type var model_label: String
model_label = found.label
# @type var model_type: Symbol
model_type = found.type
# @type var effort_values: Array[untyped]
effort_values = found.reasoning_option_values(:effort)
found.supports?(:function_calling)
found.unlisted?
RubyLLM.workflow("Write article", id: "article-42", metadata: { topic: "ruby" }) do |workflow|
  # @type var workflow_id: String
  workflow_id = workflow.id
  # @type var workflow_name: String
  workflow_name = workflow.name
  # @type var notes: String
  notes = workflow.step("Research") { "notes" }
  workflow.step("Draft", id: "draft-1") { notes.upcase }
end
# @type var workflow_result: Integer
workflow_result = RubyLLM.workflow("count") { |_workflow| 1 }
context.workflow("Write article") { |workflow| workflow.name }

# @type var owner_result: Integer
owner_result = RubyLLM.with_usage_owner(weather) { 1 }

# This method sends requests to the provider, so it is only defined here.
def count_remote_tokens(context)
  # @type var token_total: Integer
  token_total = RubyLLM.count_tokens("What is the capital of France?", model: "claude-haiku-4-5", provider: :anthropic)
  token_total = context.count_tokens("Hello")
end

# This method needs the opentelemetry-api gem, so it is only defined here.
def toggle_open_telemetry
  RubyLLM::OpenTelemetry.enable
  RubyLLM::OpenTelemetry.disable
end

# This method sends requests to the provider, so it is only defined here.
def use_mcp(context, weather)
  mcp = RubyLLM.mcp(url: "https://mcp.example.com/mcp")
  mcp = RubyLLM.mcp(command: ["ruby", "mcp_server.rb"])
  mcp = context.mcp(url: "https://mcp.example.com", name: "docs", timeout: 30, bearer_token: "token", headers: { "X-Key" => "v" }, env: { "A" => "b" }, directory: ".", prefix: "mcp_1", oauth: { owner: weather })
  mcp = RubyLLM.mcp(url: "https://mcp.example.com", oauth: true)
  # @type var mcp_name: String
  mcp_name = mcp.name
  # @type var mcp_tools: Array[RubyLLM::MCP::Tool]
  mcp_tools = mcp.tools
  # @type var mcp_result: RubyLLM::MCP::Result
  mcp_result = mcp.call(:list_issues, query: "bug")
  # @type var auth_url: String
  auth_url = mcp.authorization_url(redirect_uri: "https://app.example.com/callback")
  mcp.authorize({ "code" => "abc", "state" => "xyz" })
  mcp_tools.select { |tool| tool.visibility.include?(:model) }.map do |tool|
    # @type var server_name: String
    server_name = tool.server_name
    tool.name
    tool.description
    tool.parameters_schema
    tool.read_only?
    tool.destructive?
    tool.idempotent?
    tool.open_world?
  end
end

# This method sends requests to the provider, so it is only defined here.
def rescue_errors(chat)
  begin
    chat.ask("Hello")
  rescue RubyLLM::UnauthorizedError => e
    # @type var unauthorized_response: Faraday::Response?
    unauthorized_response = e.response
    e.message
  rescue RubyLLM::RateLimitError, RubyLLM::ServerError, RubyLLM::ServiceUnavailableError, RubyLLM::OverloadedError => e
    e.response
  rescue RubyLLM::PaymentRequiredError, RubyLLM::ForbiddenError, RubyLLM::ContextLengthExceededError, RubyLLM::BadRequestError, RubyLLM::ContentFilterError => e
    e.message
  rescue RubyLLM::UnsupportedAttachmentError, RubyLLM::UnsupportedServerToolError => e
    e.message
  rescue RubyLLM::ToolCallParseError => e
    # @type var parse_finish_reason: String?
    parse_finish_reason = e.finish_reason
  rescue RubyLLM::Error => e
    e.message
  rescue RubyLLM::ModelNotFoundError, RubyLLM::CancelledError, RubyLLM::ConfigurationError, RubyLLM::InvalidRoleError, RubyLLM::InvalidToolChoiceError => e
    e.message
  rescue RubyLLM::ModelRegistryError, RubyLLM::PendingToolCallsError, RubyLLM::PromptNotFoundError, RubyLLM::DeprecationError => e
    e.message
  end
end

RubyLLM::Error.new("failed", response: nil)
RubyLLM::CancelledError.new

RubyLLM::VERSION
RubyLLM.config.default_model
RubyLLM.config.model_registry_store = nil

class MemoryCredentialStore
  def initialize
    @data = {}
  end

  def read(key)
    @data[key]
  end

  def write(key, data, owner: nil)
    @data[key] = data
  end

  def delete(key)
    @data.delete(key)
  end
end

class LoggingInstrumenter
  def instrument(name, payload)
    puts name
    yield payload
  end
end

class JsonRegistryStore
  def read = nil
  def write(models) = models
end

RubyLLM.configure do |config|
  config.mcp_credential_store = MemoryCredentialStore.new
  config.instrumenter = LoggingInstrumenter.new
  config.model_registry_store = JsonRegistryStore.new
end