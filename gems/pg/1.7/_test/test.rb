require "pg"

conn = PG::Connection.new(host: "localhost", dbname: "app", user: "postgres")
conn2 = PG.connect("postgres://localhost/app")
conn3 = PG::Connection.open({ host: "localhost", port: 5432 })
conn3.finished?

PG::Connection.new(dbname: "app") do |c|
  c.exec("SELECT 1")
end
version = PG.library_version + 1
PG.version_string.upcase
PG::VERSION.upcase
PG.isthreadsafe ? 1 : 0
PG.connect(dbname: "app") { |c| c.db&.upcase }
PG.connect("dbname=app") { |c| c.user&.upcase }

# Constants
PG::CONNECTION_OK + PG::PQTRANS_IDLE + PG::PQTRANS_ACTIVE + PG::PQTRANS_INTRANS + PG::PQTRANS_INERROR + PG::PQTRANS_UNKNOWN
PG::PGRES_COMMAND_OK + PG::PGRES_TUPLES_OK + PG::PGRES_COPY_IN + PG::PGRES_COPY_OUT + PG::PGRES_FATAL_ERROR
PG::Result::PG_DIAG_SQLSTATE + PG::Result::PG_DIAG_CONSTRAINT_NAME + PG::Result::PG_DIAG_MESSAGE_PRIMARY
PG::Result::PG_DIAG_SEVERITY + PG::Result::PG_DIAG_TABLE_NAME + PG::Result::PG_DIAG_COLUMN_NAME
PG::Connection::CONNECTION_BAD + PG::Connection::PQTRANS_INERROR

# Executing queries
result = conn.exec("SELECT id, name FROM users")
result.ntuples + result.nfields + result.num_tuples + result.num_fields
result.values.first&.first
result.fields.first
result.each do |row|
  # @type var row: Hash[String | Symbol, untyped]
  row["id"]
end
result.each_row { |row| row.first }
result.each_tuple { |tuple| tuple.keys.first }
result.map { |row| row.keys.first }
result[0].keys
result.getvalue(0, 0)
result.getisnull(0, 1) ? 1 : 0
result.column_values(0).first
result.field_values("name").first
result.tuple_values(0).first
result.tuple(0)["id"]
result.fname(0)
result.fnumber("id") + result.ftype(0)
result.cmd_status.upcase
result.cmd_tuples + (result.oid_value || 0) + result.result_status
result.res_status(result.result_status).upcase
PG::Result.res_status(PG::PGRES_TUPLES_OK).upcase
result.error_message.upcase
result.verbose_error_message(1, 1)&.upcase
result.error_field(PG::PG_DIAG_SQLSTATE)&.upcase
result.cleared? ? 1 : 0
result.autoclear? ? 1 : 0
result.check.ntuples
result.field_names_as(:symbol).fields
result.map_types!(PG::TypeMapAllStrings.new).ntuples
result.type_map = PG::TypeMapAllStrings.new
result.type_map
result.field_name_type = :string
result.field_name_type
result.clear

conn.exec("SELECT 1") { |res| res.ntuples }.abs
conn.query("SELECT 1").values
conn.query("SELECT 1") { |res| res.ntuples }.abs
conn.exec_params("SELECT $1::int", [1]).values
conn.exec_params("SELECT $1::int", [1], 1).values
conn.exec_params("SELECT 1", nil, 0, PG::TypeMapAllStrings.new).values
conn.exec_params("SELECT $1::int", [1]) { |res| res.ntuples }.abs
conn.prepare("stmt", "SELECT $1::int", [23]).ntuples
conn.exec_prepared("stmt", [1]).values
conn.exec_prepared("stmt", [1], 0) { |res| res.ntuples }.abs
conn.describe_prepared("stmt").nfields
conn.send_query("SELECT 1")
conn.send_query_params("SELECT $1", [1])
conn.send_query_params("SELECT $1", [1], 1, PG::TypeMapAllStrings.new)
conn.get_result&.ntuples
conn.get_result { |res| res.ntuples }&.abs
conn.get_last_result&.ntuples
conn.discard_results

# Escaping
conn.escape_string("it's").upcase
conn.escape("it's").upcase
conn.escape_literal("it's").upcase
conn.escape_identifier("users").upcase
conn.quote_ident("users").upcase
conn.escape_bytea("\x00").upcase
conn.unescape_bytea("\\x00").upcase
PG::Connection.escape_string("it's").upcase
PG::Connection.escape_bytea("\x00").upcase
PG::Connection.unescape_bytea("\\x00").upcase
PG::Connection.quote_ident("users").upcase
PG::Connection.quote_ident(["public", "users"]).upcase
conn.encrypt_password("secret", "user").upcase
conn.encrypt_password("secret", "user", "scram-sha-256").upcase
conn.encrypt_password("secret", "user", nil).upcase

