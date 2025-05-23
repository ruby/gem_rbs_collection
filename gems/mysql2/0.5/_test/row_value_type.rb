client = Mysql2::Client.new

client.query %[
  CREATE TABLE IF NOT EXISTS mysql2_test (
    id MEDIUMINT NOT NULL AUTO_INCREMENT,
    null_test VARCHAR(10),
    bit_test BIT(64),
    single_bit_test BIT(1),
    tiny_int_test TINYINT,
    bool_cast_test TINYINT(1),
    small_int_test SMALLINT,
    medium_int_test MEDIUMINT,
    int_test INT,
    big_int_test BIGINT,
    float_test FLOAT(10,3),
    float_zero_test FLOAT(10,3),
    double_test DOUBLE(10,3),
    decimal_test DECIMAL(10,3),
    decimal_zero_test DECIMAL(10,3),
    date_test DATE,
    date_time_test DATETIME,
    timestamp_test TIMESTAMP,
    time_test TIME,
    year_test YEAR(4),
    char_test CHAR(10),
    varchar_test VARCHAR(10),
    binary_test BINARY(10),
    varbinary_test VARBINARY(10),
    tiny_blob_test TINYBLOB,
    tiny_text_test TINYTEXT,
    blob_test BLOB,
    text_test TEXT,
    medium_blob_test MEDIUMBLOB,
    medium_text_test MEDIUMTEXT,
    long_blob_test LONGBLOB,
    long_text_test LONGTEXT,
    enum_test ENUM('val1', 'val2'),
    set_test SET('val1', 'val2'),
    PRIMARY KEY (id)
  )
]
client.query "DELETE FROM mysql2_test;"
client.query %[
  INSERT INTO mysql2_test (
    null_test, bit_test, single_bit_test, tiny_int_test, bool_cast_test, small_int_test, medium_int_test, int_test, big_int_test,
    float_test, float_zero_test, double_test, decimal_test, decimal_zero_test, date_test, date_time_test, timestamp_test, time_test,
    year_test, char_test, varchar_test, binary_test, varbinary_test, tiny_blob_test,
    tiny_text_test, blob_test, text_test, medium_blob_test, medium_text_test,
    long_blob_test, long_text_test, enum_test, set_test
  )

  VALUES (
    NULL, b'101', b'1', 1, 1, 10, 10, 10, 10,
    10.3, 0, 10.3, 10.3, 0, '2010-4-4', '2010-4-4 11:44:00', '2010-4-4 11:44:00', '11:44:00',
    2009, "test", "test", "test", "test", "test",
    "test", "test", "test", "test", "test",
    "test", "test", 'val1', 'val1,val2'
  )
]

test_result = client.query("SELECT * FROM mysql2_test ORDER BY id DESC LIMIT 1").first || raise

# NULL => nil
test_result['null_test'] #: nil
# BIT(64) => String
test_result['bit_test'] #: String
# TINYINT => Integer
test_result['tiny_int_test'] #: Integer
# INT => Integer
test_result['int_test'] #: Integer
# DECIMAL => BigDecimal
test_result['decimal_test'] #: BigDecimal
# FLOAT => Float
test_result['float_test'] #: Float
# DATETIME => Time
test_result['date_time_test'] #: Time
# TIMESTAMP => Time
test_result['timestamp_test'] #: Time
# DATE => Date
test_result['date_test'] #: Date
# ENUM => String
test_result['enum_test'] #: String
