filename = ARGV[0] || 'movies.txt'

if !File.exist?(filename)
  raise ArgumentError, 'File "'+ filename + '" not found'
end

File.read(filename).split("\n").each do |line|
  info = line.split('|')
  name = info[1]
  rating = info[7]
  stars_count = rating.to_f * 10
  stars = '*'  * stars_count
  if name.include?("Max")
    puts name + '  ' + rating
    puts stars
  end
end
