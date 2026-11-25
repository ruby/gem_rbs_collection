require "netrc"

Netrc::VERSION.upcase
Netrc.default_path.upcase
Netrc.home_path.upcase
Netrc.netrc_filename.upcase
Netrc.config[:allow_permissive_netrc_file] = true
Netrc.configure { |config| config[:allow_permissive_netrc_file] = true }.size

path = "example.netrc"
File.write(path, "machine example.com login user password secret\n")
File.chmod(0o600, path)
Netrc.check_permissions(path)

netrc = Netrc.read(path)
if (entry = netrc["example.com"])
  login, password = entry
  login&.upcase
  password&.upcase
  entry.login&.upcase
  entry.password = "new"
end
netrc["other.example.com"] = ["user2", "secret2"]
netrc["other.example.com"] = Netrc::Entry.new("user3", "secret3")
netrc.new_item_prefix = "# added\n"
netrc.new_item_prefix.upcase
netrc.length + 1
netrc.each { |item| item.size }
netrc.each.to_a.size
netrc.delete("other.example.com")&.size
netrc.unparse.upcase
netrc.save

Netrc.new(path, ["", []]).length

begin
  Netrc.read("/nonexistent/.netrc")
rescue Netrc::Error => e
  e.message
end
