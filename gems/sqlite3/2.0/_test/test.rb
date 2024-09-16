# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "sqlite3"

SQLite3::Database.new("test.db").execute("SELECT * FROM users").each do |row|
  row[0] # Array
end
SQLite3::Database.new("test.db").execute("SELECT * FROM users") do |row|
  row[0] # Array
end

SQLite3::Database.new("test.db", results_as_hash: true).execute("SELECT * FROM users").each do |row|
  row['id'] # Hash
end

SQLite3::Database.new("test.db", results_as_hash: false).execute("SELECT * FROM users").each do |row|
  row[0] # Array
end

SQLite3::Database.new("test.db") do |db|
  db.busy_timeout = 5000
end

db = SQLite3::Database.new("test.db")
db.execute("INSERT INTO users (name) VALUES ('john')")
db.changes + 1
