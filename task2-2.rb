fileName = 'movies.txt'
moviesList = File.new(fileName)
movies = []
i = 0

begin
  info = moviesList.readline.split('|')
  name = info[1]
  rating = info[7]
  if name.index("Max")
    puts name+' ' + rating
  end
  i += 1
end until moviesList.eof?

moviesList.close
