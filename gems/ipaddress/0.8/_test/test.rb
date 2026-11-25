require "ipaddress"

ip = IPAddress::IPv4.new("172.16.10.1/24")
IPAddress("172.16.10.1/24").to_s.upcase
IPAddress(167_837_953).address.upcase
IPAddress::NAME.upcase
IPAddress::AUTHORS.first&.upcase

parsed = IPAddress.parse("2001:db8::8:800:200c:417a/64")
parsed.ipv6?
IPAddress.parse(167_837_953).octets.sum
IPAddress.ntoa(167_837_953).upcase
IPAddress.valid?("10.0.0.1")
IPAddress.valid_ipv4?(nil)
IPAddress.valid_ipv4_netmask?("255.255.255.0")
IPAddress.valid_ipv6?("::1")

# IPv4
v4 = IPAddress::IPv4.new("10.1.2.3/255.255.0.0")
v4.address.upcase
v4.prefix.to_i + 1
v4.prefix = 24
v4.netmask = "255.255.255.0"
v4.netmask.upcase
v4.to_string.upcase
v4.to_i + v4.u32 + v4.to_u32
v4.hex.upcase
(v4.octet(0) || 0) + (v4[1] || 0)
v4[3] = 10
v4.bits.size
v4.broadcast.to_s
v4.network.network?
v4.first.to_s
v4.last.to_s
v4.each_host { |host| host.to_s }
v4.each { |addr| addr.to_s }
v4.map { |addr| addr.to_s }.first&.upcase
v4.hosts.size
v4.size + v4.network_u32 + v4.broadcast_u32
v4.include?(IPAddress::IPv4.new("10.1.2.5"))
v4.include_all?(IPAddress::IPv4.new("10.1.2.5"), IPAddress::IPv4.new("10.1.2.6"))
v4.private? || v4.multicast? || v4.loopback? || v4.ipv4?
v4.reverse.upcase
v4.to("10.1.2.20").size
v4.subnet(26).size
v4.supernet(16).to_s
(v4 - ip).abs
(v4 + IPAddress::IPv4.new("10.1.3.0/24")).size
v4.a? || v4.b? || v4.c?
v4.to_ipv6.upcase
(v4 <=> ip) + 1
v4 < ip
IPAddress::IPv4.parse_u32(167_837_953, 24).to_s
IPAddress::IPv4.parse_data("\xAC\x10\n\x01".b).to_s
IPAddress::IPv4.extract("foo 10.0.0.1 bar").to_s
IPAddress::IPv4.summarize(v4, ip).size
IPAddress::IPv4.parse_classful("10.0.0.1").prefix.to_i

# Prefix
prefix = IPAddress::Prefix32.new(24)
prefix.to_ip.upcase
prefix.octets.size + (prefix[0] || 0) + prefix.to_u32 + prefix.host_prefix
prefix.bits.upcase
prefix.hostmask.upcase
prefix > 16
IPAddress::Prefix32.parse_netmask("255.255.255.0").prefix + 1
p128 = IPAddress::Prefix128.new
IPAddress::Prefix128.new("64").bits.upcase
p128.to_u128 + p128.host_prefix

# IPv6
v6 = IPAddress::IPv6.new("2001:db8::8:800:200c:417a/64")
v6.address.upcase
v6.groups.sum
v6.prefix = 96
v6.to_string_uncompressed.upcase
v6.to_s.upcase
v6.to_u128 + v6.to_i
(v6.group(0) || 0) + (v6[1] || 0)
v6[2] = 0x1234
v6[3] = "10"
v6.to_hex.upcase
v6.data.bytesize
v6.hexs.first&.upcase
v6.arpa.upcase
v6.network_u128 + v6.broadcast_u128 + v6.size
v6.include?(IPAddress::IPv6.new("2001:db8::1"))
v6.unspecified? || v6.loopback? || v6.mapped? || v6.network?
v6.compressed.upcase
v6.literal.upcase
v6.network.to_s
v6.bits.size
IPAddress::IPv6.expand("2001:db8::1").upcase
IPAddress::IPv6.compress("2001:0db8:0000:0000:0000:0000:0000:0001").upcase
IPAddress::IPv6.groups("2001:db8::1").sum
IPAddress::IPv6.parse_data(v6.data).to_s
IPAddress::IPv6.parse_u128(v6.to_i, 64).to_s
IPAddress::IPv6.parse_hex(v6.to_hex, 64).to_s
IPAddress::IPv6::Unspecified.new.to_s
IPAddress::IPv6::Loopback.new.to_s
mapped = IPAddress::IPv6::Mapped.new("::ffff:172.16.10.1/128")
mapped.ipv4.address.upcase
mapped.to_string.upcase
mapped.mapped?

IPAddress.valid_ipv4_netmask?(nil)
IPAddress::IPv6.new("2001:db8::1/64").prefix = "48"
