require "domain_name"

# @type var host: DomainName
host = DomainName.new("www.example.co.uk")
host = DomainName("www.example.co.uk")

# @type var str: String
str = host.hostname
str = host.uri_host
str = host.to_s
str = host.to_str
str = host.hostname_idn
str = host.idn
str = host.inspect

# @type var maybe_str: String?
maybe_str = host.domain
maybe_str = host.tld
maybe_str = host.domain_idn
maybe_str = host.tld_idn

# @type var ipaddr: IPAddr?
ipaddr = host.ipaddr

# @type var bool: bool
bool = host.ipaddr?
bool = host.cookie_domain?("example.co.uk")
bool = host.cookie_domain?(DomainName("example.co.uk"))
bool = host.cookie_domain?("www.example.co.uk", true)
bool = host == "www.example.co.uk"
bool = host == nil

# @type var maybe_bool: bool?
maybe_bool = host.canonical?
maybe_bool = host.canonical_tld?
maybe_bool = host < "example.co.uk"
maybe_bool = host > "example.co.uk"
maybe_bool = host <= "example.co.uk"
maybe_bool = host >= "example.co.uk"

# @type var order: Integer?
order = host <=> "example.co.uk"

# @type var superdomain: DomainName?
superdomain = host.superdomain

str = DomainName.normalize("Example.COM.")

# @type var etld: Hash[String, Integer]
etld = DomainName.etld_data
etld = DomainName::ETLD_DATA
str = DomainName::VERSION
str = DomainName::ETLD_DATA_DATE

str = DomainName::Punycode.encode("bücher")
str = DomainName::Punycode.decode("bcher-kva")
str = DomainName::Punycode.encode_hostname("bücher.example")
str = DomainName::Punycode.decode_hostname("xn--bcher-kva.example")

begin
  DomainName::Punycode.decode("!")
rescue DomainName::Punycode::ArgumentError => e
  str = e.message
end
DomainName::Punycode::BufferOverflowError.new.is_a?(ArgumentError)
