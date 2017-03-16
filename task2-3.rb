fileName = 'movies.txt'
moviesList = File.new(fileName)
movies = []
i = 0
# put films info in array
begin
  info = moviesList.readline.split('|')
  movies[i] = info
  i += 1
end until moviesList.eof?

#work with array
for film in movies do
  name = film[1]
  rating = film[7]
  stars = '*' *rating.split('.')[1].to_i
  if name.index("Max")
    puts name + '  ' + rating + ' '+stars
  end
end

moviesList.close
