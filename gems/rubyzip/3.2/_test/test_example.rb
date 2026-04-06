# Taken from https://github.com/rubyzip/rubyzip/blob/v3.2.0/samples/example.rb

require 'zip'

####### Using ZipInputStream alone: #######

is_val = Zip::InputStream.open('example.zip') do |zis|
  entry = zis.get_next_entry
  print "First line of '#{entry&.name} (#{entry&.size} bytes):  "
  puts "'#{zis.gets&.chomp}'"
  entry = zis.get_next_entry
  print "First line of '#{entry&.name} (#{entry&.size} bytes):  "
  puts "'#{zis.gets&.chomp}'"

  ' input-stream '
end

# Zip::InputStream.open returns the value (and type) from the block when given
is_val.strip == 'input-stream' || raise

####### Using ZipFile to read the directory of a zip file: #######

zf = Zip::File.new('example.zip')
zf.each_with_index do |entry, index|
  puts "entry #{index} is #{entry.name}, size = #{entry.size}, compressed size = #{entry.compressed_size}"
  # use zf.get_input_stream(entry) to get a ZipInputStream for the entry
  # entry can be the ZipEntry object or any object which has a to_s method that
  # returns the name of the entry.
end

####### Using ZipOutputStream to write a zip file: #######

os_val = Zip::OutputStream.open('exampleout.zip') do |zos|
  zos.put_next_entry('the first little entry')
  zos.puts 'Hello hello hello hello hello hello hello hello hello'

  zos.put_next_entry('the second little entry')
  zos.puts 'Hello again'

  # Use rubyzip or your zip client of choice to verify
  # the contents of exampleout.zip
  ' output-stream '
end

# Zip::OutputStream.open returns the value (and type) from the block when given
os_val.strip == 'output-stream' || raise

####### Using ZipFile to change a zip file: #######

f_val = Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.add('thisFile.rb', 'example.rb')
  zip_file.rename('thisFile.rb', 'ILikeThisName.rb')
  zip_file.add('Again', 'example.rb')

  ' file-open '
end

# Zip::File.open returns the value (and type) from the block when given
f_val.strip == 'file-open' || raise

z_file = Zip::File.open('exampleout.zip')
# Zip::File.open returns a new instance when no block is given
z_file.entries.size == 2 || raise

# Lets check
Zip::File.open('exampleout.zip') do |zip_file|
  puts "Changed zip file contains: #{zip_file.entries.join(', ')}"
  zip_file.remove('Again')
  puts "Without 'Again': #{zip_file.entries.join(', ')}"
end

####### Using ZipInputStream.open without a block: #######

zis = Zip::InputStream.open('example.zip')
entry = zis.get_next_entry
puts "First entry: #{entry&.name}"
zis.close

####### Accessing Entry attributes: #######

Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.each do |entry|
    puts entry.name
    puts entry.size
    puts entry.compressed_size
    puts entry.compression_method
    puts entry.mtime
    puts entry.directory?
    puts entry.file?
    puts entry.symlink?
  end
end

####### Using File#find_entry and File#get_entry: #######

Zip::File.open('exampleout.zip') do |zip_file|
  found = zip_file.find_entry('the second little entry')
  puts found&.name

  entry = zip_file.get_entry('the second little entry')
  puts entry&.name
end

####### Using File#read: #######

Zip::File.open('exampleout.zip') do |zip_file|
  content = zip_file.read('the second little entry')
  puts content
end

####### Using File#glob: #######

Zip::File.open('exampleout.zip') do |zip_file|
  matches = zip_file.glob('*little*')
  matches.each { |e| puts e.name }
end

####### Using File#get_input_stream with and without a block: #######

# with block: returns TContent
Zip::File.open('exampleout.zip') do |zip_file|
  result = zip_file.get_input_stream('the first little entry') do |stream|
    stream.read
  end
  puts result
end

# without block: returns IO
Zip::File.open('exampleout.zip') do |zip_file|
  stream = zip_file.get_input_stream('the first little entry')
  puts stream.read
end

####### Using File#get_output_stream with and without a block: #######

