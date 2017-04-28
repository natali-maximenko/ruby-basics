require 'date'
require 'virtus'

module Cinema
  class CommaString < Virtus::Attribute
    def coerce(value)
      value.is_a?(String) ? value.split(',') : value.join(',')
    end
  end

  class Movie
    include Virtus.model
    attribute :link, String
    attribute :title, String
    attribute :year, Integer
    attribute :country, String
    attribute :date, Date
    attribute :genre, CommaString
    attribute :length, String
    attribute :rating, Float
    attribute :director, String
    attribute :actors, CommaString
    attribute :collection
    INFO = %i[link title year country release_date genre length rating director actors collection]

    def self.create(movie, collection = nil)
      movie.push(collection)
      movie_hash = INFO.zip(movie).to_h
      year = movie_hash[:year].to_i
      if /\D/.match(movie_hash[:year]) || year < 1900
        raise ArgumentError, "#{movie_hash[:year]} is not valid year"
      end
      case year
      when 1900..1944
        AncientMovie.new(movie_hash)
      when 1945..1967
        ClassicMovie.new(movie_hash)
      when 1968..1999
        ModernMovie.new(movie_hash)
      else
        NewMovie.new(movie_hash)
      end
    end

    def genre?(search_genre)
      genre.include?(search_genre)
    end

    def match?(key, value)
      field = send(key)
      if field.instance_of?(Array)
        if value.instance_of?(Array)
          value.any? { |v| field.include?(v) }
        else
          field.grep(value).any?
        end
      else
        value === field
      end
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
      if @collection.nil?
        raise ArgumentError, 'Have no info about movies collection'
      end
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
      "#{@title} - latest, was released #{years} years ago!"
    end
  end
end
