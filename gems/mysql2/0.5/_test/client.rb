client = Mysql2::Client.new

client.query("UPDATE users SET age = age + 1 WHERE name = 'John'")
if client.affected_rows == 0
  puts "No rows were updated"
else
  puts "Updated #{client.affected_rows} rows"
end
