require "mysql2-cs-bind"

as = :array
Mysql2::Client.new(as: as).xquery("SELECT * FROM users WHERE id = ?", 1).each do |row|
  if row.is_a?(Array)
    row[0] # Array
  elsif row.is_a?(Hash)
    row[:id] # Hash
  end
end

Mysql2::Client.new.xquery("SELECT * FROM users WHERE id = ?", 1).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new.xquery("SELECT * FROM users WHERE id = ?", 1, as: :hash).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new.xquery("SELECT * FROM users WHERE id = ?", 1, as: :array).each do |row|
  row[0] # Array
end

Mysql2::Client.new(as: :hash).xquery("SELECT * FROM users WHERE id = ?", 1).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new(as: :hash).xquery("SELECT * FROM users WHERE id = ?", 1, as: :hash).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new(as: :hash).xquery("SELECT * FROM users WHERE id = ?", 1, as: :array).each do |row|
  row[0] # Array
end

Mysql2::Client.new(as: :array).xquery("SELECT * FROM users WHERE id = ?", 1).each do |row|
  row[0] # Array
end

Mysql2::Client.new(as: :array).xquery("SELECT * FROM users WHERE id = ?", 1, as: :hash).each do |row|
  row[:id] # Hash
end

Mysql2::Client.new(as: :array).xquery("SELECT * FROM users WHERE id = ?", 1, as: :array).each do |row|
  row[0] # Array
end
