require "rubyzip"
require "zip/filesystem"
require "stringio"
require "tempfile"

Zip.validate_declared_number_of_entries = true
# @type var validate: bool
validate = Zip.validate_declared_number_of_entries

# @type var zip_file: Zip::File
zip_file = Zip::File.open("archive.zip", create: true, suppress_extra_fields: [:ntfs, :zip64])

# @type var archive_name: String | StringIO
archive_name = zip_file.name

# @type var added: Zip::Entry
added = zip_file.add("a.txt", "a.txt") { true }

# @type var recursive: Zip::File
recursive = zip_file.add_recursive("src", prefix: "prefix", max_depth: 2) { false }

# @type var extracted_entry: Zip::Entry
extracted_entry = zip_file.extract("a.txt", nil, destination_directory: "out") { |_entry, _path| true }

# @type var extracted_all: Zip::File
extracted_all = zip_file.extract_all("out") { |_entry, _path| true }

# @type var stream: Zip::entry_input_stream
stream = zip_file.get_input_stream("a.txt")

# @type var content: String?
content = zip_file.get_input_stream("a.txt") { |input| input.read }

# @type var output: Tempfile
output = zip_file.get_output_stream("b.txt", permissions: 0o644, time: Time.now)

# @type var written: Integer
written = zip_file.get_output_stream("c.txt") { |out| out.write("c") }

# @type var each_result: Array[Zip::Entry]
each_result = zip_file.each { |entry| entry.name }

# @type var entry_enum: Enumerator[Zip::Entry, Array[Zip::Entry]]
entry_enum = zip_file.each

# @type var found: Zip::Entry?
found = zip_file.find_entry(added)

# @type var buffer: StringIO
buffer = zip_file.write_buffer

zip_file.close

# @type var opened_buffer: Zip::File
opened_buffer = Zip::File.open_buffer(buffer)

# @type var written_back: (IO | StringIO)?
written_back = Zip::File.open_buffer(buffer.string) { |zf| zf.size }

# @type var by_class: Zip::File
by_class = Zip::File.add_recursive("rec.zip", "src", prefix: :prefix)

# @type var all_out: Zip::File
all_out = Zip::File.extract_all("rec.zip", "out")

# @type var count: Integer
count = Zip::File.count_entries(StringIO.new(buffer.string))

entry = Zip::Entry.new(nil, "entry.txt", comment: nil, time: Time.now, extra: "")

# @type var mtime: Time
mtime = entry.time

# @type var atime: Time?
atime = entry.time(component: :atime)

# @type var stored_time: Zip::DOSTime?
stored_time = entry.send(:time=, Time.now)

# @type var same_entry: Zip::Entry
same_entry = entry.extract("entry.txt", destination_directory: nil, create_parent_directories: true)

# @type var entry_stream: Zip::entry_input_stream
entry_stream = entry.get_input_stream(decrypter: Zip::TraditionalDecrypter.new("password"))

# @type var line_count: Integer
line_count = Zip::InputStream.open("archive.zip", internal_encoding: "UTF-8") do |input|
  # @type var next_entry: Zip::Entry?
  next_entry = input.get_next_entry

  # @type var line: String?
  line = input.gets(8, chomp: true)

  # @type var lines: Array[String]
  lines = input.readlines("\n", 80)

  # @type var line_enum: Enumerator[String, nil]
  line_enum = input.each_line

  # @type var rewound: Zip::Entry?
  rewound = input.rewind

  # @type var chunk: String?
  chunk = input.sysread(16, +"")

  # @type var encoding: Encoding
  encoding = input.set_encoding("BINARY:UTF-8")

  lines.size
end

# @type var encrypted: StringIO
encrypted = Zip::OutputStream.write_buffer(encrypter: Zip::AESEncrypter.new("password", Zip::AESEncryption::STRENGTH_256_BIT)) do |out|
  out.comment = "archive comment"
  out.put_next_entry("secret.txt", nil, nil, Zip::Entry::STORED, nil)

  # @type var printed: nil
  printed = out.print("data")

  # @type var putc_result: String
  putc_result = out.putc("x")
end

# @type var tempfile: Tempfile
tempfile = Zip::OutputStream.write_buffer(Tempfile.new("zip")) { |out| out.put_next_entry("a") }

zip_output = Zip::OutputStream.open("stream.zip", suppress_extra_fields: :zip64)
# @type var closed_buffer: IO | StringIO | Tempfile
closed_buffer = zip_output.close_buffer

extra = Zip::ExtraField.new
# @type var field: Zip::ExtraField::Generic
field = extra.create(:zip64)

# @type var parsed: [Integer, Integer, Integer?, Integer?]
parsed = Zip::ExtraField::Zip64.new.parse(0xFFFFFFFF, 0xFFFFFFFF)

# @type var iunix_uid: Integer?
iunix_uid = Zip::ExtraField::IUnix.new.uid

Zip::File.open("archive.zip") do |zf|
  # @type var globbed: Array[Zip::Entry]
  globbed = zf.dir.glob("*.txt")

  # @type var stat: Zip::FileSystem::File::Stat
  stat = zf.file.stat("a.txt")

  # @type var touched: Array[String]
  touched = zf.file.utime(Time.now, "a.txt")

  # @type var changed: Integer
  changed = zf.file.chmod(0o644, "a.txt")

  # @type var symlink: bool
  symlink = stat.symlink?

  # @type var position: Integer
  position = zf.dir.new("/").seek(0)
end

# @type var entry_enum: Enumerator[Zip::Entry, Array[Zip::Entry]]
entry_enum = Zip::File.foreach("archive.zip")
entry_enum = zip_file.each

# @type var to_s_value: String | StringIO
to_s_value = zip_file.to_s

Zip::InputStream.open(Tempfile.new("archive")) { |input| input.get_next_entry }
