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
    @period = nil
  end

  def self.load_from_csv(string, pattern = '|')
    info = string.split(pattern)
    new(*info)
  end

  def self.load_from_array(info)
    new(*info)
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
    "<Movie title: '#@title', year: #@year, country: #@country, date: #@date, genre: '#@genre', length: #@length, rating: #@rating, director: '#@director', actors: '#@actors'>\n"
  end

  def to_s
    "Movie: #@title (#@date; #@genre; #@country; #@rating) - #@length"
  end
end

class AncientMovie < Movie

  def initialize(link, title, year, country, date, genre, length, rating, director, actors)
    super(link, title, year, country, date, genre, length, rating, director, actors)
    @period = :ancient
  end

  def to_s
    "#@title - old movie (#@year year)"
  end

  def inspect
    "<AncientMovie title: '#@title', year: #@year, country: #@country, date: #@date, genre: '#@genre', length: #@length, rating: #@rating, director: '#@director', actors: '#@actors'>"
  end
end

class ClassicMovie < Movie
  def initialize(link, title, year, country, date, genre, length, rating, director, actors)
    super(link, title, year, country, date, genre, length, rating, director, actors)
    @period = :classic
  end

  def to_s
    "#@title - classic movie, director #@director"
  end

  def inspect
    "<ClassicMovie title: '#@title', year: #@year, country: #@country, date: #@date, genre: '#@genre', length: #@length, rating: #@rating, director: '#@director', actors: '#@actors'>"
  end
end

class ModernMovie < Movie
  def initialize(link, title, year, country, date, genre, length, rating, director, actors)
    super(link, title, year, country, date, genre, length, rating, director, actors)
    @period = :modern
  end

  def to_s
    actors_string = @actors
    "#@title - modern movie: play #{actors_string}"
  end

  def inspect
    "<ModernMovie title: '#@title', year: #@year, country: #@country, date: #@date, genre: '#@genre', length: #@length, rating: #@rating, director: '#@director', actors: '#@actors'>"
  end
end

class NewMovie < Movie
  def initialize(link, title, year, country, date, genre, length, rating, director, actors)
    super(link, title, year, country, date, genre, length, rating, director, actors)
    @period = :new
  end

  def to_s
    years = 2017 - @year.to_i #Date.now.year
    "#@title - latest, was released #{years} years ago!"
  end

  def inspect
    "<NewMovie title: '#@title', year: #@year, country: #@country, date: #@date, genre: '#@genre', length: #@length, rating: #@rating, director: '#@director', actors: '#@actors'>"
  end
end