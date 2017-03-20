require 'date'

def print_movie_info(film)
  puts film[:title] + '(' + film[:release_date] +'; ' + film[:genre] +'; ' + film[:country] +'; ' + film[:rating] +') - ' + film[:length]
end

filename = ARGV[0] || 'movies.txt'

if !File.exist?(filename)
  raise ArgumentError, 'File "'+ filename + '" not found'
end

movies_list = []

File.read(filename).split("\n").each do |line|
  info = line.split('|')
  film = {
      link: info[0],
      title: info[1],
      year: info[2],
      country: info[3],
      release_date: info[4],
      genre: info[5],
      length: info[6],
      rating: info[7],
      director: info[8],
      actors: info[9]
  }
  movies_list.push(film)
end


# sort by length desc
sorted_by_size = movies_list.sort { |x, y| y.fetch(:length).to_i <=> x.fetch(:length).to_i}
puts '5 movies sorted by length desc'
sorted_by_size[0..4].each { |movie| print_movie_info(movie) }
puts

# find comedies
comedies = movies_list.select { |e| e[:genre].split(',').include?('Comedy') }
# sort by release date asc
sorted_by_release = comedies.sort { |x, y|
  x_year = x[:release_date].split('-').first.to_i
  y_year = y[:release_date].split('-').first.to_i
  x_year <=> y_year
  #a = Date::strptime(x[:release_date], '%Y-%m-%d')
  #b = Date::strptime(y[:release_date], '%Y-%m-%d')
  #a <=> b
}
puts '10 comedies sorted release date asc'
sorted_by_release[0..9].each { |movie| print_movie_info(movie) }
puts

directors = []
movies_list.each { |e|
  if !directors.include?(e.fetch(:director))
    directors.push(e.fetch(:director))
  end
}
sorted_by_firstname = directors.sort_by { |x| x.split(' ').last }
puts 'Unique directors array sorted by firstname asc'
print sorted_by_firstname
puts

not_usa_production = movies_list.select { |e| e[:country] != 'USA' }
puts 'Count film not USA production = ' + not_usa_production.length.to_s
