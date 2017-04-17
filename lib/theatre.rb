require_relative 'movie_collection'
require 'date'

class Theatre < MovieCollection
  PERIODS = {
      morning: 8..11,
      day: 12..17,
      evening: 17..23
  }
  DAYTIME = {
      morning: {period: :ancient},
      day: {genre: ['Comedy', 'Adventure']},
      evening: {genre: ['Drama', 'Horror']}
  }

  def show(time)
    hour = DateTime.parse(time).hour
    daytime = PERIODS.keys.detect { |period| PERIODS[period] === hour }
    raise ArgumentError, "No movies in this time" if daytime.nil?
    movie = most_popular_movie(filter(DAYTIME[daytime]))
    super(movie)
  end

  def when?(movie_title)
    movie = filter(title: movie_title).first
    raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
    movietime = DAYTIME.keys.detect {|time|
      DAYTIME[time].any? {|key, value| movie.match?(key, value)}
    }
    raise ArgumentError, "You can't view movie '#{movie_title}'" if movietime.nil?
    "From #{PERIODS[movietime].first}:00 to #{PERIODS[movietime].last}:00"
  end

end