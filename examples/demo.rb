require 'cinema'

filename = ARGV[0] || 'movies.txt'

netflix = Cinema::Netflix.new(filename)
netflix.pay(30)
puts Cinema::Netflix.cash
netflix.show(genre: 'Drama', period: :modern)
netflix.show { |movie| !movie.title.include?('Terminator') && movie.genre.include?('Action') && movie.year > 2003}
netflix.define_filter(:sci_fi) { |movie| movie.genre.include?('Sci-Fi') && movie.country != 'UK' }
netflix.show(sci_fi: true)
netflix.show(sci_fi: true, director: 'Christopher Nolan')
netflix.define_filter(:new_sci_fi) { |movie, year| movie.year > year && movie.genre.include?('Sci-Fi') && movie.country != 'UK' }
netflix.show(new_sci_fi: 2010)
netflix.define_filter(:newest_sci_fi, arg: 2014, from: :new_sci_fi)
netflix.show(newest_sci_fi: true)
puts Cinema::Netflix.cash
puts netflix.how_much?('The Terminator')
#p netflix.how_much?('Sex and the city')
puts
theatre = Cinema::Theatre.new(filename)
select_movies = theatre.select {|movie| movie.director == 'Billy Wilder' }
p select_movies
puts theatre.cash
theatre.show('13:30')
puts theatre.cash
theatre.take('Bank')
puts theatre.cash
#p theatre.when?('Once Upon a Time in the West')
puts theatre.when?('American History X')
#theatre.show('3:30')


