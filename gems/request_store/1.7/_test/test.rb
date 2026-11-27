require "request_store"

RequestStore.store[:a] = 1
RequestStore.store
RequestStore.store[:a]
RequestStore.fetch(:block_test) do
  "some stored strings"
end

# @type var store: Hash[untyped, untyped]
store = RequestStore.store
# @type var assigned: Hash[untyped, untyped]
assigned = RequestStore.store = { user_id: 1 }
# @type var cleared: Hash[untyped, untyped]
cleared = RequestStore.clear!

# @type var began: bool
began = RequestStore.begin!
# @type var active: bool
active = RequestStore.active?
# @type var ended: bool
ended = RequestStore.end!

# @type var written: Integer
written = RequestStore.write(:user_id, 1)
# @type var assigned_value: String
assigned_value = RequestStore[:name] = "alice"
RequestStore.read(:user_id)
RequestStore[:name]
# @type var exists: bool
exists = RequestStore.exist?(:user_id)
RequestStore.fetch(:counter) { 0 }
RequestStore.delete(:user_id)
RequestStore.delete(:missing) { |key| "#{key} not found" }

class HelloApp
  def call(_env)
    [200, { "content-type" => "text/plain" }, ["ok"]]
  end
end

middleware = RequestStore::Middleware.new(HelloApp.new)
# @type var response: Rack::response
response = middleware.call({ "REQUEST_METHOD" => "GET" })
middleware #: Rack::_Application
