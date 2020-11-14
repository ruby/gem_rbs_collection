# @type var nodes: Array[Redis::node]

nodes = (7000..7005).map { |port| "redis://127.0.0.1:#{port}" }
redis = Redis.new(cluster: nodes)

nodes = (7000..7005).map do |port|
  # @type block: Redis::node
  { host: '127.0.0.1', port: port }
end
redis = Redis.new(cluster: nodes)
