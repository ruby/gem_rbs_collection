require "mysql2"

client = Mysql2::Client.new(
  host: '127.0.0.1',
  port: 3306,
  username: 'root',
  password: 'password',
  database: 'foo',
  symbolize_keys: true,
  cast_booleans: true,
  reconnect: true,
)

client.query("SELECT * FROM users").each do |row|
  raise unless row.is_a?(Hash)
  row[:id]
end

client.query("SELECT id FROM users", as: :array).each do |row|
  raise unless row.is_a?(Array)
  row[0]
end
