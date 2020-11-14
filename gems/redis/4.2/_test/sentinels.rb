redis = Redis.new(
  url: "redis://mymaster",
  sentinels: [{ host: "127.0.0.1", port: 26380 }, { host: "127.0.0.1", port: 26381, password: "mysecret" }],
  role: :master
)
