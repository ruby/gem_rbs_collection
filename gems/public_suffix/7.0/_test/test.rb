require "public_suffix"

PublicSuffix::VERSION.upcase
PublicSuffix::DOT.upcase
PublicSuffix::BANG.upcase
PublicSuffix::STAR.upcase

# @type var name: String?
name = PublicSuffix.domain("www.google.co.uk")
name = PublicSuffix.domain("something.blogspot.com", ignore_private: true)
name = PublicSuffix.domain("example.tldnotlisted", default_rule: nil)
name = PublicSuffix.domain(:"www.example.com", list: PublicSuffix::List.default)

# @type var valid: bool
valid = PublicSuffix.valid?("google.com")
valid = PublicSuffix.valid?("example.tldnotlisted", default_rule: nil)
valid = PublicSuffix.valid?("something.blogspot.com", ignore_private: true)
valid = PublicSuffix.valid?("example.com", list: PublicSuffix::List.default, default_rule: PublicSuffix::Rule.default)

# @type var domain: PublicSuffix::Domain
domain = PublicSuffix.parse("www.google.com")
domain = PublicSuffix.parse("www.google.com.", default_rule: nil, ignore_private: true)
domain = PublicSuffix.parse("www.google.com", list: PublicSuffix::List.default, default_rule: PublicSuffix::Rule.factory("*"))

# @type var tld: String?
tld = domain.tld
# @type var sld: String?
sld = domain.sld
# @type var trd: String?
trd = domain.trd
# @type var root: String?
root = domain.domain
# @type var sub: String?
sub = domain.subdomain
domain.name.upcase
domain.to_s.upcase
domain.to_a.compact.size
domain.domain?
domain.subdomain?

begin
  PublicSuffix.parse("example.com")
rescue PublicSuffix::DomainNotAllowed => e
  e.message.upcase
rescue PublicSuffix::DomainInvalid => e
  e.message.upcase
rescue PublicSuffix::Error => e
  e.message.upcase
end

list = PublicSuffix::List.default
list.size + 1
list.empty?
PublicSuffix::List.default(private_domains: false)
PublicSuffix::List.default = list
PublicSuffix::List::DEFAULT_LIST_PATH.upcase

custom = PublicSuffix::List.parse("com\n*.uk\n!city.uk\n", private_domains: false)
custom = PublicSuffix::List.parse("com")
custom << PublicSuffix::Rule.factory("onmicrosoft.com")
custom.add(PublicSuffix::Rule.factory("blogspot.com", private: true))
custom == list
custom.eql?(list)
custom.default_rule.rule.upcase

PublicSuffix::List.new { |l| l.add(PublicSuffix::Rule.factory("com")) }

rule = PublicSuffix::Rule.factory("*.kobe.jp")
rule.value.upcase
rule.length + 1
rule.private
rule.rule.upcase
rule == PublicSuffix::Rule.default
rule.eql?(PublicSuffix::Rule.default)
PublicSuffix::Rule.factory("!city.kobe.jp", private: true).value.upcase
PublicSuffix::Rule.default.value