# with block: returns TContent
Zip::File.open('exampleout.zip') do |zip_file|
  result = zip_file.get_output_stream('new_entry.txt') do |stream|
    stream.write('Hello from get_output_stream')
    'done'
  end
  puts result
end

# without block: returns IO
Zip::File.open('exampleout.zip') do |zip_file|
  stream = zip_file.get_output_stream('another_entry.txt')
  stream.write('Hello again')
end

####### Using File.open_buffer with and without a block: #######

# with block: returns TContent
buf_val = Zip::File.open_buffer do |zip_file|
  zip_file.add('buf_entry.txt', 'example.rb')
  'buffer-open'
end
buf_val.strip == 'buffer-open' || raise

# without block: returns File
buf_zip = Zip::File.open_buffer
buf_zip.add('buf_entry.txt', 'example.rb')

####### Using OutputStream.write_buffer: #######

io = Zip::OutputStream.write_buffer do |zos|
  zos.put_next_entry('buffered_entry.txt')
  zos.write('Hello from write_buffer')
end
puts io.class

####### Using Entry#get_input_stream directly (block and no-block): #######

Zip::File.open('exampleout.zip') do |zip_file|
  entry = zip_file.get_entry('the first little entry')

  # with block: returns TContent
  result = entry&.get_input_stream { |stream| stream.read }
  puts result

  # without block: returns IO
  stream = entry&.get_input_stream
  puts stream&.read
end

####### Using Entry#extract: #######

Zip::File.open('exampleout.zip') do |zip_file|
  entry = zip_file.get_entry('the first little entry')
  returned = entry&.extract('extracted_entry.txt')
  # returns self (Entry)
  puts returned&.name
end

####### Using InputStream#rewind and #sysread: #######

zis = Zip::InputStream.open('example.zip')
zis.get_next_entry
data = zis.sysread(10)
puts data
zis.rewind
zis.close

####### Using OutputStream#<< and OutputStream.open without a block: #######

zos = Zip::OutputStream.open('stream_out.zip')
zos.put_next_entry('streamed.txt')
ret = zos << 'Hello via <<'
# << returns self
puts ret.class
zos.close

####### Using OutputStream#close_buffer: #######

zos2 = Zip::OutputStream.open('buffer_out.zip', suppress_extra_fields: true)
zos2.put_next_entry('buf.txt')
zos2.write('buffered content')
io = zos2.close_buffer
puts io.class

####### Using File.foreach: #######

Zip::File.foreach('exampleout.zip') do |entry|
  puts entry.name
end

####### Using File.count_entries: #######

count = Zip::File.count_entries('exampleout.zip')
puts count

####### Using File#size, File#comment, File#comment=: #######

Zip::File.open('exampleout.zip') do |zip_file|
  puts zip_file.size
  zip_file.comment = 'test comment'
  puts zip_file.comment
end

####### Using File#each directly: #######

Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.each do |entry|
    puts entry.name
  end
end

####### Using File#mkdir: #######

Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.mkdir('new_directory/')
end

####### Using File#add_stored and File#replace: #######

Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.add_stored('stored_entry.rb', 'example.rb')
  zip_file.replace('stored_entry.rb', 'example.rb')
end

####### Using File#commit and File#write_buffer: #######

Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.add('commit_entry.rb', 'example.rb')
  zip_file.commit
end

Zip::File.open('exampleout.zip') do |zip_file|
  io = zip_file.write_buffer
  puts io.class
end

####### Using Zip.setup and Zip config attrs: #######

Zip.setup do |config|
  config.unicode_names = true
  config.on_exists_proc = false
  config.continue_on_exists_proc = false
  config.sort_entries = false
  config.default_compression = Zlib::DEFAULT_COMPRESSION
  config.write_zip64_support = false
  config.warn_invalid_date = true
  config.case_insensitive_match = false
  config.force_entry_names_encoding = nil
  config.validate_entry_sizes = true
end

puts Zip.unicode_names
puts Zip.default_compression

Zip.reset!

####### Using block callbacks on File#add, File#rename, File#extract: #######

