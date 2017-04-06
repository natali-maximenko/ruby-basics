require './movie.rb'
require './movie_collection.rb'

filename = ARGV[0] || 'movies.txt'

netflix = Netflix.new(filename)

netflix.pay(8)
netflix.show(genre: 'Comedy', period: :classic)
p netflix.account
p netflix.how_much?('The Terminator')

