require './movie.rb'
require 'csv'
require 'date'

class MovieCollection
  attr_accessor :collection

  def initialize(filename)
    unless File.exists?(filename)
      raise ArgumentError, "File #{filename} not found"
    end

    @collection = CSV.read(filename, col_sep: '|').map do |movie|
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
  end

  def all
    @collection
  end

  def sort_by(field)
    @collection.map
               .sort_by { |movie| movie.send(field)  }
  end

  def filter(**attrs_hash)
    attrs_hash.reduce(@collection) { |memo, (key, value)|
      memo.select { |movie| movie.match?(key, value) }
    }
  end

  def stats(key)
    @collection.flat_map(&key)
               .sort
               .group_by { |v| v }
               .map { |v, values| {v => values.count} }
  end
end