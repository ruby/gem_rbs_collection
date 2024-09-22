Mysql2::Client.new(
  host: '127.0.0.1',
  port: 3306,
  username: 'user',
  password: 'password',
  database: 'database',
  database_timezone: :local,
  cast_booleans: true,
  symbolize_keys: true,
  reconnect: true,
  flags: Mysql2::Client::MULTI_STATEMENTS,
)