# Connection state
conn.status + conn.transaction_status + conn.server_version + conn.backend_pid + conn.port
conn.transaction_status != PG::PQTRANS_INERROR
conn.error_message.upcase
conn.parameter_status("server_encoding")&.upcase
conn.socket_io.fileno
conn.host&.upcase
conn.options&.upcase
conn.ssl_in_use? ? 1 : 0
conn.conninfo_hash[:dbname]
conn.conndefaults.first
conn.conndefaults_hash.keys
PG::Connection.conndefaults.first
PG::Connection.conndefaults_hash.keys.map(&:to_sym)
PG::Connection.conninfo_parse("dbname=app").first
PG::Connection.ping("dbname=app") + PG::Connection.ping(host: "localhost")
conn.cancel&.upcase
conn.reset.finished?
conn.close
conn.finish
conn2.finished? ? 1 : 0

# Transactions and COPY
conn.transaction do |c|
  c.exec("INSERT INTO users VALUES (1)")
  raise PG::RollbackTransaction
end
conn.transaction { |c| c.db }&.upcase

encoder = PG::TextEncoder::CopyRow.new
conn.copy_data("COPY users FROM STDIN", encoder) do |res|
  res.result_status
  conn.put_copy_data([1, "a"])
  conn.put_copy_data("1\ta\n", encoder)
  conn.put_copy_end
  conn.put_copy_end("error")
end.ntuples
conn.copy_data("COPY users TO STDOUT") do
  conn.get_copy_data
  conn.get_copy_data(false, PG::TextDecoder::CopyRow.new)
end
conn.encoder_for_put_copy_data = encoder
conn.encoder_for_put_copy_data
conn.decoder_for_get_copy_data = PG::TextDecoder::CopyRow.new
conn.decoder_for_get_copy_data

# Notifications
conn.notifies&.keys
conn.wait_for_notify(1.5)&.upcase
conn.wait_for_notify { |event, pid, payload| event.upcase + pid.to_s + payload.to_s }&.upcase

# Encodings and type maps
conn.set_client_encoding("UTF8")
conn.client_encoding = "UTF8"
conn.get_client_encoding.upcase
conn.internal_encoding&.name
conn.internal_encoding = "UTF-8"
conn.external_encoding.name
conn.type_map_for_results = PG::BasicTypeMapForResults.new(conn)
conn.type_map_for_results
conn.type_map_for_queries = PG::BasicTypeMapForQueries.new(conn)
conn.type_map_for_queries
conn.field_name_type = :symbol
conn.field_name_type

type_map = PG::BasicTypeMapForResults.new(conn, registry: nil)
type_map.add_coder(PG::TextDecoder::Integer.new(oid: 23, name: "int4"))
type_map.coders.first
type_map.rm_coder(0, 23)
type_map.build_column_map(conn.exec("SELECT 1")).coders
type_map.default_type_map = PG::TypeMapAllStrings.new
type_map.default_type_map

by_column = PG::TypeMapByColumn.new([PG::TextEncoder::Integer.new, nil])
by_column.coders.first
by_column.oids.first
copy_row = PG::TextEncoder::CopyRow.new(type_map: by_column, delimiter: ",", null_string: "")
copy_row.type_map = by_column
copy_row.type_map
copy_row.delimiter = "\t"
copy_row.delimiter.upcase
copy_row.null_string = "\\N"
copy_row.null_string.upcase
copy_row.encode([1, nil])&.upcase

by_class = PG::TypeMapByClass.new
by_class[Integer] = PG::TextEncoder::Integer.new
by_class[Integer]
by_class.coders

# Coders
array_encoder = PG::TextEncoder::Array.new(name: "int4", elements_type: PG::TextEncoder::Integer.new, delimiter: ",")
array_encoder.encode([1, 2])&.upcase
PG::TextEncoder::Array.new.encode(["a", "b"])&.upcase
array_encoder.elements_type = PG::TextEncoder::String.new
array_encoder.elements_type
array_encoder.needs_quotation = true
array_encoder.needs_quotation? ? 1 : 0
array_encoder.dimensions = 1
array_encoder.dimensions
array_encoder.delimiter = ","
array_encoder.delimiter.upcase
array_encoder.oid = 1007
array_encoder.oid + array_encoder.format + array_encoder.flags
array_encoder.format = 0
array_encoder.flags = 0
array_encoder.name = "int4"
array_encoder.name&.upcase
array_encoder.to_h

PG::TextEncoder::Boolean.new.encode(true)&.upcase
PG::TextEncoder::Integer.new.encode(1)&.upcase
PG::TextEncoder::Float.new.encode(1.5)&.upcase
PG::TextEncoder::String.new.encode("a")&.upcase
PG::TextEncoder::Bytea.new.encode("a")&.upcase
PG::TextEncoder::Identifier.new.encode(["public", "users"])&.upcase
PG::TextEncoder::Numeric.new.encode(1)&.upcase
PG::TextEncoder::Date.new.encode(Time.now)&.upcase
PG::TextEncoder::Inet.new.encode("127.0.0.1")&.upcase
PG::TextEncoder::JSON.new.encode({ "a" => 1 })&.upcase
PG::TextEncoder::QuotedLiteral.new(elements_type: PG::TextEncoder::String.new).encode("a")&.upcase

