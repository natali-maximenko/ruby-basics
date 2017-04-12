require './movie_collection.rb'

class Theatre < MovieCollection
  DAYTIME = {
      morning: {period: :ancient},
      day: {genre: ['Comedy', 'Adventure']},
      evening: {genre: ['Drama', 'Horror']}
  }

  def show(daytime)
    raise ArgumentError, "Daytime #{daytime} is not valid" unless DAYTIME.key?(daytime)
    movie = filter(DAYTIME[daytime]).first
    super(movie)
  end

  def when?(movie_title)
    movie = filter(title: movie_title).first
    raise ArgumentError, "Movie '#{movie_title}' not found" if movie.nil?
    movietime = DAYTIME.keys.detect {|time|
      DAYTIME[time].any? {|key, value| movie.match?(key, value)}
    }
    raise ArgumentError, "You can't view movie '#{movie_title}'" if movietime.nil?
    movietime
  end

end