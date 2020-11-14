# @type const OpenSSL: untyped
# @type const OpenSSL::X509: untyped
# @type const OpenSSL::X509::Certificate: untyped
# @type const OpenSSL::PKey::RSA: untyped
# @type const OpenSSL::PKey: untyped

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