Zip::File.open('exampleout.zip') do |zip_file|
  # add with overwrite callback: block returns boolish
  zip_file.add('the first little entry', 'example.rb') { |_entry_name, _zip_entry| true }

  # rename with overwrite callback
  zip_file.rename('the first little entry', 'renamed_entry.txt') { |_entry_name, _zip_entry| true }

  # extract with overwrite callback
  entry = zip_file.get_entry('renamed_entry.txt')
  entry&.extract('extracted_with_callback.txt') { |_entry, _path| true }
end

####### Using File#commit_required?: #######

Zip::File.open('exampleout.zip') do |zip_file|
  puts zip_file.commit_required?
  zip_file.add('new_for_commit.rb', 'example.rb')
  puts zip_file.commit_required?
end

####### Using remaining Entry predicates: #######

Zip::File.open('exampleout.zip') do |zip_file|
  zip_file.each do |entry|
    puts entry.name_safe?
    puts entry.encrypted?
    puts entry.zip64?
    puts entry.aes?
    puts entry.absolute_time?
  end
end

####### Using Filesystem API: #######

require 'zip/filesystem'

Zip::File.open('exampleout.zip') do |zip_file|
  # FileSystem::File: predicates and metadata
  mapper = Zip::FileSystem::ZipFileNameMapper.new(zip_file)
  file = Zip::FileSystem::File.new(mapper)
  file.exists?('the second little entry')
  file.file?('the second little entry')
  file.directory?('the second little entry')
  file.size('the second little entry')
  file.readable?('the second little entry')
  file.writable?('the second little entry')
  file.zero?('the second little entry')
  file.basename('the second little entry')
  file.dirname('the second little entry')
  file.expand_path('the second little entry')
  file.join('dir', 'file.txt')
  parts = file.split('dir/file.txt')
  puts parts[0]
  puts parts[1]
  puts file.mtime('the second little entry')
  puts file.pipe?('the second little entry')
  puts file.chardev?('the second little entry')
  puts file.socket?('the second little entry')
  puts file.blockdev?('the second little entry')
  lines = file.readlines('the second little entry')
  puts lines.first

  # FileSystem::File#open with block: returns TContent
  result = file.open('the second little entry') { |io| io.read }
  puts result

  # FileSystem::File#open without block: returns IO
  io = file.open('the second little entry')
  puts io.read

  # FileSystem::File#read
  content = file.read('the second little entry')
  puts content

  # FileSystem::Dir: navigation and iteration
  dir = Zip::FileSystem::Dir.new(mapper)
  puts dir.pwd
  entries = dir.entries('/')
  puts entries.first

  # Dir#open with block: no return
  dir.open('/') { |_iter| 'ignored' }

  # Dir#open without block: returns DirectoryIterator
  iter = dir.open('/')
  iter.each { |name| puts name }

  # Dir#glob
  matches = dir.glob('/*')
  puts matches.first

  # Dir#foreach
  dir.foreach('/') { |name| puts name }

  # Dir#mkdir and Dir#delete
  dir.mkdir('fs_test_dir')
  dir.delete('fs_test_dir')
end

####### Using Zip::Error and subclasses: #######

begin
  Zip::File.open('nonexistent.zip') { |_| }
rescue Zip::Error => e
  puts e.message
end

begin
  raise Zip::EntryNameError.new('bad/name')
rescue Zip::EntryNameError => e
  puts e.message
end

begin
  raise Zip::EntryExistsError.new('add', 'duplicate.txt')
rescue Zip::EntryExistsError => e
  puts e.message
end

begin
  raise Zip::DestinationExistsError.new('/some/dest')
rescue Zip::DestinationExistsError => e
  puts e.message
end

begin
  raise Zip::SplitArchiveError
rescue Zip::SplitArchiveError => e
  puts e.message
end

####### Using ZipFile to split a zip file: #######

# Creating large zip file for splitting
Zip::OutputStream.open('large_zip_file.zip') do |zos|
  puts 'Creating zip file...'
  10.times do |i|
    zos.put_next_entry("large_entry_#{i}.txt")
    zos.puts 'Hello' * 104_857_600
  end
end

# Splitting created large zip file
part_zips_count = Zip::File.split('large_zip_file.zip', segment_size: 2_097_152, delete_original: false, partial_zip_file_name: 'part_zip_file')
puts "Zip file splitted in #{part_zips_count} parts"
