require 'csv'
require 'ostruct'
require 'date'

def print_movie_info(film)
  puts "#{film[:title]} ( #{film[:release_date]}; #{film[:genre]}; #{film[:country]}; #{film[:rating]}) - #{film[:length]}"
end

filename = ARGV[0] || 'movies.txt'

unless File.exists?(filename)
  raise ArgumentError, "File #{filename} not found"
end

INFO = %i[link title year country release_date genre length rating director actors]
movies_list = CSV.read(filename, col_sep: '|').map do |movie|
  p movie
  exit()
  OpenStruct.new(INFO.zip(movie).to_h)
end

# sort by length desc
sorted_by_size = movies_list.sort_by { |x| x.length.to_i}.reverse.first(5)
puts '5 movies sorted by length desc'
sorted_by_size.each { |movie| print_movie_info(movie) }
puts

# comedies sort by release date asc
sorted_by_release = movies_list.select { |movie| movie.genre.include?('Comedy') }
  .sort_by(&:release_date)
  .first(10)
puts '10 comedies sorted release date asc'
sorted_by_release.each { |movie| print_movie_info(movie) }
puts

directors = movies_list.map(&:director)
  .uniq
  .sort_by { |director| director.split.last }
puts 'Unique directors array sorted by firstname asc'
print directors
puts

not_usa_production = movies_list.count { |movie| movie.country != 'USA' }
puts "Count film not USA production = #{not_usa_production}"


# statistic film releases by month sorted
puts
puts 'Statistic film releases by month'
movies_list.reject { |movie| movie.release_date.size < 7 } # delete release_date without month
  .group_by { |movie| Date.strptime(movie.release_date, '%Y-%m').month } # get arrays by month
  .sort_by(&:first) # sort by month
  .each { |month, movies| puts "#{Date::MONTHNAMES[month]}: #{movies.count} films" }
