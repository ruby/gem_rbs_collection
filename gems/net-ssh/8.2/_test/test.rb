require "net/ssh"
require "net/ssh/proxy/command"
require "net/ssh/proxy/jump"
require "net/ssh/proxy/http"
require "net/ssh/proxy/socks5"

Net::SSH::VALID_OPTIONS.include?(:password)
# @type var version: String
version = Net::SSH::Version::STRING
version.length
Net::SSH::Version::CURRENT >= Net::SSH::Version[8, 0, 0]

Net::SSH.default_configuration = ->(host, ssh_config) { { timeout: ssh_config.fetch(:timeout, 5) } }
Net::SSH.default_configuration = nil

# @type var config: Hash[Symbol, untyped]
config = Net::SSH.configuration_for("example.com", true, user: "deploy")
config[:port]
# @type var settings: Hash[String, untyped]
settings = Net::SSH::Config.load("~/.ssh/config", "example.com")
config = Net::SSH::Config.for("example.com", ["~/.ssh/config"])
config = Net::SSH::Config.translate(settings)

# @type var output: String
output = Net::SSH.start("example.com", "deploy", password: "secret", port: 22, non_interactive: true) do |ssh|
  # @type var result: Net::SSH::Connection::Session::StringWithExitstatus
  result = ssh.exec!("hostname")
  # @type var exit_code: Integer?
  exit_code = result.exitstatus
  exit_code&.zero?

  # @type var status: Hash[Symbol, untyped]
  status = {}
  ssh.exec!("false", status: status) { |_ch, stream, data| puts "#{stream}: #{data}" }
  status[:exit_code]

  # @type var channel: Net::SSH::Connection::Channel
  channel = ssh.open_channel do |ch|
    ch.request_pty(term: "xterm", modes: { Net::SSH::Connection::Term::ECHO => 0 }) do |_ch, success|
      raise "no pty" unless success
    end
    ch.exec("ls -l") do |c, success|
      raise "could not execute" unless success

      c.on_data { |_c, data| print data }
      c.on_extended_data { |_c, _type, data| warn data }
      c.on_request("exit-status") { |_c, data| data.read_long }
      c.on_eof { |_c| puts "eof" }
      c.on_close { |_c| puts "closed" }
      c.send_data("input\n")
      c.eof!
    end
  end
  channel[:name] = "ls"
  channel.wait
  channel.active?
  # @type var remote_id: Integer?
  remote_id = channel.remote_id
  remote_id&.succ

  # @type var exec_channel: Net::SSH::Connection::Channel
  exec_channel = ssh.exec("uptime") { |_ch, _stream, data| print data }
  exec_channel.close
  ssh.loop(0.1) { |session| session.busy? }
  # @type var processed: bool
  processed = ssh.process(0)
  processed

  # @type var forward: Net::SSH::Service::Forward
  forward = ssh.forward
  # @type var local_port: Integer
  local_port = forward.local(0, "www.example.com", 80)
  local_port = forward.local("0.0.0.0", 0, "www.example.com", 80)
  forward.cancel_local(local_port)
  forward.remote(8080, "localhost", 0) { |port, _host| port == :error ? :no_exception : nil }
  forward.active_remotes.each { |port, host| "#{host}:#{port}" }

  ssh.host + ssh.exec!("whoami")
end
output.length

# @type var session: Net::SSH::Connection::Session
session = Net::SSH.start("example.com", nil, { keys: ["~/.ssh/id_ed25519"], verify_host_key: :never })
session.closed?
session.close

begin
  Net::SSH.start("example.com", "deploy", proxy: Net::SSH::Proxy::Jump.new("gateway.example.com"), timeout: 5)
rescue Net::SSH::HostKeyMismatch => e
  # @type var fingerprint: String?
  fingerprint = e.fingerprint
  fingerprint&.length
  e.remember_host!
rescue Net::SSH::AuthenticationFailed, Net::SSH::ConnectionTimeout, Net::SSH::Disconnect => e
  e.message
rescue Net::SSH::ChannelOpenFailed => e
  e.code + 1
end

Net::SSH::Proxy::Command.new("ssh gateway nc %h %p").command_line_template
Net::SSH::Proxy::HTTP.new("proxy.example.com", 3128, user: "u", password: "p").proxy_port
Net::SSH::Proxy::SOCKS5.new("proxy.example.com").proxy_host

# @type var key: Net::SSH::private_key
key = Net::SSH::KeyFactory.load_private_key("~/.ssh/id_rsa", "passphrase")
key = Net::SSH::KeyFactory.load_data_private_key(File.read("id_ed25519"), nil, false)
# @type var public_key: Net::SSH::public_key
public_key = Net::SSH::KeyFactory.load_public_key("~/.ssh/id_rsa.pub")
public_key.fingerprint("SHA256")
public_key = Net::SSH::KeyFactory.load_data_public_key("ssh-ed25519 AAAA... user@host")

# @type var host_keys: Net::SSH::HostKeys
host_keys = Net::SSH::KnownHosts.search_for("example.com", user_known_hosts_file: "known_hosts")
host_keys.each { |entry| entry.key.fingerprint if entry.is_a?(Net::SSH::HostKeyEntries::PubKey) }
host_keys.empty?
Net::SSH::KnownHosts.add("example.com", public_key)

manager = Net::SSH::Authentication::KeyManager.new(nil, use_agent: false)
manager.add("~/.ssh/id_ed25519").add_key_data("-----BEGIN OPENSSH PRIVATE KEY-----")
manager.each_identity do |identity|
  # @type var signature: String
  signature = manager.sign(identity, "data")
  signature.bytesize
end
manager.finish

begin
  # @type var agent: Net::SSH::Authentication::Agent
  agent = Net::SSH::Authentication::Agent.connect
  agent.identities.each { |identity| "#{identity.comment} #{identity.fingerprint}" }
  agent.close
rescue Net::SSH::Authentication::AgentNotAvailable
  nil
end

buffer = Net::SSH::Buffer.from(:string, "ssh-rsa", :long, 42)
buffer.write_byte(1).write_bool(true).write_string("x")
# @type var string: String?
string = buffer.read_string
string&.length
buffer.read_long&.succ
# @type var bytes: String
bytes = buffer.to_s
bytes.bytesize

prompter = Net::SSH::Prompt.default.start(type: "password")
# @type var answer: String
answer = prompter.ask("Password: ", false)
answer.length
prompter.success
