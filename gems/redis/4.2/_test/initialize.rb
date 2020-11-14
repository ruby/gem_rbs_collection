redis = Redis.new

redis = Redis.new(host: "10.0.1.1", port: 6380, db: 15)

redis = Redis.new(url: "redis://:p4ssw0rd@10.0.1.1:6380/15")

redis = Redis.new(path: "/tmp/redis.sock")

redis = Redis.new(password: "mysecret")
