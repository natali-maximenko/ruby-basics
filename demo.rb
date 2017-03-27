require './movie.rb'
require './movie_collection.rb'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)

p movies.all.first.actors
p movies.all.first.has_genre?('Drama')
p movies.sort_by(:date).first(5)
puts
p movies.filter(:genre, 'Comedy').first(10)
p movies.filter(:country, 'Italy').first(10)
movies.stats(:director)
puts
movies.stats(:actors, 'Al Pacino')