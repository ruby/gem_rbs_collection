# Write Ruby code to test the RBS.
# It is type checked by `steep check` command.

require "odbc"

# Test module methods

# Connection test
conn = ODBC.connect("test_dsn", "user", "password")

# Data sources and drivers
dsns = ODBC.datasources
drivers = ODBC.drivers

# Error handling
error = ODBC.error
info = ODBC.info
ODBC.clear_error

# Environment
env = ODBC.newenv

# Time conversion
time = ODBC.to_time(2023, 12, 25)
time_with_hms = ODBC.to_time(2023, 12, 25, 10, 30, 45)

# Connection pooling
pooling = ODBC.connection_pooling
ODBC.connection_pooling = ODBC::SQL_CP_ONE_PER_DRIVER

# GC threshold
threshold = ODBC.gc_threshold
ODBC.gc_threshold = 100

# Tracing
trace_level = ODBC.trace
ODBC.trace = 1


# Test Database class
db = ODBC::Database.new("dsn", "user", "pass")

# Connection methods
connected = db.connected?
db.drop_all

# Metadata queries
tables_stmt = db.tables
columns_stmt = db.columns("catalog", "schema", "table")
keys_stmt = db.primary_keys("catalog", "schema", "table")

# Query execution
stmt = db.prepare("SELECT * FROM users WHERE id = ?")
stmt = db.run("SELECT * FROM users")
row_count = db.do("DELETE FROM users WHERE id = 1")

# Procedure creation
proc = db.proc("SELECT * FROM users WHERE id = ?")

# Settings
db.use_time = true
db.use_utc = false
db.autocommit = true
db.timeout = 30

db.disconnect

# Test Statement class
db = ODBC::Database.new("dsn", "user", "pass")
stmt = db.prepare("SELECT * FROM users")

# Execution
stmt.execute
stmt.execute(1, "param2") { |s| puts "executed" }

# Fetching
row = stmt.fetch
row_bang = stmt.fetch!
all_rows = stmt.fetch_all
many_rows = stmt.fetch_many(10)

# Hash fetching
hash_row = stmt.fetch_hash
hash_row_with_table = stmt.fetch_hash(true)
hash_row_with_options = stmt.fetch_hash(key: :Symbol, table_names: true)

# Iteration
stmt.each { |row| puts row.inspect }
stmt.each_hash { |row| puts row.inspect }
stmt.each_hash(key: :String) { |row| puts row.inspect }

# Metadata
ncols = stmt.ncols
nrows = stmt.nrows
col = stmt.column(0)
cols = stmt.columns
params = stmt.parameters

stmt.close


# Test Column class
db = ODBC::Database.new("dsn", "user", "pass")
stmt = db.columns
stmt.execute
col = stmt.column(0)

# Column attributes
name = col.name
table = col.table
type = col.type
length = col.length
precision = col.precision
scale = col.scale
nullable = col.nullable
searchable = col.searchable
unsigned = col.unsigned
money = col.money
updatable = col.updatable
auto_increment = col.auto_increment

# Test ODBCProc
db = ODBC::Database.new("dsn", "user", "pass")
proc = db.proc("SELECT * FROM users WHERE id = ?")

# Calling the proc
result = proc.call(1)
result = proc[1]

# Test Constants
sql_type = ODBC::SQL_INTEGER
fetch_dir = ODBC::SQL_FETCH_NEXT
txn_level = ODBC::SQL_TXN_READ_COMMITTED
cursor_type = ODBC::SQL_CURSOR_FORWARD_ONLY

# Test Date/Time/TimeStamp classes
date = ODBC::Date.new(2023, 12, 25)
date_str = date.to_s
date_arr = date.to_a

time = ODBC::Time.new(10, 30, 45)
time_str = time.to_s
time_arr = time.to_a

timestamp = ODBC::TimeStamp.new(2023, 12, 25, 10, 30, 45, 0)
timestamp_str = timestamp.to_s
timestamp_arr = timestamp.to_a
