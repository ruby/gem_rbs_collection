# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "domain_name"

host = DomainName.new("www.example.co.uk")
host.hostname.upcase
host.domain&.upcase
host.tld&.upcase
host.ipaddr&.ipv4?
host.uri_host.upcase
host.ipaddr?
host.canonical?
host.canonical_tld?
host.cookie_domain?("example.co.uk")
host.cookie_domain?(DomainName("example.co.uk"))
host.cookie_domain?("www.example.co.uk", true)
host.superdomain&.hostname
host == "www.example.co.uk"
host == nil
(host <=> "example.co.uk")&.positive?
host < "example.co.uk"
host > "example.co.uk"
host <= "example.co.uk"
host >= "example.co.uk"
host.to_s.upcase
host.to_str.upcase
host.hostname_idn.upcase
host.idn.upcase
host.domain_idn&.upcase
host.tld_idn&.upcase
host.inspect.upcase

DomainName.normalize("Example.COM.").upcase
DomainName.etld_data["com"]&.zero?
DomainName::ETLD_DATA.size
DomainName::VERSION.upcase
DomainName::ETLD_DATA_DATE.upcase

DomainName::Punycode.encode("bücher").upcase
DomainName::Punycode.decode("bcher-kva").upcase
DomainName::Punycode.encode_hostname("bücher.example").upcase
DomainName::Punycode.decode_hostname("xn--bcher-kva.example").upcase

begin
  DomainName::Punycode.decode("!")
rescue DomainName::Punycode::ArgumentError => e
  e.message.upcase
end
DomainName::Punycode::BufferOverflowError.new.is_a?(ArgumentError)
