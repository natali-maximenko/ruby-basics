require_relative '../lib/movie_collection'
require_relative '../lib/netflix'
require_relative '../lib/theatre'

filename = ARGV[0] || 'movies.txt'

movies = MovieCollection.new(filename)
filtered = movies.filter(genre: 'Comedy', period: :classic)
puts filtered
puts
netflix = Netflix.new(filename)
netflix.pay(10)
netflix.show(genre: 'Drama', period: :modern)
#p netflix.account
p netflix.how_much?('The Terminator')
#p netflix.how_much?('Sex and the city')
puts
theatre = Theatre.new(filename)
theatre.show('13:30')
#p theatre.when?('Once Upon a Time in the West')
p theatre.when?('American History X')
theatre.show('3:30')


