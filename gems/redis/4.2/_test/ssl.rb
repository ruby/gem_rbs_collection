redis = Redis.new(
  :url        => "rediss://:p4ssw0rd@10.0.1.1:6381/15",
  :ssl_params => {
    :ca_file => "/path/to/ca.crt"
  }
)

redis = Redis.new(
  :url        => "rediss://:p4ssw0rd@10.0.1.1:6381/15",
  :ssl_params => {
    :ca_file => "/path/to/ca.crt",
    :cert    => OpenSSL::X509::Certificate.new(File.read("client.crt")),
    :key     => OpenSSL::PKey::RSA.new(File.read("client.key"))
  }
)
