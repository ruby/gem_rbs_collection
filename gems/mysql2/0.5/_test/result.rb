client = Mysql2::Client.new
result = client.query("SELECT * FROM users WHERE age > 10")
result.size
result.to_a
