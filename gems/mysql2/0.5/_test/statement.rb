client = Mysql2::Client.new

statement = client.prepare("INSERT INTO users (name) VALUES (?)")
statement.execute('John')
