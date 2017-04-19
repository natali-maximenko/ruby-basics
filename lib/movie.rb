require 'date'

class Movie
  attr_accessor :link, :title, :year, :country, :date, :genre,
                :length, :rating, :director, :actors, :collection

  def initialize(link, title, year, country, date, genre, length, rating, director, actors, collection = nil)
    @link = link
    @title = title
    @year = year
    @country = country
    @date = date
    @genre = genre
    @length = length
    @rating = rating
    @director = director
    @actors = actors
    @collection = collection
  end

  def self.load_from_csv(string, pattern = '|')
    info = string.split(pattern)
    new(*info)
  end

  def self.load_from_array(info)
    new(*info)
  end

  def self.create(movie, collection = nil)
    movie.push(collection)
    year = movie[2]
    raise ArgumentError, "#{year} is not valid year" if /\D/.match(year) || year.to_i < 1900
    case year.to_i
      when 1900..1944
        AncientMovie.new(*movie)
      when 1945..1967
        ClassicMovie.new(*movie)
      when 1968..1999
        ModernMovie.new(*movie)
      else
        NewMovie.new(*movie)
    end
  end

  def has_genre?(search_genre)
    genre.include?(search_genre)
  end

  def match?(key, value)
    field = self.send(key)
    if field.instance_of?(Array)
      if value.instance_of?(Array)
        value.any? {|v| field.include?(v) }
      else
        field.grep(value).any?
      end
    else
      value === field
    end
  end

  def actors
    @actors.split(',')
  end

  def genre
    @genre.split(',')
  end

  def year
    @year.to_i
  end

  def inspect
    "<#{self.class.name} title: '#{@title}', year: #{@year}, country: #{@country}, date: #{@date}, genre: '#{@genre}', length: #{@length}, rating: #{@rating}, director: '#{@director}', actors: '#{@actors}'>\n"
  end

  def to_s
    "Movie: #{@title} (#{@date}; #{@genre}; #{@country}; #{@rating}) - #{@length}"
  end
end

class AncientMovie < Movie
  def period
    :ancient
  end

  def to_s
    "#{@title} - old movie (#{@year} year)"
  end
end

class ClassicMovie < Movie
  def period
    :classic
  end

  def to_s
    raise ArgumentError, "Have no info about movies collection" if @collection.nil?
    movies = @collection.filter(director: @director).count
    "#{@title} - classic movie, director #{@director} (#{movies} movies in top-250)"
  end
end

class ModernMovie < Movie
  def period
    :modern
  end

  def to_s
    "#{@title} - modern movie: play #{@actors}"
  end
end

class NewMovie < Movie
  def period
    :new
  end

  def to_s
    years = Date.today.year.to_i - @year.to_i
    "#{@title} - latest, was released #{years.to_s} years ago!"
  end
end