PG::TextDecoder::Boolean.new.decode("t")
PG::TextDecoder::Integer.new.decode("1", 0, 0)&.succ
PG::TextDecoder::Float.new.decode("1.5")&.floor
PG::TextDecoder::String.new.decode("a")&.upcase
PG::TextDecoder::Bytea.new.decode("\\x00")&.upcase
PG::TextDecoder::Identifier.new.decode("public.users")&.first
PG::TextDecoder::Numeric.new.decode("1")
PG::TextDecoder::Date.new.decode("2020-01-01")
PG::TextDecoder::Inet.new.decode("127.0.0.1")
PG::TextDecoder::JSON.new.decode("{}")
PG::TextDecoder::Timestamp.new.decode("2020-01-01 00:00:00")&.year
PG::TextDecoder::TimestampUtc.new.decode("2020-01-01 00:00:00")&.year
PG::TextDecoder::TimestampUtcToLocal.new.decode("2020-01-01 00:00:00")&.year
PG::TextDecoder::TimestampLocal.new.decode("2020-01-01 00:00:00")&.year
PG::TextDecoder::TimestampWithTimeZone.new.decode("2020-01-01 00:00:00+09")&.year
PG::TextDecoder::TimestampWithoutTimeZone.new.decode("2020-01-01 00:00:00")&.year
# @type var with_zone: PG::TextDecoder::TimestampWithTimeZone
with_zone = PG::TextDecoder::Timestamp.new
with_zone.decode("2020-01-01 00:00:00+09")&.year
# @type var without_zone: PG::TextDecoder::TimestampWithoutTimeZone
without_zone = PG::TextDecoder::TimestampLocal.new
without_zone.decode("2020-01-01 00:00:00")&.year
PG::TextDecoder::Array.new.decode("{1,2}")&.first
PG::TextDecoder::CopyRow.new.decode("1\ta\n")&.first

# Exceptions
begin
  conn.exec("SELECT")
rescue PG::UniqueViolation, PG::NotNullViolation, PG::ForeignKeyViolation, PG::CheckViolation, PG::ExclusionViolation => e
  e.result&.error_field(PG::Result::PG_DIAG_CONSTRAINT_NAME)&.upcase
  e.connection&.db
  e.message.upcase
  e.error.upcase
rescue PG::QueryCanceled, PG::LockNotAvailable, PG::TRSerializationFailure, PG::TRDeadlockDetected => e
  e.message.upcase
rescue PG::ReadOnlySqlTransaction, PG::InFailedSqlTransaction, PG::InvalidTransactionState => e
  e.message.upcase
rescue PG::SyntaxError, PG::UndefinedTable, PG::UndefinedColumn, PG::UndefinedFunction, PG::UndefinedObject => e
  e.message.upcase
rescue PG::DuplicateColumn, PG::DuplicateTable, PG::DuplicateObject, PG::InsufficientPrivilege => e
  e.message.upcase
rescue PG::InvalidRegularExpression, PG::DatetimeFieldOverflow, PG::InvalidDatetimeFormat, PG::InvalidTextRepresentation => e
  e.message.upcase
rescue PG::NumericValueOutOfRange, PG::StringDataRightTruncation, PG::DivisionByZero, PG::InvalidParameterValue => e
  e.message.upcase
rescue PG::DiskFull, PG::OutOfMemory, PG::TooManyConnections, PG::AdminShutdown, PG::CrashShutdown, PG::CannotConnectNow => e
  e.message.upcase
rescue PG::ConnectionBad, PG::UnableToSend, PG::ConnectionFailure, PG::ConnectionException => e
  e.message.upcase
rescue PG::ServerError, PG::DataException, PG::IntegrityConstraintViolation, PG::RestrictViolation => e
  e.message.upcase
rescue PG::TransactionRollback, PG::SyntaxErrorOrAccessRuleViolation, PG::InsufficientResources => e
  e.message.upcase
rescue PG::ObjectNotInPrerequisiteState, PG::OperatorIntervention => e
  e.message.upcase
rescue PG::NotAllCopyDataRetrieved, PG::LostCopyState, PG::NotInBlockingMode, PG::InvalidResultStatus => e
  e.message.upcase
rescue PG::NoResultError, PG::InvalidChangeOfResultFields => e
  e.message.upcase
rescue PG::Error => e
  e.message.upcase
end

raise PG::UniqueViolation, "duplicate key" if version < 0
raise PG::Error.new("failed", connection: conn) if version < 0
raise PG::Error.new("failed", result: result) if version < 0

tuple = result.tuple(0)
tuple.each { |key, value| [key.to_s, value] }
tuple.each_value { |value| value }
tuple.each_key { |key| key.to_s }
tuple.fetch("id")
tuple.fetch("id", 0)
tuple.fetch("id") { |key| key.to_s }
tuple.values.first
tuple.length.succ
tuple.has_key?("id") ? 1 : 0

result.each.first&.keys
result.each_row.first&.first
result.each_tuple.first&.keys
tuple.each.first
tuple.each_value.first
tuple.each_key.first
