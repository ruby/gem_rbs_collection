require "request_store"

RequestStore.store[:a] = 1
RequestStore.store
RequestStore.store[:a]
RequestStore.fetch(:block_test) do
  "some stored strings"
end
