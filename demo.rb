require './movie.rb'
require './movie_collection.rb'
require './cinema.rb'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)
netflix = Netflix.new(movies)

netflix.pay(10)
netflix.show(genre: 'Comedy', period: :classic)
p netflix.account
p netflix.how_much?('The Terminator')

