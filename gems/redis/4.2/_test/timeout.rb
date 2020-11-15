Redis.new(:timeout => 1)

Redis.new(
  :connect_timeout => 0.2,
  :read_timeout    => 1.0,
  :write_timeout   => 0.5
)
