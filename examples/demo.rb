require_relative '../lib/movie_collection'
require_relative '../lib/netflix'
require_relative '../lib/theatre'

filename = ARGV[0] || 'movies.txt'

movies = Cinema::MovieCollection.new(filename)
filtered = movies.sort_by(:year).first(10)
#puts filtered
puts
netflix = Cinema::Netflix.new(filename)
netflix.pay(10)
puts Cinema::Netflix.cash
#netflix.show(genre: 'Drama', period: :modern)
netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003}
puts Cinema::Netflix.cash
puts netflix.how_much?('The Terminator')
#p netflix.how_much?('Sex and the city')
puts
theatre = Cinema::Theatre.new(filename)
select_movies = theatre.select {|movie| movie.director == 'Billy Wilder' }
#p select_movies
puts theatre.cash
theatre.show('13:30')
puts theatre.cash
theatre.take('Bank')
puts theatre.cash
#p theatre.when?('Once Upon a Time in the West')
puts theatre.when?('American History X')
#theatre.show('3:30')


