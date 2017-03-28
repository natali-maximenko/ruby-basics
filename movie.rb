class Movie
  attr_accessor :link, :title, :year, :country, :date,
                :genre, :length, :rating, :director, :actors

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

  def has_genre?(search_genre)
    genre.include?(search_genre)
  end

  def actors
    @actors.split(',')
  end

  def genre
    @genre.split(',')
  end

  def inspect
    "<Movie title: '#@title', year: #@year, country: #@country, date: #@date, genre: '#@genre', length: #@length, rating: #@rating, director: '#@director', actors: '#@actors'>\n"
  end

  def to_s
    "Movie: #@title (#@date; #@genre; #@country; #@rating) - #@length"
  end
end