require "mysql2"

begin
  Mysql2::Client.new.query("INSERT INTO users (name) VALUES ('john')")
rescue Mysql2::Error => e
  puts e.error_number
end
