require "mysql2"

as = :array
Mysql2::Client.new(as: as).query("SELECT * FROM users").each do |row|
  if row.is_a?(Array)
    row[0] # Array
  elsif row.is_a?(Hash)
    row[:id] # Hash
  end
end

Mysql2::Client.new.query("SELECT * FROM users").each do |row|
  row[:id] # Hash
end

Mysql2::Client.new.query("SELECT * FROM users", as: :hash).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new.query("SELECT * FROM users", as: :array).each do |row|
  row[0] # Array
end

Mysql2::Client.new(as: :hash).query("SELECT * FROM users").each do |row|
  row[:id] # Hash
end

Mysql2::Client.new(as: :hash).query("SELECT * FROM users", as: :hash).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new(as: :hash).query("SELECT * FROM users", as: :array).each do |row|
  row[0] # Array
end

Mysql2::Client.new(as: :array).query("SELECT * FROM users").each do |row|
  row[0] # Array
end

Mysql2::Client.new(as: :array).query("SELECT * FROM users", as: :hash).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new(as: :array).query("SELECT * FROM users", as: :array).each do |row|
  row[0] # Array
end
