require_relative '../lib/movie_collection'
require_relative '../lib/netflix'
require_relative '../lib/theatre'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)
filtered = movies.sort_by(:year).first(10)
puts filtered
exit()
puts
netflix = Netflix.new(filename)
netflix.pay(10)
netflix.show(genre: 'Drama', period: :modern)
#p netflix.account
p netflix.how_much?('The Terminator')
#p netflix.how_much?('Sex and the city')
puts
theatre = Theatre.new(filename)
select_movies = theatre.select {|movie| movie.director == 'Billy Wilder' }
p select_movies
theatre.show('13:30')
#p theatre.when?('Once Upon a Time in the West')
p theatre.when?('American History X')
theatre.show('3:30')


