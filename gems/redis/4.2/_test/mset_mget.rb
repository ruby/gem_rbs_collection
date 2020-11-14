redis = Redis.new(cluster: %w[redis://127.0.0.1:7000])

redis.mget('key1', 'key2')
#=> Redis::CommandError (CROSSSLOT Keys in request don't hash to the same slot)

redis.mget('{key}1', '{key}2')
#=> [nil, nil]
