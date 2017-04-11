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
    movietime = nil
    DAYTIME.each_pair { |time, filter|
      filter.each_pair { |key, value|
        movietime = time if movie.match?(key, value)
      }
    }
    if movietime.nil?
      raise ArgumentError, "You can't view movie '#{movie_title}'"
    end
    movietime
  end

end