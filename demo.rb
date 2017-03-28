require './movie.rb'
require './movie_collection.rb'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)

#p movies.all.first.actors
#p movies.all.first.has_genre?('Drama')
#p movies.sort_by(:date).first(5)
puts
puts '10 comedies'
p movies.filter(genre: 'Comedy').first(10)
puts 'genre: Drama, country: Italy, year: 1987..1997'
p movies.filter(genre: 'Drama', country: 'Italy', year: 1987..1997)
p movies.filter(actors: /Pacino/)
#movies.stats(:director)
