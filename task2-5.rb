fileName = ARGV[0]

# if user is bad, use default file
if fileName.nil? ||  !File.exist?(fileName)
  puts 'No filename or file not found'
  puts 'will be used default file: movies.txt'
  fileName = 'movies.txt'
end

moviesList = File.new(fileName)
# put films info in array
movies = moviesList.readlines

#work with array
for film in movies do
  info = film.split('|')
  name = info[1]
  rating = info[7]
  stars = '*' *rating.split('.')[1].to_i
  if name.index("Max")
    puts name + '  ' + rating + ' '+stars
  end
end

moviesList.close
