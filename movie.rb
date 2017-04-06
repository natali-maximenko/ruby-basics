require 'date'

class Movie
  attr_accessor :link, :title, :year, :country, :date, :genre,
                :length, :rating, :director, :actors, :period

  def initialize(link, title, year, country, date, genre, length, rating, director, actors)
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
  end

  def self.load_from_csv(string, pattern = '|')
    info = string.split(pattern)
    new(*info)
  end

  def self.load_from_array(info)
    new(*info)
  end

  def self.create(movie)
    case movie[2].to_i
      when 1900..1944
        AncientMovie.load_from_array(movie)
      when 1945..1967
        ClassicMovie.load_from_array(movie)
      when 1968..1999
        ModernMovie.load_from_array(movie)
      else
        NewMovie.load_from_array(movie)
    end
  end

  def has_genre?(search_genre)
    genre.include?(search_genre)
  end

  def match?(key, value)
    field = self.send(key)
    if field.instance_of?(Array)
      field.grep(value).any?
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
    "<Movie title: '#{@title}', year: #{@year}, country: #{@country}, date: #{@date}, genre: '#{@genre}', length: #{@length}, rating: #{@rating}, director: '#{@director}', actors: '#{@actors}'>\n"
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

  def inspect
    "<AncientMovie title: '#{@title}', year: #{@year}, country: #{@country}, date: #{@date}, genre: '#{@genre}', length: #{@length}, rating: #{@rating}, director: '#{@director}', actors: '#{@actors}'>"
  end
end

class ClassicMovie < Movie
  def period
    :classic
  end

  def to_s
    "#{@title} - classic movie, director #{@director}"
  end

  def inspect
    "<ClassicMovie title: '#{@title}', year: #{@year}, country: #{@country}, date: #{@date}, genre: '#{@genre}', length: #{@length}, rating: #{@rating}, director: '#{@director}', actors: '#{@actors}'>"
  end
end

class ModernMovie < Movie
  def period
    :modern
  end

  def to_s
    "#{@title} - modern movie: play #{@actors}"
  end

  def inspect
    "<ModernMovie title: '#{@title}', year: #{@year}, country: #{@country}, date: #{@date}, genre: '#{@genre}', length: #{@length}, rating: #{@rating}, director: '#{@director}', actors: '#{@actors}'>"
  end
end

class NewMovie < Movie
  def period
    :new
  end

  def to_s
    "#{@title} - latest, was released #{Date.today.year - @year} years ago!"
  end

  def inspect
    "<NewMovie title: '#{@title}', year: #{@year}, country: #{@country}, date: #{@date}, genre: '#{@genre}', length: #{@length}, rating: #{@rating}, director: '#{@director}', actors: '#{@actors}'>"
  end
end