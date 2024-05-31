listener = Listen.to('dir/to/listen', 'dir/to/listen2') do |modified, added, removed|
  puts "modified absolute path: #{modified}"
  puts "added absolute path: #{added}"
  puts "removed absolute path: #{removed}"
end

listener.start # not blocking

sleep
