require './movie.rb'
require './movie_collection.rb'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)

p movies.all.first.actors
p movies.all.first.has_genre?('Drama')
p movies.sort_by(:date).first(5)
puts
p movies.filter(genre: 'Comedy').first(10)
p movies.filter(date: '1994', rating: 9..10)
p movies.filter(length: 100..150).first(5)
p movies.filter(genre: 'Drama', country: 'Italy', year: 1987..1997)
p movies.filter(actors: /Pacino/)
#movies.stats(:director)
