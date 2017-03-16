File.open('movies.txt') do |file|
  puts file.readline until file.eof?
end
