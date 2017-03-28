require './movie.rb'
require 'csv'

class MovieCollection
  attr_accessor :collection

  def initialize(filename)
    unless File.exists?(filename)
      raise ArgumentError, "File #{filename} not found"
    end

    @collection = CSV.read(filename, col_sep: '|').map do |movie|
      Movie.load_from_array(movie)
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
    filtered_collection = @collection
    attrs_hash.each {|key, value|
      filtered_collection = filtered_collection.select { |movie|
          movie.match?(key, value)
      }
    }
    filtered_collection
  end

  def stats(field, value=nil)
    if field == :director
      @collection.group_by { |movie| movie.send(field) } # get arrays by field
                 .sort_by(&:first) # sort by field
                 .each { |attr, movies| puts "#{attr}: #{movies.count} films" }
    elsif field == :actors
      @collection.select { |movie| movie.send(field).include?(value) }
                 .group_by { |movie| value }
                 .sort_by(&:first) # sort by field
                 .each { |attr, movies| puts "#{attr}: #{movies.count} films" }
    end

  end
end