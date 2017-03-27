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
    new(info[0], info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
  end

  def self.load_from_array(info)
    new(info[0], info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
  end

  def get_var(name)
    case name
      when :link
        @link
      when :title
        @title
      when :year
        @year
      when :country
        @country
      when :date
        @date
      when :genre
        @genre
      when :length
        @length
      when :rating
        @rating
      when :director
        @director
      when :actors
        @actors
    end
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

#  def inspect
#    "#@title (#@release_date; #@genre; #@country; #@rating) - #@length"
#  end

  def to_s
    "Movie: #@title (#@date; #@genre; #@country; #@rating) - #@length"
  end

  def to_h
    { link: @link, title: @title, year: @year, country: @country, date: @date, genre: @genre,
      length: @length, rating: @rating, director: @director, actors: @actors }
  end
end