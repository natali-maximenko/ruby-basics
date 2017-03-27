def print_movie_info(film)
  puts "#{film[:title]} ( #{film[:release_date]}; #{film[:genre]}; #{film[:country]}; #{film[:rating]}) - #{film[:length]}"
end

filename = ARGV[0] || 'movies.txt'

unless File.exists?(filename)
  raise ArgumentError, "File #{filename} not found"
end

info = %i[link title year country release_date genre length rating director actors]
movies_list = File.open(filename).readlines.map {|line| info.zip(line.split('|')).to_h }

# sort by length desc
sorted_by_size = movies_list.sort_by { |movie| movie[:length].to_i}.reverse.first(5)
puts '5 movies sorted by length desc'
sorted_by_size.each { |movie| print_movie_info(movie) }
puts

# comedies sort by release date asc
sorted_by_release = movies_list.select { |movie| movie[:genre].split(',').include?('Comedy') }
                        .sort_by { |movie| movie[:release_date] }
puts '10 comedies sorted release date asc'
sorted_by_release.first(10).each { |movie| print_movie_info(movie) }
puts

directors = movies_list.map {|movie| movie[:director] }
                .uniq
                .sort_by { |movie| movie.split(' ').last }
puts 'Unique directors array sorted by firstname asc'
print directors
puts

#not_usa_production = movies_list.reject { |e| e[:country] == 'USA' }
not_usa_production = movies_list.count { |movie| movie[:country] != 'USA' }
puts "Count film not USA production = #{not_usa_production}"
