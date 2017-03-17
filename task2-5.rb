filename = ARGV[0]

if filename.nil?
  filename = 'movies.txt'
elsif !File.exist?(filename)
  raise ArgumentError, 'File "'+ filename + '" not found'
end

File.read(filename).split("\n").each do |line|
  info = line.split('|')
  name = info[1]
  rating = info[7]
  stars_count = rating.split('.')[1].to_i
  stars = '*' *stars_count
  if name.index("Godfather")
    puts name + '  ' + rating + ' '+stars
  end
end
