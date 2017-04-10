require './movie.rb'
require './movie_collection.rb'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)
filtered = movies.filter(genre: 'Comedy', period: :classic)
filtered.each {|movie| movie.load_collection(movies) }
puts filtered

netflix = Netflix.new(filename)
netflix.pay(10)
netflix.show(genre: 'Comedy', period: :modern)
p netflix.account
p netflix.how_much?('The Terminator')
#p netflix.how_much?('Sex and the city')

theatre = Theatre.new(filename)
theatre.show(:day)
#theatre.show(:night)
#p theatre.when?('Once Upon a Time in the West')
p theatre.when?('American History X')


